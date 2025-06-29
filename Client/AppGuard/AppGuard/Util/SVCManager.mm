//
//  SVCManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 03/07/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "Log.h"
#include "SVCManager.hpp"

__attribute__((visibility("hidden"))) void SVCManager::svcPtrace()
{
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, #26");
    __asm __volatile("mov x1, #31");
    __asm __volatile("mov x2, #0");
    __asm __volatile("mov x3, #0");
    __asm __volatile("mov x16, #0");
    __asm __volatile("svc #0x80");
    
#else
    syscall(SYS_ptrace, 31, 0, 0);
#endif
}

__attribute__((visibility("hidden"))) void SVCManager::svcExit()
{
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, #0");
    __asm __volatile("mov w16, #1");
    __asm __volatile("svc #80");
#else
    syscall(SYS_exit, 0);
#endif
}

__attribute__((visibility("hidden"))) int SVCManager::svcOpen(const char* path)
{
    int flag = 0;
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, %0" :: "r" (path));
    __asm __volatile("mov x1, #0");
    __asm __volatile("mov x2, #0");
    __asm __volatile("mov x16, #0x5");
    __asm __volatile("svc #0x80");
    __asm __volatile("bcc #0xC");
    __asm __volatile("mov x0, #0x0");
    __asm __volatile("b #0x8");
    __asm __volatile("mov x0, #0x1");
    __asm __volatile("mov %0, x0" : "=r" (flag));
#else
    flag = syscall(SYS_open, path, 0);
    if (flag == -1) {
        AGLog(@"syscall(SYS_open) - unavailable");
        return -1;
    }
#endif
    return flag;
}

__attribute__((visibility("hidden"))) bool SVCManager::svcAccess(const char* path)
{
    bool result = false;
#if defined __arm64__ || defined __arm64e__
    int64_t flag = ENOENT;
    __asm __volatile("mov x0, %0" :: "r" (path));
    __asm __volatile("mov x1, #0");
    __asm __volatile("mov x16, #0x21");
    __asm __volatile("svc #0x80");
    __asm __volatile("mov %0, x0" : "=r" (flag));
#else
    int flag = syscall(SYS_access, path, 0);
    if (flag == -1) {
        AGLog(@"syscall(SYS_access) - unavailable");
        return result;
    }
#endif
    if(flag != ENOENT )
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool SVCManager::svcLstat64(const char* path)
{
    bool result = false;
    struct stat statPoint;
#if defined __arm64__ || defined __arm64e__
    int64_t flag = ENOENT;
    __asm __volatile("mov x0, %0" :: "r" (path));
    __asm __volatile("mov x1, %0" :: "r" (&statPoint));
    __asm __volatile("mov x16, #0x154");
    __asm __volatile("svc #0x80");
    __asm __volatile("mov %0, x0" : "=r" (flag));
#else
    int flag = syscall(SYS_lstat, path, statPoint);
    if (flag == -1) {
        AGLog(@"syscall(SYS_lstat) - unavailable");
        return result;
    }
#endif
    if(flag != ENOENT)
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool SVCManager::svcStat64(const char* path)
{
    bool result = false;
    struct stat statPoint;
#if defined __arm64__ || defined __arm64e__
    int64_t flag = ENOENT;
    __asm __volatile("mov x0, %0" :: "r" (path));
    __asm __volatile("mov x1, %0" :: "r" (&statPoint));
    __asm __volatile("mov x16, #0x152");
    __asm __volatile("svc #0x80");
    __asm __volatile("mov %0, x0" : "=r" (flag));
#else
    int flag = syscall(SYS_stat64, path, statPoint);
    if (flag == -1) {
        AGLog(@"syscall(SYS_stat64) - unavailable");
        return result;
    }
#endif
    if (flag != ENOENT)
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool SVCManager::svcStatfs64(const char* path)
{
    bool result = false;
    struct statfs statfsPoint;
#if defined __arm64__ || defined __arm64e__
    int64_t flag = ENOENT;
    __asm __volatile("mov x0, %0" :: "r" (path));
    __asm __volatile("mov x1, %0" :: "r" (&statfsPoint));
    __asm __volatile("mov x16, #0x159");
    __asm __volatile("svc #0x80");
    __asm __volatile("mov %0, x0" : "=r" (flag));
#else
    int flag = syscall(SYS_statfs64, path, statfsPoint);
    if (flag == -1) {
        AGLog(@"syscall(SYS_statfs64) - unavailable");
        return result;
    }
#endif
    if(flag != ENOENT)
    {
        result = true;
    }
    return result;
}
