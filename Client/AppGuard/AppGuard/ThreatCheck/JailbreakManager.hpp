//
//  JailbreakManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef JailbreakManager_hpp
#define JailbreakManager_hpp

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <vector>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <crt_externs.h>
#include <mach/task.h>
#include <mach/task_info.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include "Log.h"
#include "Util.h"
#include "Pattern.h"
#include "ASString.h"
#include "CommonAPI.hpp"
#include "Singleton.hpp"
#include "EncodedDatum.h"
#include "DetectManager.hpp"
#include "SimulatorManager.hpp"

typedef char int8;
typedef int8 BYTE;

class __attribute__((visibility("hidden"))) JailbreakManager
{
public:
    bool checkSandbox();
    bool checkDyld(const char* libName);
    bool checkCydiaUrl();
    bool checkDirectoryPermission();
    bool checkInsertLib(const char* libName);
    bool checkClass(const char* className);
    bool checkInject(const char* functionName);
    bool checkABypass();
    bool checkEnv(const char* envString);
    bool detectTest();
    
private:
    bool checkFork();
    bool checkDyldA(const char* libName);
    bool checkDyldB(const char* libName);
    bool checkDyldC(const char* libName);
    bool checkEnvA(const char* envString);
    bool checkEnvB(const char* envString);
};

#endif /* JailbreakManager_hpp */
