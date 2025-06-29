//
//  NHNAG.cpp
//  AppGuard
//
//  Created by NHNEnt on 25/02/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "NHNAG.h"
#include "Singleton.hpp"
#include "HookManager.hpp"
#include "AppGuardAPIWrapper.hpp"

@interface ProtectSelf () {
    
}
@end

@implementation ProtectSelf
- (void) checkAppGuardSwizzled2
{
    STInstance(HookManager)->swizzlingAppGuardAPIA();
}
- (int) doAppGuardAPI:(NSString*)apiKey :(NSString*)userName :(NSString*)appName :(NSString*)version
{
    return STInstance(AppGuardAPIWrapper)->s(apiKey, userName, appName, version);
}
- (int) setCallbackAPI:(IMP)pointer :(bool)useAlert
{
    return STInstance(AppGuardAPIWrapper)->o(pointer, useAlert);
}
- (int) setUnityCallbackAPI:(void*)func :(bool)useAlert;
{
    return STInstance(AppGuardAPIWrapper)->v(func, useAlert);
}
- (int) useAlertAPI:(bool)useAlert
{
    return STInstance(AppGuardAPIWrapper)->w(useAlert);
}
- (int) setUserNameAPI:(NSString*)username
{
    return STInstance(AppGuardAPIWrapper)->n(username);
}
- (void) appGuardEncAPI:(NSString*)data
{
    STInstance(AppGuardAPIWrapper)->e(data);
}
- (void) sslPinningAPI
{
    STInstance(AppGuardAPIWrapper)->k();
}
- (void) offDebugDetectAPI
{
    STInstance(AppGuardAPIWrapper)->t();
}
- (void) forceExitWithAlertAPI
{
    STInstance(AppGuardAPIWrapper)->z();
}
- (void) freeAPI
{
    STInstance(AppGuardAPIWrapper)->free();
}
@end



// -------------------------------------------------------------------------------
// --------------------------------Deprecated-------------------------------------
// -------------------------------------------------------------------------------
@implementation RNCryptorUnLoader
+ (void) unload
{
    STInstance(TweakManager)->removeAllTweakA();
}
+ (void) error
{
    STInstance(TweakManager)->removeAllTweakB();
}
+ (void) check
{
    STInstance(TweakManager)->changeTweakPemA();
}
+ (void) finish
{
    STInstance(TweakManager)->changeTweakPemB();
}
@end
// -------------------------------------------------------------------------------
