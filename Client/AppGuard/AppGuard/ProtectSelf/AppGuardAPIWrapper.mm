//
//  AppGuardAPIWrapper.cpp
//  AppGuard
//
//  Created by NHNEnt on 25/02/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "AppGuardAPIWrapper.hpp"

NSString* AppGuardAPIWrapper::unknown_ = @"unknown";

__attribute__((visibility("hidden"))) int AppGuardAPIWrapper::s(NSString* apiKey, NSString*userName, NSString* appName, NSString* version)
{
    NSString* unknown = @"unknown";
    if (apiKey == nullptr) {
        apiKey = unknown;
    }
    if (userName == nullptr) {
        userName = unknown;
    }
    if (appName == nullptr) {
        appName = unknown;
    }
    if (version == nullptr) {
        version = unknown;
    }
    STInstance(EnvironmentManager)->setBasicInfo(apiKey, userName, appName, version);
    STInstance(PatternManager)->initPatterns();
    STInstance(PolicyManager)->setDefaultPolicy();
    STInstance(TweakManager)->AntiIG();
    
    if(apiKey != nullptr) // CDN에서 앱가드 정책 다운로드 전에 App Key를 확인하는 로직이며 App Key를 전달 받지 못할 경우 그냥 pass 시킴 (앱키를 변경하면 우회가 됨)
    {
        STInstance(PolicyManager)->downloadPolicy(apiKey);
    }
    
    STInstance(LogNCrash)->setUp();
    STInstance(SecurityEventHandler)->callRegisterCallback();
    STInstance(AppGuardChecker)->setCheckFlagE();
    STInstance(ResponseManager)->startResponseThread();
    STInstance(ScanDispatcher)->startScanThread();

    return 0;
}
__attribute__((visibility("hidden"))) int AppGuardAPIWrapper::o(IMP pointer, bool useAlert)
{
    STInstance(SecurityEventHandler)->setObjcCallback(pointer, useAlert);
    return 0;
}
__attribute__((visibility("hidden"))) int AppGuardAPIWrapper::v(void* pointer, bool useAlert)
{
    STInstance(SecurityEventHandler)->setUnityCallback(pointer, useAlert);
    return 0;
}
__attribute__((visibility("hidden"))) int AppGuardAPIWrapper::w(bool useAlert)
{
    STInstance(SecurityEventHandler)->setAlert(useAlert);
    return 0;
}
__attribute__((visibility("hidden"))) int AppGuardAPIWrapper::n(NSString* username)
{
    if (username == nullptr) {
        username = unknown_;
    }
    
    STInstance(EnvironmentManager)->replaceUserId(username);
    return 0;
}
__attribute__((visibility("hidden"))) void AppGuardAPIWrapper::e(NSString* data)
{

}
__attribute__((visibility("hidden"))) void AppGuardAPIWrapper::k()
{
    AppGuardCore3 *AGN = [[AppGuardCore3 alloc]init];
    [AGN sslPinningCheckk];
}

__attribute__((visibility("hidden"))) void AppGuardAPIWrapper::t()
{
    STInstance(PatternManager)->offDebug();
}

__attribute__((visibility("hidden"))) void AppGuardAPIWrapper::z()
{
    STInstance(SecurityEventHandler)->setForceExit();
}

__attribute__((visibility("hidden"))) void AppGuardAPIWrapper::free()
{
    STInstance(DetectManager)->releaseDetectInfos();
    STInstance(PatternManager)->releasePatterns();
}
