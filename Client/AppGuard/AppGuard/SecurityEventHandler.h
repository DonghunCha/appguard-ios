//
//  SecurityEventHandler.h
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 4..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef SecurityEventHandler_h
#define SecurityEventHandler_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#include <stdio.h>
#include <dlfcn.h>
#include <string.h>
#include <unistd.h>
#include <objc/objc.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <objc/runtime.h>
#include <mach-o/dyld.h>
#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "Singleton.hpp"
#include "CommonAPI.hpp"
#include "EncodedDatum.h"
#include "ExitManager.hpp"
#include "DetectManager.hpp"
#include "EncryptionAPI.hpp"

class __attribute__((visibility("hidden"))) SecurityEventHandler {
public:
    SecurityEventHandler();
    
    void throwSecurityEvent(DetectInfo* detectInfo);
    void setObjcCallback(IMP funtion, bool useAlert);
    void setUnityCallback(void* funtion, bool useAlert);
    void setAlert(bool useAlert);
    void callRegisterCallback();
    void showAlertWindow(DetectInfo* detectInfo);
    bool getFreeAlert();
    void callUserCallback(NSString* msg);
    void setForceExit();
    bool getForceExit();
private:
    dispatch_queue_t appguardExitQueue;
    
    bool useAlert_ = false;
    bool freeAlert_ = false;
    bool existAlertWindow_ = false;
    bool useForceExit = false;
    
    void (*AGCallback)(id, SEL, NSString*);
    void (*UnityCallback)(const char*);    
    void doAlert(DetectInfo* detectInfo);
    NSData* getDetectJson(DetectInfo* detectInfo);
    NSString* getDetectCode(DetectInfo* detectInfo);
    int forceExitSecond = 10;
    int forceCrashSecond = 10;
};

#endif /* SecurityEventHandler_h */
