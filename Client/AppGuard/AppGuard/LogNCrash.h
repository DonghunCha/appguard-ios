//
//  LogNCrash.h
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 18..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef LogNCrash_h
#define LogNCrash_h

#include <stdio.h>
#include <dlfcn.h>
#include <pthread.h>
#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "Singleton.hpp"
#include "EncodedDatum.h"
#include "TweakManager.hpp"
#include "DetectManager.hpp"
#include "PatternManager.hpp"
#include "LogNCrashManager.h"
#include "PacketEncryptor.hpp"
#include "DeviceInfoCollector.h"
#include "EnvironmentManager.hpp"

enum
{
    kStartLog = 0,
    kCompleteLog,
    kFailLog,
    kDetectLog,
    kCollectExtraInfo,
    kErrorLog,
    kRealTime,
};
enum
{
    kRuleVersion=0,
    kRuleGroup,
    kRuleId,
    kRuleName,
    kGameId,
    kAppVersion,
    kMemberNo,
    kDetail,
    kPhoneInfo,
    kPackageInfo,
    kAction,
    kDeviceId,
    kMac,
    kOsVersion,
    kKernelVersion,
    kCpuArchitecture,
    kLanguage,
    kCollectionTime,
    kCountry,
    kAdvertisementId,
    kUuid,
    kAppKey,
    kErrorType,
    kErrorCode,
    kErrorMsg,
    kSDKVersion,
    kPolicyFileUuid,
    // kEnd
};

class __attribute__((visibility("hidden"))) LogNCrash {
public:

    void setUp();
    bool checkSetUp();
    BOOL sendLog(int,void*,const char*);
//    BOOL Initialize();
//    void Finalize();
//    BOOL IsAlreadySendPacket(char* path);
//    BOOL isSendedLog(const char* ruleGroup, const char* packageName);
    
    static const char kAppGuardLogType[][32];
    static const char kAppGuardLogKeyName[][32];
    //static char ruleGroupName_[kRuleGroupIndexEnd][32];
    pthread_mutex_t sendLock = PTHREAD_MUTEX_INITIALIZER;

    
private:
    DetectManager detectManager;
    PacketEncryptor packetEncryptor;
    //std::string appguardAppkey_;

    void set();
    bool sendToastLog(int logType);
    void addFields();
    void addDetectFields(DetectInfo* detectInfo,const char* pAction);
    bool isSended(int logType, void* info);
    
    void info(NSString* msg);
    void debug(NSString* msg);
    void warn(NSString* msg);
    void fatal(NSString* msg);
    void error(NSString* msg);
    void crash(NSString* msg);
    
    bool setUp_ = false;
};

#endif /* LogNCrash_h */
