//
//  NewUnityInterface.cpp
//  AppGuard
//
//  Created by NHNEnt on 2020/07/30.
//  Copyright © 2020 nhnent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Diresu.h"
#include "NHNAG.h"


// -------------------------------------------------------------------------------
// --------------------------------Deprecated-------------------------------------
// -------------------------------------------------------------------------------

AppGuardCore* diresu_;
AppGuardCore2* tmim_;
AppGuardCore4* rsas_;
AppGuardCore3* agn_;
RNCryptorUnLoader* rcul;

extern "C" {
    __attribute__((visibility("default"))) void SMJKDJKWJKNS()
    {
        [AppGuardCore3 checkTweak2];
    }
    __attribute__((visibility("default"))) void KDJKWJKNSSMJ()
    {
        [AppGuardCore3 checkTweak3];
    }
    __attribute__((visibility("default"))) void KWJKNSSMJKDJ()
    {
        [AppGuardCore3 checkTweak4];
    }
    __attribute__((visibility("default"))) void KWJKDJKNSSMJ()
    {
        [AppGuardCore4 checkTweakk2];
    }
    __attribute__((visibility("default"))) void KWJSMJKDJKNS()
    {
        [AppGuardCore4 checkTweakk3];
    }
    __attribute__((visibility("default"))) void KNSKWJSMJKDJ()
    {
        [AppGuardCore4 checkTweakk4];
    }
    __attribute__((visibility("default"))) void KWJKNSKDJSMJ()
    {
        [AppGuardCore3 checkTweak2];
        [AppGuardCore4 checkTweakk2];
    }
    __attribute__((visibility("default"))) void SMJKNSKWJKDJ()
    {
        [AppGuardCore3 checkTweak3];
        [AppGuardCore4 checkTweakk3];
    }
    __attribute__((visibility("default"))) void KNSSMJKDJKWJ()
    {
        [AppGuardCore3 checkTweak4];
        [AppGuardCore4 checkTweakk4];
    }
    __attribute__((visibility("default"))) void KNSSMJKWJKDJ()
    {
        [AppGuardCore3 checkTweak2];
        [AppGuardCore4 checkTweakk2];
        [AppGuardCore3 checkTweak3];
        [AppGuardCore4 checkTweakk3];
        [AppGuardCore3 checkTweak4];
        [AppGuardCore4 checkTweakk4];
    }
    __attribute__((visibility("default"))) void RefreshInvenInfoData()
    {
        [AppGuardCore3 antiABypass]; // check abypass
        [AppGuardCore2 detectTweak]; // anti ig
    }
    __attribute__((visibility("default"))) void CheckUserIdCollision(const char* a)
    {
        return [AppGuardCore4 checkTweak5:[NSString stringWithCString:a encoding:[NSString defaultCStringEncoding]]];
    }
    __attribute__((visibility("default"))) void SetCrashLogController()
    {
        [AppGuardCore4 antiIOSGod];
    }
    __attribute__((visibility("default"))) void checkNetworkCollision()
    {
        [RNCryptorUnLoader unload];
    }
    __attribute__((visibility("default"))) void setSignalController()
    {
        [RNCryptorUnLoader error];
    }
    __attribute__((visibility("default"))) void setSearchLogController()
    {
        [RNCryptorUnLoader check];
    }
    __attribute__((visibility("default"))) void checkDeviceCollision()
    {
        [RNCryptorUnLoader finish];
    }
}
