//
//  SimulatorManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 06/11/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef SimulatorManager_hpp
#define SimulatorManager_hpp

#import <Foundation/Foundation.h>
#include <sys/sysctl.h>
#include <stdio.h>
#include "Log.h"

class __attribute__((visibility("hidden"))) SimulatorManager
{
public:
    bool checkTarget();
    bool checkMachine();
};

#endif /* SimulatorManager_hpp */
