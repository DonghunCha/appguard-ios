//
//  DetectManager.hpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 30..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef DetectManager_hpp
#define DetectManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <string>
#include <vector>
#include <pthread.h>
#include "Log.h"
#include "Pattern.h"

class __attribute__((visibility("hidden"))) DetectInfo
{
public:
    int patternIndex_;
    AGPatternGroup patternGroup_;
    AGPatternName patternName_;
    int sended_;
    AGResponseType responseType_;
    std::string detail_;
    
    DetectInfo(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail);
    DetectInfo(DetectInfo& info);
    NSString* getPatternGroup();
    NSString* getPatternName();
    NSString* getResponeType();
    ~DetectInfo();
};

class __attribute__((visibility("hidden"))) DetectManager
{
public:
    DetectManager();
    ~DetectManager();
    
    void addDetectInfo(DetectInfo& info);
    void addDetectInfo(DetectInfo* info);
    void addDetectInfo(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail);
    void resetSendFlags();
    DetectInfo* peekDetectInfo();
    void releaseDetectInfos();
    void resetDetectInfoPeek();
private:
    std::vector<DetectInfo*> detectInfoVec_;
    pthread_mutex_t detectInfoLock_ = PTHREAD_MUTEX_INITIALIZER;
    int detectInfoVecPeekIndex_ = 0;
    bool alreadyDetect(const AGPatternGroup group, const AGPatternName name, const AGResponseType type);
};

#endif /* DetectManager_hpp */
