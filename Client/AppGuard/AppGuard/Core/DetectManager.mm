//
//  DetectManager.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 30..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "DetectManager.hpp"
#include "AppGuardChecker.hpp"
#include "AGStatusMonitor.hpp"
__attribute__((visibility("hidden"))) DetectInfo::DetectInfo(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail)
: patternIndex_(index),
patternGroup_(group),
patternName_(name),
responseType_(type),
detail_(detail),
sended_(0)
{
}

__attribute__((visibility("hidden"))) DetectInfo::DetectInfo(DetectInfo& info)
: patternIndex_(info.patternIndex_),
patternGroup_(info.patternGroup_),
patternName_(info.patternName_),
responseType_(info.responseType_),
detail_(info.detail_),
sended_(0)
{
}

__attribute__((visibility("hidden"))) NSString* DetectInfo::getPatternGroup() {
    if(patternGroup_ == AGPatternGroupBehavior) {
        return NS_SECURE_STRING(Behavior_pattern);
    }
    return [@(patternGroup_) stringValue];
}

__attribute__((visibility("hidden"))) NSString* DetectInfo::getPatternName() {
    if(patternName_ == AGPatternNameBehavior) {
        return NS_SECURE_STRING(Behavior_pattern);
    }
    return [@(patternName_) stringValue];
}

__attribute__((visibility("hidden"))) NSString* DetectInfo::getResponeType() {
    return [@(responseType_) stringValue];
}

__attribute__((visibility("hidden"))) DetectInfo::~DetectInfo()
{
    
}

__attribute__((visibility("hidden"))) DetectManager::DetectManager()
{
}

__attribute__((visibility("hidden"))) DetectManager::~DetectManager()
{
    releaseDetectInfos();
}

__attribute__((visibility("hidden"))) bool DetectManager::alreadyDetect(const AGPatternGroup group, const AGPatternName name, const AGResponseType type)
{
    bool result = false;
    unsigned long length = detectInfoVec_.size();
    
    for (int idx = 0; idx < length; idx++)
    {
        if (detectInfoVec_[idx]->patternGroup_ == group
        && detectInfoVec_[idx]->patternName_ == name
        && detectInfoVec_[idx]->responseType_ == type) // 정책 파일의 다운로드가 늦을 경우 (차단을 해야되는데 탐지가 먼저될 경우 대비)
        {
            AGLog(@"Already detected - [%d] [%d] [%d]", group, name, type);
            result = true;
            break;
        }
    }
    AGLog(@"Result - [%d]", result);
    return result;
}

__attribute__((visibility("hidden"))) void DetectManager::addDetectInfo(DetectInfo &info)
{
    pthread_mutex_lock(&detectInfoLock_);
    if(info.responseType_ != AGResponseTypeOff)
    {
        if (alreadyDetect(info.patternGroup_, info.patternName_, info.responseType_) == false)
        {
            DetectInfo* detectInfo = new DetectInfo(info);
            detectInfoVec_.push_back(detectInfo);
            AGLog(@"Push Detect info - [%d] [%d] [%d] [%d]", info.patternIndex_, info.patternGroup_, info.patternName_, info.responseType_);
            STInstance(ResponseManager)->doNotifyResponse();
        }
    }
    pthread_mutex_unlock(&detectInfoLock_);
}

__attribute__((visibility("hidden"))) void DetectManager::addDetectInfo(DetectInfo* info)
{
    pthread_mutex_lock(&detectInfoLock_);
    if(info->responseType_ != AGResponseTypeOff)
    {
        if (alreadyDetect(info->patternGroup_, info->patternName_, info->responseType_) == false)
        {
            detectInfoVec_.push_back(info);
            AGLog(@"Push Detect info - [%d] [%d] [%d] [%d]", info->patternIndex_, info->patternGroup_, info->patternName_, info->responseType_);
            STInstance(ResponseManager)->doNotifyResponse();
        }
    }
    pthread_mutex_unlock(&detectInfoLock_);
}

__attribute__((visibility("hidden"))) void DetectManager::addDetectInfo(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail)
{
    pthread_mutex_lock(&detectInfoLock_);
    if(type != AGResponseTypeOff)
    {
        if (alreadyDetect(group, name, type) == false)
        {
            DetectInfo* detectInfo = new DetectInfo(index, group, name, type, detail);
            detectInfoVec_.push_back(detectInfo);
            AGLog(@"Push Detect info - [%d] [%d] [%d] [%d]", index, group, name, type);
            STInstance(ResponseManager)->doNotifyResponse();
        }
    }
    pthread_mutex_unlock(&detectInfoLock_);
}

__attribute__((visibility("hidden"))) void DetectManager::resetSendFlags() {
    
    pthread_mutex_lock(&detectInfoLock_);
    unsigned long length = detectInfoVec_.size();
    for (int idx = 0; idx < length; idx++)
    {
        detectInfoVec_[idx]->sended_ = 0;
    }
    resetDetectInfoPeek();
    pthread_mutex_unlock(&detectInfoLock_);
    
}

__attribute__((visibility("hidden"))) void DetectManager::resetDetectInfoPeek() {
    detectInfoVecPeekIndex_ = 0;
}

__attribute__((visibility("hidden"))) DetectInfo* DetectManager::peekDetectInfo() {
    DetectInfo* info = nullptr;
    STInstance(AppGuardChecker)->setCheckResponseFlagC();
    pthread_mutex_lock(&detectInfoLock_);

    if(detectInfoVec_.size() > detectInfoVecPeekIndex_) {
        info = detectInfoVec_[detectInfoVecPeekIndex_++];
        AGLog(@"peekDetectInfo detectInfoVec_.size(): %lu, detectInfoVecPeekIndex_:%d", detectInfoVec_.size(), detectInfoVecPeekIndex_);
    }

    pthread_mutex_unlock(&detectInfoLock_);
    return info;
}

// @author  : daejoon kim
// @brief   : 기존 탐지 정보를 삭제
__attribute__((visibility("hidden"))) void DetectManager::releaseDetectInfos()
{
    pthread_mutex_lock(&detectInfoLock_);
    unsigned long length = detectInfoVec_.size();
    if (length != 0)
    {
        auto infoIter = detectInfoVec_.begin();
        while (infoIter != detectInfoVec_.end())
        {
            if (*infoIter != NULL)
            {
                delete (*infoIter);
                *infoIter = NULL;
            }
            infoIter++;
        }
        resetDetectInfoPeek();
        detectInfoVec_.clear();
    }
    pthread_mutex_unlock(&detectInfoLock_);
    AGLog(@"Release detect infos");
}
