//
//  CommonAPI.hpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 2. 20..
//  Copyright © 2019년 nhnent. All rights reserved.
//

#ifndef CommonAPI_hpp
#define CommonAPI_hpp

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <dlfcn.h>
#include "EncodedDatum.h"
#include "ASString.h"
#include "Base64.hpp"

class __attribute__((visibility("hidden"))) CommonAPI
{
public:
    // string
    static int cStrcmp(const char *cs, const char *ct);
    static int cStrncmp(const char *cs, const char *ct, size_t count);
    static char *cStrcpy(char *dest, const char *src);
    static char *cStrncpy(char *dest, const char *src, size_t count);
    static char *cStrcat(char *dest, const char *src);
    static char *cStrncat(char *dest, const char *src, size_t count);
    static char *cStrstr(const char *s1, const char *s2);
    static size_t cStrlen(const char *s);
    static size_t cStrnlen(const char *s, size_t count);
    
    // sleep
    static int cSleepA(int sec);
    static int cSleepB(int sec);
    static int cSleepA1(int sec);
    static int cSleepA2(int sec);
    static int cSleepA3(int sec);
    static int cSleepB1(int sec);
    static int cSleepB2(int sec);
    static int cSleepB3(int sec);
    static void stdSleepFor(int sec);
    static void makeCrash();
};
#endif /* CommonAPI_hpp */


static __inline__ __attribute__((always_inline)) void makeCrash(){ 
    
  
    char data[256] =
    {
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 00-0F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 10-1F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,  /* 20-2F */
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,  /* 30-3F */
        -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,            /* 40-4F */
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,  /* 50-5F */
        -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,  /* 60-6F */
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,  /* 70-7F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 80-8F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 90-9F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* A0-AF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* B0-BF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* C0-CF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* D0-DF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* E0-EF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1   /* F0-FF */
    };
    
    unsigned char* decodeData ;
    int numBytes = 100;
    
    const char* cp;
    int space_idx = 0, phase;
    int d, prev_d = 0;
    unsigned char c;
    space_idx = 0;
    phase = 0;
    int DecodeMimeBase64[256] =
    {
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 00-0F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 10-1F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,  /* 20-2F */
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,  /* 30-3F */
        -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,            /* 40-4F */
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,  /* 50-5F */
        -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,  /* 60-6F */
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,  /* 70-7F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 80-8F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* 90-9F */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* A0-AF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* B0-BF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* C0-CF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* D0-DF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  /* E0-EF */
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1   /* F0-FF */
    };
    
    // 의미없음
    char *cs = "";
    const char *ct = "";
    int count = 50;
    unsigned char c1, c2;
    while (count) {
        c1 = *cs++;
        c2 = *ct++;
        count--;
    }
    //
    
    for (cp = data; *cp != '\0'; ++cp)
    {
        *(cs+200) = DecodeMimeBase64[count];
        d = DecodeMimeBase64[(int)*cp];
        if (d != -1)
        {
            switch (phase)
            {
                case 0:
                    
                    ++phase;
                    break;
                case 1:
                    c = ((prev_d << 2) | ((d & 0x30) >> 4));
                    if (space_idx < numBytes)
                        decodeData[space_idx++] = c;
                    ++phase;
                    break;
                case 2:
                    c = (((prev_d & 0xf) << 4) | ((d & 0x3c) >> 2));
                    if (space_idx < numBytes)
                        decodeData[space_idx++] = c;
                    ++phase;
                    break;
                case 3:
                    c = (((prev_d & 0x03) << 6) | d);
                    if (space_idx < numBytes)
                        decodeData[space_idx++] = c;
                    phase = 0;
                    break;
            }
            prev_d = d;
            
        }
    }
    *(cs+200) = DecodeMimeBase64[count];
}
