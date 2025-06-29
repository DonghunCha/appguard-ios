//
//  UnityInterface.m
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 27..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppGuard/SymbolObfuscate.h>
#include "Diresu.h"
#include "Rednilb.h"
#include "NHNAG.h"
#include "UnityInterface.hpp"

AppGuardCore* diresu;
AppGuardCore2* tmim;
AppGuardCore4* rsas;
AppGuardCore3* agn;

extern "C" {

    __attribute__((visibility("default"))) int a(const char* username)
    {
        return [AppGuardCore setUserName:[NSString stringWithCString:username encoding:[NSString defaultCStringEncoding]]];
    }
    
    __attribute__((visibility("default"))) int b(bool useAlert)
    {
        return [AppGuardCore setUseAlert:useAlert];
    }

    __attribute__((visibility("default"))) void k(const char* signer)
    {
        [AppGuardCore setSignerIntegrity:[NSString stringWithCString:signer encoding:[NSString defaultCStringEncoding]]]; //deprecated.
    }
    
    __attribute__((visibility("default"))) int c(void* pointer, bool useAlert)
    {
        return [AppGuardCore setAppGuardUnityCallback:pointer:useAlert];
    }
    
    __attribute__((visibility("default"))) int d(const char* apikey, const char* version, const char* appName, const char* username)
    {
        return [AppGuardCore doAppGuard:[NSString stringWithCString:apikey encoding:[NSString defaultCStringEncoding]]
                        :[NSString stringWithCString:username encoding:[NSString defaultCStringEncoding]]
                        :[NSString stringWithCString:appName encoding:[NSString defaultCStringEncoding]]
                        :[NSString stringWithCString:version encoding:[NSString defaultCStringEncoding]]
        ];
    }

    __attribute__((visibility("default"))) void h()
    {
        [AppGuardCore offDebugDetect];
    }

    __attribute__((visibility("default"))) void i()
    {
        [AppGuardCore forceExitWithAlert];
    }
    
    __attribute__((visibility("default"))) void e()
    {
        [AppGuardCore2 checkAppGuardRunning]; // check appguard
    }

    __attribute__((visibility("default"))) void g()
    {
        [AppGuardCore4 checkAppGuardHookk]; // check appguard hook
    }

    __attribute__((visibility("default"))) void z() // swizzling
    {
        [AppGuardCore2 checkAppGuardSwizzled]; // swizzling abypass
        ProtectSelf * protectSelf = [[ProtectSelf alloc]init]; // swizzling fly jb
        [protectSelf checkAppGuardSwizzled2];
    }

    __attribute__((visibility("default"))) void cs()
    {
        checkSwizzled();
    }

    __attribute__((visibility("default"))) void cc()
    {
        checkCodeHashByAppGuard();
    }

    __attribute__((visibility("default"))) char* dv(void) {
        
        NSString* deviceId = [AppGuardCore getDeviceID];
        NSUInteger deviceIdBufferLen = [deviceId lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1;
        
        char* outbuffer = (char*)malloc(deviceIdBufferLen);
        if(!outbuffer) {
            return nullptr;
        }
        memset(outbuffer, '\0', deviceIdBufferLen);
        
        const char* kDeviceIdcString = [deviceId cStringUsingEncoding:NSUTF8StringEncoding];
        strncpy(outbuffer, kDeviceIdcString, deviceIdBufferLen);
        
        return outbuffer;
    }

//    __attribute__((visibility("default"))) void sp(bool active) {
//        [AppGuardCoreBlinder protectContent: active == true ? YES : NO];
//    }
//
//    __attribute__((visibility("default"))) void sn(bool active) {
//        [AppGuardCoreBlinder protectSnapshot: active == true ? YES : NO];
//    }

}
