//
//  ExitManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 23/06/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "ExitManager.hpp"

__attribute__((visibility("hidden"))) void ExitManager::callExit()
{
    void (*func_exit)(int) = (void(*)(int))dlsym(RTLD_SELF, SECURE_STRING(fname_exit));
    if(func_exit) {
        func_exit(0);
    }
    
    createExitQueue();
    create_ExitQueue();
    createExitSCQueue();
    createExitASMQueue();
    STInstance(AppGuardChecker)->checkExit();
}

__attribute__((visibility("hidden"))) void ExitManager::createExitQueue()
{
    NSOperationQueue *appguardExitQueue = [[NSOperationQueue alloc] init];
    [appguardExitQueue addOperationWithBlock:^{
        exitBasic();
     }];
}
__attribute__((visibility("hidden"))) void ExitManager::exitBasic()
{
    STInstance(AppGuardChecker)->setCheckExitFlagA();
    exit(0);
}
__attribute__((visibility("hidden"))) void ExitManager::create_ExitQueue()
{
    NSOperationQueue *appguard_ExitQueue = [[NSOperationQueue alloc] init];
    [appguard_ExitQueue addOperationWithBlock:^{
        _exitBasic();
     }];
}
__attribute__((visibility("hidden"))) void ExitManager::_exitBasic()
{
    STInstance(AppGuardChecker)->setCheckExitFlagB();
    _exit(0);
}
__attribute__((visibility("hidden"))) void ExitManager::createExitSCQueue()
{
    NSOperationQueue *appguardExitSCQueue = [[NSOperationQueue alloc] init];
    [appguardExitSCQueue addOperationWithBlock:^{
        exitAssembly2();
     }];
}
__attribute__((visibility("hidden"))) void ExitManager::exitAssembly2()
{
    STInstance(AppGuardChecker)->setCheckExitFlagC();
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, #0");
    __asm __volatile("mul x0, x0, x0");
    __asm __volatile("mov w1, #0");
    __asm __volatile("mov w2, #1");
    __asm __volatile("add w3, w2, w1");
    __asm __volatile("mov w16, w3");
    __asm __volatile("svc #0x80");
#else
    syscall(SYS_exit, 0);
#endif
}
__attribute__((visibility("hidden"))) void ExitManager::createExitASMQueue()
{
    NSOperationQueue *appguardExitASMQueue = [[NSOperationQueue alloc] init];
    [appguardExitASMQueue addOperationWithBlock:^{
        exitAssembly();
     }];
}
__attribute__((visibility("hidden"))) void ExitManager::exitAssembly()
{
    STInstance(AppGuardChecker)->setCheckExitFlagD();
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, #0");
    __asm __volatile("mul x0, x0, x0");
    __asm __volatile("mov w1, #0");
    __asm __volatile("mov w2, #1");
    __asm __volatile("add w3, w2, w1");
    __asm __volatile("mov w16, w3");
    __asm __volatile("svc #0x80");
#else
    syscall(SYS_exit, 0);
#endif
}
