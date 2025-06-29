//
//  ExitManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 23/06/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef ExitManager_hpp
#define ExitManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <dispatch/dispatch.h>
#include "Log.h"
#include "ASString.h"
#include "CommonAPI.hpp"
#include "Singleton.hpp"
#include "EncodedDatum.h"
#include "AppGuardChecker.hpp"

class __attribute__((visibility("hidden"))) ExitManager
{
public:
    void callExit();

private:
    void exitBasic();
    void _exitBasic();
    void exitAssembly2();
    void exitAssembly();
    
    void createExitQueue();
    void create_ExitQueue();
    void createExitSCQueue();
    void createExitASMQueue();
};
#endif /* ExitManager_hpp */
