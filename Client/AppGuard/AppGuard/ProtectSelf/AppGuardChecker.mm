//
//  AppGuardChecker.cpp
//  AppGuard
//
//  Created by NHNEnt on 23/10/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#include "AppGuardChecker.hpp"
#import "Diresu.h"
#include "UnityInterface.hpp"
#include "AGSelfProtectionUtil.hpp"

__attribute__((visibility("hidden"))) void AppGuardChecker::checkAppGuard()
{
    appguardCheckQueue = dispatch_queue_create(SECURE_STRING(appguardCheckQueue), NULL);
    dispatch_async(appguardCheckQueue, ^{
        pthread_mutex_lock(&checkLock);
        checkFlag();
        pthread_mutex_unlock(&checkLock);
    });
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkFlag()
{
    threadFlagA_ = 0xe1;
    auto startTime = std::chrono::high_resolution_clock::now();
    STInstance(CommonAPI)->stdSleepFor(checkSecond);
    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);
    
    bool result = true;
    
    if(flagA_ != 0x10)
    {
        result = false;
    }
    if(flagB_ != 0x11)
    {
        result = false;
    }
    if(flagC_ != 0x12)
    {
        result = false;
    }
    if(flagD_ != 0x13)
    {
        result = false;
    }
    if(flagE_ != 0x14)
    {
        result = false;
    }
 
    AGLog(@"flag check 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x; waitTime:%lldms", flagA_, flagB_, flagC_, flagD_, flagE_, duration.count());

    if(!result)
    {
        detail_ = [detail_ stringByAppendingFormat:@" %02x %02x %02x %02x %02x; %lld", flagA_, flagB_, flagC_, flagD_, flagE_, duration.count()];
        detectAGPatch(detail_);
        detail_ = @"";
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkAppGuardScan()
{
    char* queue = STInstance(CommonAPI)->cStrcat(SECURE_STRING(appguardCheckQueue), "S");
    appguardCheckScanQueue = dispatch_queue_create(queue, NULL);
    dispatch_async(appguardCheckScanQueue, ^{
        pthread_mutex_lock(&checkScanLock);
        checkScanFlag();
        pthread_mutex_unlock(&checkScanLock);
    });
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkScanFlag()
{
    threadFlagB_ = 0xe2;
    auto startTime = std::chrono::high_resolution_clock::now();
    STInstance(CommonAPI)->stdSleepFor(checkSecond);
    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);
    bool result = true;
    
    if(scanFlagA_ != 0x21)
    {
        result = false;
    }
    if(scanFlagB_ != 0x22)
    {
        result = false;
    }
    if(scanFlagC_ != 0x23)
    {
        result = false;
    }
    if(scanFlagD_ != 0x24)
    {
        result = false;
    }
    if(scanFlagE_ != 0x25)
    {
        result = false;
    }
    if(scanFlagF_ != 0x26)
    {
        result = false;
    }
    if(scanFlagG_ != 0x27)
    {
        result = false;
    }
    if(scanFlagH_ != 0x28)
    {
        result = false;
    }

    AGLog(@"scan flag check : 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x; waitTime:%lldms", scanFlagA_, scanFlagB_, scanFlagC_, scanFlagD_, scanFlagE_, scanFlagF_, scanFlagG_, scanFlagH_, duration.count());
    
    if(!result)
    {
        
        scanDetail_ = [scanDetail_ stringByAppendingFormat:@" %02x %02x %02x %02x %02x %02x %02x %02x; %lld", scanFlagA_, scanFlagB_, scanFlagC_, scanFlagD_, scanFlagE_, scanFlagF_, scanFlagG_, scanFlagH_, duration.count()];
        detectAGPatch(scanDetail_);
        scanDetail_ = @"";
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkAppGuardResponse()
{
    char* queue = STInstance(CommonAPI)->cStrcat(SECURE_STRING(appguardCheckQueue), "R");
    appguardCheckResponseQueue = dispatch_queue_create(queue, NULL);
    dispatch_async(appguardCheckResponseQueue, ^{
        pthread_mutex_lock(&checkResponseLock);
        checkResponseFlag();
        pthread_mutex_unlock(&checkResponseLock);
    });
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkResponseFlag()
{
    threadFlagC_ = 0xe3;
    auto startTime = std::chrono::high_resolution_clock::now();
    STInstance(CommonAPI)->stdSleepFor(checkSecond);
    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);
    bool result = true;
    
    if(responseFlagA_ != 0x3a)
    {
        result = false;
    }
    if(responseFlagB_ != 0x3b)
    {
        result = false;
    }
    if(responseFlagC_ != 0x3c)
    {
        result = false;
    }
    if(responseFlagD_ != 0x3d)
    {
        result = false;
    }
    AGLog(@"response flag check : 0x%02x 0x%02x 0x%02x 0x%02x; waitTime:%lldms", responseFlagA_, responseFlagB_, responseFlagC_, responseFlagD_, duration.count());

    if(!result)
    {
        responseDetail_ = [responseDetail_ stringByAppendingFormat:@" %02x %02x %02x %02x; %lld", responseFlagA_, responseFlagB_, responseFlagC_, responseFlagD_, duration.count()];
        detectAGPatch(responseDetail_);
        responseDetail_ = @"";
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::detectAGPatch(NSString* detail)
{

    bool isHashValid = !STInstance(IntegrityManager)->checkTextSectionHashByProtector();
    
    detail = [detail stringByAppendingFormat:@"; AT:%lld; ET:%lld; CS:%lld; hash:%d",
                                        Util::chronoTimePointToEpochMillisec(STInstance(EnvironmentManager)->getApplicationStartTime()),
                                        Util::chronoTimePointToEpochMillisec(STInstance(EnvironmentManager)->getEngineStartTime()),
                                        Util::chronoTimePointToEpochMillisec(STInstance(EnvironmentManager)->getCheckSwizzledCallTime()),
                                        isHashValid];
    
    DetectInfo* detectInfo = new DetectInfo(1404, AGPatternGroupBehavior, AGPatternNameBehavior, AGResponseTypeDetect, NS2CString(detail));
    STInstance(ResponseManager)->doResponseImmediately(detectInfo);
    
    if(!isHashValid) {
        AGResponseType type = STInstance(PatternManager)->getResponseTypeOfModification();
        if(flagC_ != 1) // 정책 다운로드 패치하였는지 확인
        {
            type = AGResponseTypeBlock;
        }
        AGLog(@"Hash is invalid!");
        detectInfo = new DetectInfo(1401, AGPatternGroupModification, AGPatternNameAppguardModification, type, NS2CString(detail));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, type == AGResponseTypeBlock ? SECURE_STRING(block):SECURE_STRING(detected));
        if(type == AGResponseTypeBlock) {
            AGLog(@"go to exit.");
            STInstance(CommonAPI)->stdSleepFor(2);
            STInstance(ExitManager)->callExit(); // 종료
            makeCrash();
        } else {
            AGLog(@"detect log is send.");
        }
    }
    
}

__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckFlagA()
{
    flagA_ = 0x10;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckFlagB()
{
    flagB_ = 0x11;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckFlagC()
{
    flagC_ = 0x12;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckFlagD()
{
    flagD_ = 0x13;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckFlagE()
{
    flagE_ = 0x14;
}

__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagA()
{
    scanFlagA_ = 0x21;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagB()
{
    scanFlagB_ = 0x22;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagC()
{
    scanFlagC_ = 0x23;
}

__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagD()
{
    scanFlagD_ = 0x24;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagE()
{
    scanFlagE_ = 0x25;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagF()
{
    scanFlagF_ = 0x26;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagG()
{
    scanFlagG_ = 0x27;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckScanFlagH()
{
    scanFlagH_ = 0x28;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckResponseFlagA()
{
    responseFlagA_ = 0x3a;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckResponseFlagB()
{
    responseFlagB_ = 0x3b;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckResponseFlagC()
{
    responseFlagC_ = 0x3c;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckResponseFlagD()
{
    responseFlagD_ = 0x3d;
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkAppGuardHook()
{
    char* result = STInstance(HookManager)->checkAppGuardAPIHook();
    if(result != nullptr)
    {
        DetectInfo* detectInfo = new DetectInfo(1604, AGPatternGroupHooking, AGPatternNameAppGuardHook, STInstance(PatternManager)->getResponseTypeOfHook(), result);
        STInstance(ResponseManager)->doResponseImmediately(detectInfo);
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkAppGuardFree()
{
    if(!STInstance(SecurityEventHandler)->getFreeAlert())
    {
        DetectInfo* detectInfo = new DetectInfo(1801, AGPatternGroupBehavior, AGPatternNameFreeUser, AGResponseTypeBlock, SECURE_STRING(Free_AppGuard_Abuser));
        STInstance(ResponseManager)->doResponseImmediately(detectInfo);
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkExit()
{
    char* queue = STInstance(CommonAPI)->cStrcat(SECURE_STRING(appguardCheckQueue), "E");
    appguardCheckExitQueue = dispatch_queue_create(queue, NULL);
    dispatch_async(appguardCheckExitQueue, ^{
        pthread_mutex_lock(&checkExitLock);
        checkExitFlag();
        pthread_mutex_unlock(&checkExitLock);
    });
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkExitFlag()
{
    STInstance(CommonAPI)->stdSleepFor(exitSecond);
    bool result = true;
    
    if(exitFlagA_ != 0xaa)
    {
        result = false;
    }
    if (exitFlagB_ != 0xab)
    {
        result = false;
    }
    if (exitFlagC_ != 0xac)
    {
        result = false;
    }
    if (exitFlagD_ != 0xad)
    {
        result = false;
    }
    
    if(result != true)
    {
        excuteExit();
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckExitFlagA()
{
    exitFlagA_ = 0xaa;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckExitFlagB()
{
    exitFlagB_ = 0xab;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckExitFlagC()
{
    exitFlagC_ = 0xac;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckExitFlagD()
{
    exitFlagD_ = 0xad;
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkThread()
{
    NSOperationQueue *threadCheckQueue = [[NSOperationQueue alloc] init];
    [threadCheckQueue addOperationWithBlock:^{
        checkThreadFlag();
     }];
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkThreadFlag()
{
    finalFlag_ = 1;
    bool result = true;
    auto startTime = std::chrono::high_resolution_clock::now();
    STInstance(CommonAPI)->stdSleepFor(checkSecond * 2);
    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);
    
    if(threadFlagA_ != 0xe1)
    {
        STInstance(DebugManager)->ptraceAsm();
        result = false;
    }
    if(threadFlagB_ != 0xe2)
    {
        STInstance(DebugManager)->ptracePtr();
        result = false;
    }
    if(threadFlagC_ != 0xe3)
    {
        STInstance(DebugManager)->ptraceSysCall();
        result = false;
    }
    
    AGLog(@"thread flag check : 0x%02x 0x%02x 0x%02x; waitTime:%lldms", threadFlagA_, threadFlagB_, threadFlagC_, duration.count());
    
    if(!result)
    {
        threadDetail_ = [threadDetail_ stringByAppendingFormat:@" %02x %02x %02x; %lld", threadFlagA_, threadFlagB_, threadFlagC_, duration.count()];
        detectAGPatch(threadDetail_);
        threadDetail_ = @"";
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::excuteExit()
{
    STInstance(SVCManager)->svcExit();
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkFinal()
{
    NSOperationQueue *finalCheckQueue = [[NSOperationQueue alloc] init];
    [finalCheckQueue addOperationWithBlock:^{
        checkFinalFlag();
     }];
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkFinalFlag()
{
    STInstance(CommonAPI)->stdSleepFor(checkSecond * 3);
    if(finalFlag_ != 1)
    {
        STInstance(SVCManager)->svcPtrace();
        DetectInfo* detectInfo = new DetectInfo(1404, AGPatternGroupModification, AGPatternNameAppguardModification, STInstance(PatternManager)->getResponseTypeOfModification(), "FF");
        STInstance(ResponseManager)->doResponseImmediately(detectInfo);
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkTweak()
{
    NSOperationQueue *tweakCheckQueue = [[NSOperationQueue alloc] init];
    [tweakCheckQueue addOperationWithBlock:^{
        findTweak();
     }];
}

__attribute__((visibility("hidden"))) void AppGuardChecker::findTweak()
{
    char* DynamicLibraryPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries),
                                                         STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(DynamicLibraryPath != NULL)
    {
        DetectInfo* detectInfo = new DetectInfo(9999, AGPatternGroupBehavior, AGPatternNameTweak, AGResponseTypeDetect, DynamicLibraryPath);
        STInstance(ResponseManager)->doResponseImmediately(detectInfo);
        isExistTweak = true;
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkBlock()
{
    NSOperationQueue *blockCheckQueue = [[NSOperationQueue alloc] init];
    [blockCheckQueue addOperationWithBlock:^{
        checkBlockFlag();
     }];
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkBlockFlag()
{
    STInstance(CommonAPI)->stdSleepFor(exitSecond);
    bool result = true;
    
    if(blockFlagA_ != 0x65)
    {
        result = false;
    }
    if(blockFlagB_ != 0x66)
    {
        result = false;
    }
    if(blockFlagC_ != 0x67)
    {
        result = false;
    }
    if(blockFlagD_ != 0x68)
    {
        result = false;
    }
    if(blockFlagE_ != 0x69)
    {
        result = false;
    }
    
    if(!result)
    {
        DetectInfo* detectInfo = new DetectInfo(1404, AGPatternGroupModification, AGPatternNameAppguardModification, AGResponseTypeBlock, NS2CString(blockDetail_));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(ExitManager)->callExit();
        makeCrash();
    }
    
}

__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckBlockFlagA()
{
    blockFlagA_ = 0x65;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckBlockFlagB()
{
    blockFlagB_ = 0x66;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckBlockFlagC()
{
    blockFlagC_ = 0x67;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckBlockFlagD()
{
    blockFlagD_ = 0x68;
}
__attribute__((visibility("hidden"))) void AppGuardChecker::setCheckBlockFlagE()
{
    blockFlagE_ = 0x69;
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkIntegrity()
{
    if(excuteIntegrityQueue != true)
    {
        NSOperationQueue *integrityCheckQueue = [[NSOperationQueue alloc] init];
        [integrityCheckQueue addOperationWithBlock:^{
            checkTextSection();
         }];
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::checkTextSection()
{
    excuteIntegrityQueue = true;
    while(true)
    {
        STInstance(CommonAPI)->cSleepA(integritySecond);
        if(STInstance(IntegrityManager)->checkTextSectionHash())
        {
            const char* hash = STInstance(IntegrityManager)->getTextSectionHash();
            if(STInstance(CommonAPI)->cStrlen(hash) != 0)
            {
                if(isExistTweak != true)
                {
                    DetectInfo* detectInfo = new DetectInfo(8888, AGPatternGroupBehavior, AGPatternNameCodeModification, AGResponseTypeDetect, hash);
                    STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(detected));
                }
                else
                {
                    AGResponseType type = STInstance(PatternManager)->getResponseTypeOfModification();
                    if(type == AGResponseTypeDetect)
                    {
                        DetectInfo* detectInfo = new DetectInfo(1401, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeDetect, hash);
                        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(detected));
                    }
                    else if(type == AGResponseTypeBlock)
                    {
                        DetectInfo* detectInfo = new DetectInfo(1401, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeBlock, hash);
                        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
#if defined __arm64__ || defined __arm64e__
                        __asm __volatile("mov x0, #0");
                        __asm __volatile("mov w16, #1");
                        __asm __volatile("svc #80");
#else
                        syscall(SYS_exit, 0);
#endif
                    }
                    
                }
                break;
            }
        }
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::monitoring(NSString* username)
{
    char* DynamicLibraryPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries),
                                                         STInstance(EnvironmentManager)->getPackageInfo().c_str(),
                                                         SECURE_STRING(plist));
    if(DynamicLibraryPath != NULL)
    {
        if (username == nullptr) {
            username = @"unknown";
        }
        
        STInstance(EnvironmentManager)->replaceUserId(username);
        
        DetectInfo* detectInfo = new DetectInfo(9999, AGPatternGroupBehavior, AGPatternNameTweak, AGResponseTypeDetect, DynamicLibraryPath);
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
    }
}

__attribute__((visibility("hidden"))) void AppGuardChecker::tweakMonitor(NSString* username)
{
    @try
    {
        NSOperationQueue *monitorQueue = [[NSOperationQueue alloc] init];
        [monitorQueue addOperationWithBlock:^{
            monitoring(username);
         }];
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}


    
int checkSwizzled(){
    STInstance(EnvironmentManager)->setCheckSwizzledCallTime();
#ifdef __LP64__  // 64bit
    AGSelfProtectionUtil::checkAppGuardBinaryPatch();
    
    // 앱가드 API가 실제로 본 라이브러리 내의 주소 영역에 존재하는지 체크
    // (앱가드 text섹션 시작부분) < (앱가드 API) < (앱가드 text섹션 끝부분) 검사
    AGLog(@"checkSwizzled start");

    IMP methodIMP = [AppGuardCore methodForSelector:@selector(doAppGuard::::)];
    void (*appguardCoreFuncPtr)(id, SEL) = (void (*)(id, SEL))methodIMP;
    AGLog(@"functionPointer %p", appguardCoreFuncPtr);
    
    if(!AGSelfProtectionUtil::checkIsDebugDylibFunction((void*)appguardCoreFuncPtr))
    {
        int unityIndex = AGSelfProtectionUtil::getUnityIndex();
        if( unityIndex != -1 )
        {
            AGLog(@"It is unity");
            AGSelfProtectionUtil::checkSwizzledForUnity((uint64_t)appguardCoreFuncPtr, unityIndex);
        }
        else
        {
            AGLog(@"It is not unity");
            AGSelfProtectionUtil::checkSwizzledForApp((uint64_t)appguardCoreFuncPtr);
        }
    }
    //유니티 인터페이스 RET패치 확인
    AGSelfProtectionUtil::checkUnityInterface();
#endif
    char * validSvcCallHookCheckResult = STInstance(HookManager)->checkValidSvcCallHook();
    if(STInstance(CommonAPI)->cStrcmp(validSvcCallHookCheckResult, "SH") != 0)
    {
        DetectInfo* detectInfo = new DetectInfo(1601, AGPatternGroupHooking, AGPatternNameCAPIHook, AGResponseTypeBlock, SECURE_STRING(checkValidSvcCallHook_detected_in_load));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
        return -1;
    }
    
    char * systemApiCheckResult = STInstance(HookManager)->checkSystemAPIHook();
    if(STInstance(CommonAPI)->cStrcmp(systemApiCheckResult, "H") != 0)
    {
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameCAPIHook, AGResponseTypeBlock, SECURE_STRING(checkSystemAPIHook_detected_in_load));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
        return -1;
    }
    
    AGLog(@"Flag Check Start");
    // FLAG CHECK
    STInstance(AppGuardChecker)->checkAppGuard();
    STInstance(AppGuardChecker)->checkAppGuardScan();
    STInstance(AppGuardChecker)->checkAppGuardResponse();
    STInstance(AppGuardChecker)->checkThread();
    STInstance(AppGuardChecker)->checkFinal();
    return 0;
}

int checkCodeHashByAppGuard() {
    AGSelfProtectionUtil::checkTextSectionHashByProtector();
    return 0;
}
