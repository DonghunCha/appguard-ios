/*
 *  Portable interface to the CPU cycle counter
 *
 *  Copyright (C) 2006-2015, ARM Limited, All Rights Reserved
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  This file is part of mbed TLS (https://tls.mbed.org)
 */

#if !defined(MBEDTLS_CONFIG_FILE)
#include "config.h"
#else
#include MBEDTLS_CONFIG_FILE
#endif

#if defined(MBEDTLS_SELF_TEST) && defined(MBEDTLS_PLATFORM_C)
#include "platform.h"
#else
#include <stdio.h>
#define mbedtls_printf     printf
#endif

#if defined(MBEDTLS_TIMING_C)

#include "timing.h"

#if !defined(MBEDTLS_TIMING_ALT)

#ifndef asm
#define asm __asm
#endif

#if defined(_WIN32) && !defined(EFIX64) && !defined(EFI32)

#include <windows.h>
#include <winbase.h>

struct _hr_time
{
    LARGE_INTEGER start;
};

#else

#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <signal.h>
#include <time.h>

struct _hr_time
{
    struct timeval start;
};

#endif /* _WIN32 && !EFIX64 && !EFI32 */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    ( defined(_MSC_VER) && defined(_M_IX86) ) || defined(__WATCOMC__)

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long tsc;
    __asm   rdtsc
    __asm   mov  [tsc], eax
    return( tsc );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          ( _MSC_VER && _M_IX86 ) || __WATCOMC__ */

/* some versions of mingw-64 have 32-bit longs even on x84_64 */
#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    defined(__GNUC__) && ( defined(__i386__) || (                       \
    ( defined(__amd64__) || defined( __x86_64__) ) && __SIZEOF_LONG__ == 4 ) )

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long lo, hi;
    asm volatile( "rdtsc" : "=a" (lo), "=d" (hi) );
    return( lo );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && __i386__ */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    defined(__GNUC__) && ( defined(__amd64__) || defined(__x86_64__) )

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long lo, hi;
    asm volatile( "rdtsc" : "=a" (lo), "=d" (hi) );
    return( lo | ( hi << 32 ) );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && ( __amd64__ || __x86_64__ ) */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    defined(__GNUC__) && ( defined(__powerpc__) || defined(__ppc__) )

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long tbl, tbu0, tbu1;

    do
    {
        asm volatile( "mftbu %0" : "=r" (tbu0) );
        asm volatile( "mftb  %0" : "=r" (tbl ) );
        asm volatile( "mftbu %0" : "=r" (tbu1) );
    }
    while( tbu0 != tbu1 );

    return( tbl );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && ( __powerpc__ || __ppc__ ) */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    defined(__GNUC__) && defined(__sparc64__)

#if defined(__OpenBSD__)
#warning OpenBSD does not allow access to tick register using software version instead
#else
#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long tick;
    asm volatile( "rdpr %%tick, %0;" : "=&r" (tick) );
    return( tick );
}
#endif /* __OpenBSD__ */
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && __sparc64__ */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&  \
    defined(__GNUC__) && defined(__sparc__) && !defined(__sparc64__)

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long tick;
    asm volatile( ".byte 0x83, 0x41, 0x00, 0x00" );
    asm volatile( "mov   %%g1, %0" : "=r" (tick) );
    return( tick );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && __sparc__ && !__sparc64__ */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&      \
    defined(__GNUC__) && defined(__alpha__)

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long cc;
    asm volatile( "rpcc %0" : "=r" (cc) );
    return( cc & 0xFFFFFFFF );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && __alpha__ */

#if !defined(HAVE_HARDCLOCK) && defined(MBEDTLS_HAVE_ASM) &&      \
    defined(__GNUC__) && defined(__ia64__)

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    unsigned long itc;
    asm volatile( "mov %0 = ar.itc" : "=r" (itc) );
    return( itc );
}
#endif /* !HAVE_HARDCLOCK && MBEDTLS_HAVE_ASM &&
          __GNUC__ && __ia64__ */

#if !defined(HAVE_HARDCLOCK) && defined(_MSC_VER) && \
    !defined(EFIX64) && !defined(EFI32)

#define HAVE_HARDCLOCK

unsigned long mbedtls_timing_hardclock( void )
{
    LARGE_INTEGER offset;

    QueryPerformanceCounter( &offset );

    return( (unsigned long)( offset.QuadPart ) );
}
#endif /* !HAVE_HARDCLOCK && _MSC_VER && !EFIX64 && !EFI32 */

#if !defined(HAVE_HARDCLOCK)

#define HAVE_HARDCLOCK

static int hardclock_init = 0;
static struct timeval tv_init;

unsigned long mbedtls_timing_hardclock( void )
{
    struct timeval tv_cur;

    if( hardclock_init == 0 )
    {
        gettimeofday( &tv_init, NULL );
        hardclock_init = 1;
    }

    gettimeofday( &tv_cur, NULL );
    return( ( tv_cur.tv_sec  - tv_init.tv_sec  ) * 1000000
          + ( tv_cur.tv_usec - tv_init.tv_usec ) );
}
#endif /* !HAVE_HARDCLOCK */

volatile int mbedtls_timing_alarmed = 0;

#if defined(_WIN32) && !defined(EFIX64) && !defined(EFI32)

unsigned long mbedtls_timing_get_timer( struct mbedtls_timing_hr_time *val, int reset )
{
    unsigned long delta;
    LARGE_INTEGER offset, hfreq;
    struct _hr_time *t = (struct _hr_time *) val;

    QueryPerformanceCounter(  &offset );
    QueryPerformanceFrequency( &hfreq );

    delta = (unsigned long)( ( 1000 *
        ( offset.QuadPart - t->start.QuadPart ) ) /
           hfreq.QuadPart );

    if( reset )
        QueryPerformanceCounter( &t->start );

    return( delta );
}

/* It's OK to use a global because alarm() is supposed to be global anyway */
static DWORD alarmMs;

static DWORD WINAPI TimerProc( LPVOID TimerContext )
{
    ((void) TimerContext);
    Sleep( alarmMs );
    mbedtls_timing_alarmed = 1;
    return( TRUE );
}

void mbedtls_set_alarm( int seconds )
{
    DWORD ThreadId;

    mbedtls_timing_alarmed = 0;
    alarmMs = seconds * 1000;
    CloseHandle( CreateThread( NULL, 0, TimerProc, NULL, 0, &ThreadId ) );
}

#else /* _WIN32 && !EFIX64 && !EFI32 */

unsigned long mbedtls_timing_get_timer( struct mbedtls_timing_hr_time *val, int reset )
{
    unsigned long delta;
    struct timeval offset;
    struct _hr_time *t = (struct _hr_time *) val;

    gettimeofday( &offset, NULL );

    if( reset )
    {
        t->start.tv_sec  = offset.tv_sec;
        t->start.tv_usec = offset.tv_usec;
        return( 0 );
    }

    delta = ( offset.tv_sec  - t->start.tv_sec  ) * 1000
          + ( offset.tv_usec - t->start.tv_usec ) / 1000;

    return( delta );
}

static void sighandler( int signum )
{
    mbedtls_timing_alarmed = 1;
    signal( signum, sighandler );
}

void mbedtls_set_alarm( int seconds )
{
    mbedtls_timing_alarmed = 0;
    signal( SIGALRM, sighandler );
    alarm( seconds );
}

#endif /* _WIN32 && !EFIX64 && !EFI32 */

/*
 * Set delays to watch
 */
void mbedtls_timing_set_delay( void *data, uint32_t int_ms, uint32_t fin_ms )
{
    mbedtls_timing_delay_context *ctx = (mbedtls_timing_delay_context *) data;

    ctx->int_ms = int_ms;
    ctx->fin_ms = fin_ms;

    if( fin_ms != 0 )
        (void) mbedtls_timing_get_timer( &ctx->timer, 1 );
}

/*
 * Get number of delays expired
 */
int mbedtls_timing_get_delay( void *data )
{
    mbedtls_timing_delay_context *ctx = (mbedtls_timing_delay_context *) data;
    unsigned long elapsed_ms;

    if( ctx->fin_ms == 0 )
        return( -1 );

    elapsed_ms = mbedtls_timing_get_timer( &ctx->timer, 0 );

    if( elapsed_ms >= ctx->fin_ms )
        return( 2 );

    if( elapsed_ms >= ctx->int_ms )
        return( 1 );

    return( 0 );
}

#endif /* !MBEDTLS_TIMING_ALT */

#if defined(MBEDTLS_SELF_TEST)

/*
 * Busy-waits for the given number of milliseconds.
 * Used for testing mbedtls_timing_hardclock.
 */
static void busy_msleep( unsigned long msec )
{
    struct mbedtls_timing_hr_time hires;
    unsigned long i = 0; /* for busy-waiting */
    volatile unsigned long j; /* to prevent optimisation */

    (void) mbedtls_timing_get_timer( &hires, 1 );

    while( mbedtls_timing_get_timer( &hires, 0 ) < msec )
        i++;

    j = i;
    (void) j;
}

#define FAIL    do                      \
{                                       \
    if( verbose != 0 )                  \
        mbedtls_printf( "failed\n" );   \
                                        \
    return( 1 );                        \
} while( 0 )

/*
 * Checkup routine
 *
 * Warning: this is work in progress, some tests may not be reliable enough
 * yet! False positives may happen.
 */
int mbedtls_timing_self_test( int verbose )
{
    unsigned long cycles, ratio;
    unsigned long millisecs, secs;
    int hardfail;
    struct mbedtls_timing_hr_time hires;
    uint32_t a, b;
    mbedtls_timing_delay_context ctx;

    if( verbose != 0 )
        mbedtls_printf( "  TIMING tests note: will take some time!\n" );


    if( verbose != 0 )
        mbedtls_printf( "  TIMING test #1 (set_alarm / get_timer): " );

    for( secs = 1; secs <= 3; secs++ )
    {
        (void) mbedtls_timing_get_timer( &hires, 1 );

        mbedtls_set_alarm( (int) secs );
        while( !mbedtls_timing_alarmed )
            ;

        millisecs = mbedtls_timing_get_timer( &hires, 0 );

        /* For some reason on Windows it looks like alarm has an extra delay
         * (maybe related to creating a new thread). Allow some room here. */
        if( millisecs < 800 * secs || millisecs > 1200 * secs + 300 )
        {
            if( verbose != 0 )
                mbedtls_printf( "failed\n" );

            return( 1 );
        }
    }

    if( verbose != 0 )
        mbedtls_printf( "passed\n" );

    if( verbose != 0 )
        mbedtls_printf( "  TIMING test #2 (set/get_delay        ): " );

    for( a = 200; a <= 400; a += 200 )
    {
        for( b = 200; b <= 400; b += 200 )
        {
            mbedtls_timing_set_delay( &ctx, a, a + b );

            busy_msleep( a - a / 8 );
            if( mbedtls_timing_get_delay( &ctx ) != 0 )
                FAIL;

            busy_msleep( a / 4 );
            if( mbedtls_timing_get_delay( &ctx ) != 1 )
                FAIL;

            busy_msleep( b - a / 8 - b / 8 );
            if( mbedtls_timing_get_delay( &ctx ) != 1 )
                FAIL;

            busy_msleep( b / 4 );
            if( mbedtls_timing_get_delay( &ctx ) != 2 )
                FAIL;
        }
    }

    mbedtls_timing_set_delay( &ctx, 0, 0 );
    busy_msleep( 200 );
    if( mbedtls_timing_get_delay( &ctx ) != -1 )
        FAIL;

    if( verbose != 0 )
        mbedtls_printf( "passed\n" );

    if( verbose != 0 )
        mbedtls_printf( "  TIMING test #3 (hardclock / get_timer): " );

    /*
     * Allow one failure for possible counter wrapping.
     * On a 4Ghz 32-bit machine the cycle counter wraps about once per second;
     * since the whole test is about 10ms, it shouldn't happen twice in a row.
     */
    hardfail = 0;

hard_test:
    if( hardfail > 1 )
    {
        if( verbose != 0 )
            mbedtls_printf( "failed (ignored)\n" );

        goto hard_test_done;
    }

    /* Get a reference ratio cycles/ms */
    millisecs = 1;
    cycles = mbedtls_timing_hardclock();
    busy_msleep( millisecs );
    cycles = mbedtls_timing_hardclock() - cycles;
    ratio = cycles / millisecs;

    /* Check that the ratio is mostly constant */
    for( millisecs = 2; millisecs <= 4; millisecs++ )
    {
        cycles = mbedtls_timing_hardclock();
        busy_msleep( millisecs );
        cycles = mbedtls_timing_hardclock() - cycles;

        /* Allow variation up to 20% */
        if( cycles / millisecs < ratio - ratio / 5 ||
            cycles / millisecs > ratio + ratio / 5 )
        {
            hardfail++;
            goto hard_test;
        }
    }

    if( verbose != 0 )
        mbedtls_printf( "passed\n" );

hard_test_done:

    if( verbose != 0 )
        mbedtls_printf( "\n" );

    return( 0 );
}

#endif /* MBEDTLS_SELF_TEST */

#endif /* MBEDTLS_TIMING_C */
