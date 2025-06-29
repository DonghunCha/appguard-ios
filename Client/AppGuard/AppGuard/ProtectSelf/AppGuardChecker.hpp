//
//  AppGuardChecker.hpp
//  AppGuard
//
//  Created by NHNEnt on 23/10/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef AppGuardChecker_hpp
#define AppGuardChecker_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <pthread.h>
#include <dispatch/dispatch.h>
#include "Log.h"
#include "Pattern.h"
#include "LogNCrash.h"
#include "SVCManager.hpp"
#include "HookManager.hpp"
#include "DebugManager.hpp"
#include "PolicyManager.hpp"
#include "DetectManager.hpp"
#include "PatternManager.hpp"
#include "ResponseManager.hpp"

class __attribute__((visibility("hidden"))) AppGuardChecker
{
public:
    void checkAppGuard();
    void checkAppGuardScan();
    void checkAppGuardResponse();
    void checkThread();
    void checkFinal();
    void checkAppGuardHook();
    void checkAppGuardFree();
    void checkExit();
    void checkTweak();
    void checkBlock();
    void checkIntegrity();

    void setCheckFlagA();
    void setCheckFlagB();
    void setCheckFlagC();
    void setCheckFlagD();
    void setCheckFlagE();
    
    void setCheckScanFlagA();
    void setCheckScanFlagB();
    void setCheckScanFlagC();
    void setCheckScanFlagD();
    void setCheckScanFlagE();
    void setCheckScanFlagF();
    void setCheckScanFlagG();
    void setCheckScanFlagH();
    
    void setCheckResponseFlagA();
    void setCheckResponseFlagB();
    void setCheckResponseFlagC();
    void setCheckResponseFlagD();
    
    void setCheckExitFlagA();
    void setCheckExitFlagB();
    void setCheckExitFlagC();
    void setCheckExitFlagD();
    
    void setCheckBlockFlagA();
    void setCheckBlockFlagB();
    void setCheckBlockFlagC();
    void setCheckBlockFlagD();
    void setCheckBlockFlagE();
    
    void tweakMonitor(NSString* userId);
    
private:
    dispatch_queue_t appguardCheckQueue;
    dispatch_queue_t appguardCheckScanQueue;
    dispatch_queue_t appguardCheckResponseQueue;
    dispatch_queue_t appguardCheckExitQueue;
    pthread_mutex_t checkLock = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_t checkScanLock = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_t checkResponseLock = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_t checkExitLock = PTHREAD_MUTEX_INITIALIZER;
    
    void checkFlag();
    void checkScanFlag();
    void checkResponseFlag();
    void checkThreadFlag();
    void checkFinalFlag();
    void checkExitFlag();
    void excuteExit();
    void detectAGPatch(NSString* detail);
    void findTweak();
    void checkBlockFlag();
    void checkTextSection();
    void monitoring(NSString* userId);
  
    
    int flagA_ = 0xa;
    int flagB_ = 0xb;
    int flagC_ = 0xc;
    int flagD_ = 0xd;
    int flagE_ = 0xe;
    
    int scanFlagA_ = 1;
    int scanFlagB_ = 2;
    int scanFlagC_ = 3;
    int scanFlagD_ = 4;
    int scanFlagE_ = 5;
    int scanFlagF_ = 6;
    int scanFlagG_ = 7;
    int scanFlagH_ = 8;
    
    int responseFlagA_ = 0x20;
    int responseFlagB_ = 0x21;
    int responseFlagC_ = 0x22;
    int responseFlagD_ = 0x23;
    
    int exitFlagA_ = 0xa1;
    int exitFlagB_ = 0xa2;
    int exitFlagC_ = 0xa3;
    int exitFlagD_ = 0xa4;
    
    int threadFlagA_ = 0xfa;
    int threadFlagB_ = 0xfb;
    int threadFlagC_ = 0xfc;
    
    int finalFlag_ = 0;
    
    int blockFlagA_ = 0x50;
    int blockFlagB_ = 0x51;
    int blockFlagC_ = 0x52;
    int blockFlagD_ = 0x53;
    int blockFlagE_ = 0x54;
    
    NSString* detail_ = @"D";
    NSString* scanDetail_ = @"S";
    NSString* responseDetail_ = @"R";
    NSString* threadDetail_ = @"T";
    NSString* blockDetail_ = @"B";
    
	int checkSecond = 60;
    int exitSecond = 15;
    int integritySecond = 30;
    
    bool isExistTweak = false;
    bool excuteIntegrityQueue = false;
};

__inline__ __attribute__((always_inline)) bool checkRETPatch(void* functionAddr) {
#ifdef __LP64__  // 64bit
    const uint8_t RETInstruction[4] = {0xC0, 0x03, 0x5F, 0xD6};
    if(memcmp(functionAddr, RETInstruction, 4) == 0 ) {
        AGLog(@"RET Patch. (%p)", (void*)functionAddr);
        return true;
    }
    
    if(memcmp((uint8_t*)functionAddr + 4, RETInstruction, 4) == 0 ) {
        AGLog(@"RET Patch offset + 4. (%p)", (void*)functionAddr);
        return true;
    }
#endif
    return false;
}
#endif /* AppGuardChecker_hpp */
