//
//  ResponseManager.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "ResponseManager.hpp"
#include "RealtimeManager.hpp"
const int ResponseManager::kResponseSecond_;

__attribute__((visibility("hidden"))) void ResponseManager::doNotifyResponse() {
    AGLog(@"do Notify Response");
    responseCV_.notify_one();
}

__attribute__((visibility("hidden"))) void ResponseManager::startResponseThread()
{
    @try
    {
        if(responing != 0xdc) {
            STInstance(AppGuardChecker)->setCheckResponseFlagA();
            responing = 0xdc;
            NSOperationQueue *responseQueue = [[NSOperationQueue alloc] init];
            [responseQueue addOperationWithBlock:^{
                STInstance(AppGuardChecker)->setCheckResponseFlagB();
                std::unique_lock<std::mutex> lock(responseMutex_);
                while(true) {
                    @autoreleasepool {
                        responseCV_.wait_for(lock, std::chrono::seconds(ResponseManager::kResponseSecond_));
                        doResponseAll();
                    }
                }
            }];
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

__attribute__((visibility("hidden"))) void ResponseManager::doResponseDetect(DetectInfo* detectInfo, bool addDetectInfoFlag) {
    AGLog(@"Send detect log - index : [%d] detail : [%s]", detectInfo->patternIndex_, detectInfo->detail_.c_str());
    STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(detected));
    detectInfo->sended_ = 1;
    if(addDetectInfoFlag) {
        STInstance(DetectManager)->addDetectInfo(detectInfo);
    }
    doDetect(detectInfo);
}

__attribute__((visibility("hidden"))) void ResponseManager::doResponseBlock(DetectInfo* detectInfo, bool addDetectInfoFlag) {
    if(excuteBlock_ != true)
    {
        AGLog(@"Send block log - index : [%d] detail : [%s]", detectInfo->patternIndex_, detectInfo->detail_.c_str());
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        detectInfo->sended_ = 1;
        if(addDetectInfoFlag) {
            STInstance(DetectManager)->addDetectInfo(detectInfo);
        }
        doBlock(detectInfo);
        STInstance(AppGuardChecker)->checkBlock();
        if(STInstance(SecurityEventHandler)->getForceExit() != false)
        {
            STInstance(HookManager)->stopNetworkA();
        }
        excuteBlock_ = true;
    }
}

__attribute__((visibility("hidden"))) void ResponseManager::doResponse(DetectInfo *detectInfo, bool addDetectInfoFlag) {
    if (detectInfo->sended_ == 0) {
        if (detectInfo->responseType_ == AGResponseTypeDetect) {
            doResponseDetect(detectInfo, addDetectInfoFlag);
        }
        else if (detectInfo->responseType_ == AGResponseTypeBlock) {
            doResponseBlock(detectInfo, addDetectInfoFlag);
        }
        else if (detectInfo->responseType_ == AGResponseTypeOff) {
            detectInfo->sended_ = 1;
        } else if (detectInfo->responseType_ == AGResponseTypeConditional) {
            if (isBlockByConditionalPolicy(detectInfo)) {
                doResponseBlock(detectInfo, addDetectInfoFlag);
            } else {
                doResponseDetect(detectInfo, addDetectInfoFlag);
            }
        }
    }
}

__attribute__((visibility("hidden"))) void ResponseManager::doResponseAll() {

    STInstance(AppGuardChecker)->setCheckResponseFlagD();
        
    DetectInfo* info = STInstance(DetectManager)->peekDetectInfo();
    while(info) {
        doResponse(info, false);
        info = STInstance(DetectManager)->peekDetectInfo();
    }
    STInstance(DetectManager)->resetDetectInfoPeek();
}

__attribute__((visibility("hidden"))) void ResponseManager::doResponseImmediately(DetectInfo *detectInfo) {
    doResponse(detectInfo, true);
}

__attribute__((visibility("hidden"))) void ResponseManager::doDetect(DetectInfo *detectInfo)
{
    if(detectInfo->patternGroup_ == AGPatternGroupBehavior ||
       detectInfo->patternName_ == AGPatternNameJailbreakGroup //사용자에게 노출시키지 않음 100039
       )
    {
        AGLog(@"Exception-handled detection. patternGroup %d, patternName %d", detectInfo->patternGroup_, detectInfo->patternName_);
        return;
    }
    
    STInstance(SecurityEventHandler)->throwSecurityEvent(detectInfo);
    
}

__attribute__((visibility("hidden"))) void ResponseManager::doBlock(DetectInfo *detectInfo)
{
    if(detectInfo->patternGroup_ != AGPatternGroupBehavior)
    {
        STInstance(AppGuardChecker)->setCheckBlockFlagA();
        BlockMsg(detectInfo);
    }
}


__attribute__((visibility("hidden"))) void ResponseManager::BlockMsg(DetectInfo *detectInfo)
{
    STInstance(AppGuardChecker)->setCheckBlockFlagB();
    STInstance(SecurityEventHandler)->throwSecurityEvent(detectInfo);
}

__attribute__((visibility("hidden"))) bool ResponseManager::isBlockByConditionalPolicy(DetectInfo* detectInfo) {
    return STInstance(RealtimeManager)->isBlockConditionalPolicy(detectInfo->patternGroup_);
}
