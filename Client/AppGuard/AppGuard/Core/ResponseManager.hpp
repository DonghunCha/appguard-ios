//
//  ResponseManager.hpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef ResponseManager_hpp
#define ResponseManager_hpp

#include <stdio.h>
#include <mutex>
#include <condition_variable>

#include "LogNCrash.h"
#include "Singleton.hpp"
#include "DetectManager.hpp"
#include "AppGuardChecker.hpp"
#include "SecurityEventHandler.h"

class __attribute__((visibility("hidden"))) ResponseManager
{
public:
    void doResponseAll();
    void doResponseImmediately(DetectInfo* detectInfo);
    void startResponseThread();
    void BlockMsg(DetectInfo *detectInfo);
    static const int kResponseSecond_ = 15;
    void doNotifyResponse();
private:
    void doResponse(DetectInfo *detectInfo, bool addDetectInfoFlag);
    void doResponseDetect(DetectInfo* detectInfo, bool addDetectInfoFlag);
    void doResponseBlock(DetectInfo* detectInfo, bool addDetectInfoFlag);
    void doDetect(DetectInfo* detectInfo);
    void doBlock(DetectInfo* detectInfo);
    bool isBlockByConditionalPolicy(DetectInfo* detectInfo);
    
    std::mutex responseMutex_;
    std::condition_variable responseCV_;
    
    bool excuteBlock_ = false;
    int responing = 0xdd;
};

#endif /* ResponseManager_hpp */

