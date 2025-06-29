//
//  SVCManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 03/07/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef SVCManager_hpp
#define SVCManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <sys/syscall.h>
#include "Singleton.hpp"

class __attribute__((visibility("hidden"))) SVCManager
{
public:
    void svcPtrace();
    void svcExit();
    int svcOpen(const char* path);
    bool svcAccess(const char* path);
    bool svcLstat64(const char* path);
    bool svcStat64(const char* path);
    bool svcStatfs64(const char* path);
};
#endif /* SVCManager_hpp */
