//
//  SimulatorManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 06/11/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#include "SimulatorManager.hpp"

__attribute__((visibility("hidden"))) bool SimulatorManager::checkTarget()
{
    bool result = false;
#if TARGET_IPHONE_SIMULATOR
    result = true;
#endif
    return result;
}

__attribute__((visibility("hidden"))) bool SimulatorManager::checkMachine()
{
    bool result = false;
    size_t size = 0l;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
    {
        result = true;
    }
    return result;
}
