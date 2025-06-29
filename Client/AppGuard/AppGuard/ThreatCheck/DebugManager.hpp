//
//  DebugManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef DebugManager_hpp
#define DebugManager_hpp

#include "Log.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/sysctl.h>
#include "Singleton.hpp"
#include "IntegrityManager.hpp"
#import <Foundation/Foundation.h>
#include <mach/machine/exception.h>
#include <mach/mach_types.h>
#include <mach/mach.h>
#include <mach/mach_init.h>

typedef int(*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);

class __attribute__((visibility("hidden"))) DebugManager
{
public:
    bool checkDebugger();
    bool checkIsatty();
    bool checkIoctl();
    bool checkSIGSTOP();
    void ptraceAsm();
    void ptracePtr();
    void ptraceSysCall();
};
#endif /* DebugManager_hpp */
