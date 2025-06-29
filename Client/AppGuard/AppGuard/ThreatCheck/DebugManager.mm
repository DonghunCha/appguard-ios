//
//  DebugManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#include "DebugManager.hpp"

__attribute__((visibility("hidden"))) void DebugManager::ptraceAsm()
{
    if(Util::checkAppStoreBuild())
    {
#if defined __arm64__ || defined __arm64e__
        asm volatile
        (
             "mov x0, #26\n"
             "mov x1, #31\n"
             "mov x2, #0\n"
             "mov x3, #0\n"
             "mov x16, #0\n"
             "svc #128\n"
        );
#else
        syscall(26, 31, 0, 0);
#endif
    }
}

__attribute__((visibility("hidden"))) void DebugManager::ptracePtr()
{
    if(Util::checkAppStoreBuild())
    {
        void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
        ptrace_ptr_t ptrace_ptr = reinterpret_cast<ptrace_ptr_t>(dlsym(handle, SECURE_STRING(ptrace)));
        ptrace_ptr(31, 0, 0, 0);
        dlclose(handle);
    }
}

__attribute__((visibility("hidden"))) void DebugManager::ptraceSysCall()
{
    if(Util::checkAppStoreBuild())
    {
        syscall(26, 31, 0, 0);
    }
}

__attribute__((visibility("hidden"))) bool DebugManager::checkDebugger()
{
    bool result = false;
    
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret = 0, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    ret = sysctl(name, 4, &info, &size, NULL, 0);
    AGLog(@"ret - [%d]", ret);
    
    if (ret != 0)
    {
        AGLog(@"sysctl() failed for some reason");
        return false; /* sysctl() failed for some reason */
    }
    
    result = (info.kp_proc.p_flag & P_TRACED) ? true : false;
    AGLog(@"Result - [%d]", result);
    return result;
}

// @author  : daejoon kim
// @return  : 디버깅 탐지 결과값
// @brief   : isatty를 이용하여 디버깅 탐지
__attribute__((visibility("hidden"))) bool DebugManager::checkIsatty()
{
    bool result = false;
    if(isatty(1))
    {
        AGLog(@"Found isatty");
        result = true;
    }

    return result;
}

// @author  : daejoon kim
// @return  : 디버깅 탐지 결과값
// @brief   : ioctl를 이용하여 디버깅 탐지
// @brief   : 디버깅 사용시 탐지가 아닌 앱이 종료되는 현상이 발생하여 보류
__attribute__((visibility("hidden"))) bool DebugManager::checkIoctl()
{
    bool result = false;
    if(!ioctl(1, TIOCGWINSZ))
    {
        AGLog(@"Found ioctl");
        result = true;
    }

    return result;
}

// @author  : daejoon kim
// @return  : SIGSTOP 되었는지 확인 결과
// @brief   : lldb 탐지
// @brief   : 탐지가 되지 않아 보류
__attribute__((visibility("hidden"))) bool DebugManager::checkSIGSTOP()
{
    __block bool result = false;
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGSTOP, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(source, ^{
        AGLog(@"Detected SIGSTOP");
        result = true;
    });
    dispatch_resume(source);

    return result;
}
