//
//  ProcPattern.h
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef ProcPattern_h
#define ProcPattern_h

#include <stdio.h>
#include "Pattern.h"

enum processCheckType
{
    kSandBox = 1,
    kDyld = 2,
    kEnv = 3,
    kDirectoryPermission = 4,
    kInsertLib = 5,
    kClass = 6,
    kInject = 7,
    kExecProcess = 8,
    kDebugInfo = 9,
    kDebugTTY = 10,
    kDebugExceptionPort = 11,
    kTextMemory = 12,
    kSignatrueHash = 13,
    kSimulatorTarget = 14,
    kHardwareMachine = 15,
    kCAPI = 16,
    kObjCAPI = 17,
    kAGAPI = 18,
    kSSL = 19,
    kSigner = 20,
    kJailbreakTest = 21,
    kReactNativeJsBundle = 22,
    kFlutterIntegrity = 23,
    
};

class __attribute__((visibility("hidden"))) ProcPattern : public Pattern
{
public:
    int checkType_;
    std::string processName_;

    ProcPattern(Pattern patternBase, int checkType, const char* processName);
};

#endif /* ProcPattern_h */
