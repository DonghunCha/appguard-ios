//
//  TweakManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 2020/07/28.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef TweakManager_hpp
#define TweakManager_hpp

#include "Log.h"
#include "Util.h"
#include "EnvironmentManager.hpp"
#include <stdio.h>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#import <mach-o/getsect.h>
#include <mach/mach_traps.h>

class __attribute__((visibility("hidden"))) TweakManager
{
public:
    void removeTweakA();
    void removeTweakB();
    void removeTweakC();
    void removeAllTweakA();
    void removeAllTweakB();
    void changeTweakPemA();
    void changeTweakPemB();
    void AntiIG();
private:
    void removeTextSection(char* path);
    char* getTweakName(char* path);
    int getTweakImageNumger(char* name);
    void removeA(void* addr);
    void removeB(void* addr);
    void changeA(void* addr);
    void changeB(void* addr);
    
    bool getType(unsigned int data);
    bool writeData(vm_address_t offset,  unsigned int data);
    
    void patchIGFunction();
    int firstExecute = 0x88;
};
#endif /* TweakManager_hpp */
