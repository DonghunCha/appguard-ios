//
//  AGStatusMonitor.cpp
//  AppGuard
//
//  Created by NHN on 2023/10/25.
//

#include "AGStatusMonitor.hpp"
#import <Foundation/Foundation.h>
#include "AGSelfProtectionUtil.hpp"
#import "Decryptor.hpp"
#import "ExitManager.hpp"
#import "UnityInterface.hpp"
#import "Diresu.h"



__attribute__((visibility("hidden"))) AGStatusMonitor::AGStatusMonitor()
:isBlockDetected_(false),
exitWaitTimeoutCountDown_(kExitWaitTimeoutSec_),
firstDetectInfo_(nullptr) {
}

__attribute__((visibility("hidden"))) AGStatusMonitor::~AGStatusMonitor() {
    exitWaitTimeoutCountDown_ = 0;
    if(firstDetectInfo_) {
        delete firstDetectInfo_;
        firstDetectInfo_ = nullptr;
    }
}

__attribute__((visibility("hidden"))) void AGStatusMonitor::startExitStatusMonitor() {
    NSOperationQueue *exitStatusMonitorQueue = [[NSOperationQueue alloc] init];
    [exitStatusMonitorQueue addOperationWithBlock:^{
        while(exitWaitTimeoutCountDown_ >= 0) {
            @autoreleasepool {
                if(isBlockDetected_) {
                    AGLog(@"isBlocked!!! exitWaitTimeoutCountDown_= %d" , exitWaitTimeoutCountDown_);
                    if(exitWaitTimeoutCountDown_ == 0) {
                        DetectInfo* detectInfo = new DetectInfo(1401, AGPatternGroupModification, AGPatternNameAppguardModification, AGResponseTypeBlock, "Exit status timeout");
                        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
                        delete detectInfo;
                        detectInfo = nullptr;
                        STInstance(LogNCrash)->sendLog(kDetectLog, firstDetectInfo_, SECURE_STRING(block));
                        STInstance(CommonAPI)->stdSleepFor(2);
                        STInstance(ExitManager)->callExit(); // 종료
                        makeCrash();
                    }
                    exitWaitTimeoutCountDown_--;
                }
                STInstance(CommonAPI)->stdSleepFor(1);
            }
        }
    }];
}

__attribute__((visibility("hidden"))) void AGStatusMonitor:: startAppGuardIntegrityMonitor() {
    NSOperationQueue *integrityStatusMonitorQueue = [[NSOperationQueue alloc] init];
    [integrityStatusMonitorQueue addOperationWithBlock:^{
        STInstance(CommonAPI)->stdSleepFor(15);
        while(true) {
            @autoreleasepool {
                AGSelfProtectionUtil::checkAppGuardCoreFunctionRETPatch();
                AGSelfProtectionUtil::checkExportedFunctionRETPatch();
                STInstance(CommonAPI)->stdSleepFor(5);
            }
        }
        
    }];
}

__attribute__((visibility("hidden"))) void AGStatusMonitor::start() {
    AGLog(@"AGStatusMonitor start!");
    startExitStatusMonitor();
    startAppGuardIntegrityMonitor();
}

__attribute__((visibility("hidden"))) void AGStatusMonitor::setBlockDetectedStatus(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail) {
    if(isBlockDetected_ == false) {
        isBlockDetected_ = true;
        firstDetectInfo_ = new DetectInfo(index, group, name, type, detail);
        AGLog(@"Set block detected status!!!");
    } else {
        AGLog(@"Already block detected status is set");
    }
}
