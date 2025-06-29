//
//  CommonAPI.cpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 2. 20..
//  Copyright © 2019년 nhnent. All rights reserved.
//
#include "CommonAPI.hpp"
#include <thread>
#include <chrono>
//@biref    : 자체 구현한 strcmp
__attribute__((visibility("hidden"))) int CommonAPI::cStrcmp(const char *cs, const char *ct)
{
    unsigned char c1, c2;
    int res = 0;
    
    do {
        c1 = *cs++;
        c2 = *ct++;
        res = c1 - c2;
        if (res)
            break;
    } while (c1);
    return res;
}

//@biref    : 자체 구현한 strncmp
__attribute__((visibility("hidden"))) int CommonAPI::cStrncmp(const char *cs, const char *ct, size_t count)
{
    unsigned char c1, c2;
    
    while (count) {
        c1 = *cs++;
        c2 = *ct++;
        if (c1 != c2)
            return c1 < c2 ? -1 : 1;
        if (!c1)
            break;
        count--;
    }
    return 0;
}

//@biref    : 자체 구현한 strcpy
__attribute__((visibility("hidden"))) char* CommonAPI::cStrcpy(char *dest, const char *src)
{
    char *tmp = dest;
    
    while ((*dest++ = *src++) != '\0')
    /* nothing */;
    return tmp;
}

//@biref    : 자체 구현한 strncpy
__attribute__((visibility("hidden"))) char* CommonAPI::cStrncpy(char *dest, const char *src, size_t count)
{
    char *tmp = dest;
    
    while (count) {
        if ((*tmp = *src) != 0)
            src++;
        tmp++;
        count--;
    }
    return dest;
}

//@biref    : 자체 구현한 strcat
__attribute__((visibility("hidden"))) char* CommonAPI::cStrcat(char *dest, const char *src)
{
    char *tmp = dest;
    
    while (*dest)
        dest++;
    while ((*dest++ = *src++) != '\0')
        ;
    return tmp;
}

//@biref    : 자체 구현한 strncat
__attribute__((visibility("hidden"))) char* CommonAPI::cStrncat(char *dest, const char *src, size_t count)
{
    char *tmp = dest;
    
    if (count) {
        while (*dest)
            dest++;
        while ((*dest++ = *src++) != 0) {
            if (--count == 0) {
                *dest = '\0';
                break;
            }
        }
    }
    return tmp;
}

//@biref    : 자체 구현한 strlen
__attribute__((visibility("hidden"))) size_t CommonAPI::cStrlen(const char *s)
{
    const char *sc;
    
    for (sc = s; *sc != '\0'; ++sc)
    /* nothing */;
    return sc - s;
}

//@biref    : 자체 구현한 strnlen
__attribute__((visibility("hidden"))) size_t CommonAPI::cStrnlen(const char *s, size_t count)
{
    const char *sc;
    
    for (sc = s; count-- && *sc != '\0'; ++sc)
    /* nothing */;
    return sc - s;
}

__attribute__((visibility("hidden"))) char* CommonAPI::cStrstr(const char *s1, const char *s2)
{
    size_t l1, l2;
    
    l2 = CommonAPI::cStrlen(s2);
    if (!l2)
        return (char *)s1;
    l1 = CommonAPI::cStrlen(s1);
    while (l1 >= l2) {
        l1--;
        if (!memcmp(s1, s2, l2))
            return (char *)s1;
        s1++;
    }
    return NULL;
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepA(int sec)
{
    return cSleepA1(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepB(int sec)
{
    return cSleepB1(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepA1(int sec)
{
    return cSleepA2(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepA2(int sec)
{
    return cSleepA3(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepA3(int sec)
{
    int (*secureSleep)(int) = (int(*)(int))dlsym(RTLD_SELF, SECURE_STRING(sleep));
    return secureSleep(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepB1(int sec)
{
    return cSleepB2(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepB2(int sec)
{
    return cSleepB3(sec);
}

__attribute__((visibility("hidden"))) int CommonAPI::cSleepB3(int sec)
{
    sec = sec * 1000000;
    int (*secureUsleep)(useconds_t) = (int(*)(useconds_t))dlsym(RTLD_SELF, SECURE_STRING(usleep));
    return secureUsleep(sec);
}

__attribute__((visibility("hidden"))) void CommonAPI::stdSleepFor(int sec)
{
    std::this_thread::sleep_for(std::chrono::seconds(sec));
}

// 함수 호출 시 크래시 발생
__attribute__((visibility("hidden"))) void CommonAPI::makeCrash(){
    char * crashValue;
    unsigned char crashValue2[128];

    Base64::decode(SECURE_STRING(default_appkey), crashValue2, 256); // 크래시 발생
    cStrcpy(crashValue, SECURE_STRING(com_apple_storekit)); // 크래시 발생
    cStrncmp(crashValue, SECURE_STRING(finish), 40); // 크래시 발생
}

