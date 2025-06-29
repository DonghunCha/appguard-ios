//
//  LogNCrash.c
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 18..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "LogNCrash.h"

__attribute__((visibility("hidden"))) const char LogNCrash::kAppGuardLogType[][32] =
{
    { "AGS" },	  //{ "AppGuard_START" },
    { "AGC" },	  //{ "AppGuard_COMPLETE" },
    { "AGF" },	  //{ "AppGuard_FAIL" },
    { "AGD" },	  //{ "AppGuard_DTTD" },
    { "AGC" },	  // AppGuard Collect Extra Info
    { "AGE" },	  // AppGuard Error Message
    { "AGD" },    // LogType::realtime
};

__attribute__((visibility("hidden"))) const char LogNCrash::kAppGuardLogKeyName[][32] =
{
    { "RV" },		//{ "ruleVersion" },
    { "RG" },		//{ "ruleGroup" },
    { "RI" },		//{ "ruleId" },
    { "RN" },		//{ "ruleName" },
    { "GI" },		//{ "gameId" }, // 제외된 항목
    { "AV" },		//{ "appVersion" },
    { "MN" },		//{ "memberNo" }, // 제외된 항목
    { "D" },		//{ "detail" },
    { "DIF" },		//{ "deviceInfo" },
    { "PI" },		//{ "packageInfo" },
    { "A" },		//{ "action" },
    { "DI" },		//{ "deviceId" },
    { "M" },		//{ "mac" },
    { "OV" },		//{ "osVersion" },
    { "KV" },		//{ "kernelVersion" },
    { "CA" },		//{ "cpuArchitecture" },
    { "L" },		//{ "language" },
    { "CT" },		//{ "collectionTime" },
    { "C" },		//{ "country" },
    { "ADI" },		//{ "advertisementId" },
    { "UD" },		//{ "uuid" },
    { "K" },		//{ "appkey" },
    { "ET" },		//{ "error type" },
    { "EC" },		//{ "error code" },
    { "EM" },		//{ "error msg" },
    { "SV" },       //{ "sdk version },
    { "PFU" },      //{ "policy file uuid" },
};

__attribute__((visibility("hidden"))) void LogNCrash::setUp()
{
    STInstance(AppGuardChecker)->setCheckFlagD();
    set();
    setUp_ = true;
    
    // start 로그 전송 확인해서 오늘 보냈으면 -> skip
    @try
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if (defaults != nil)
        {
            
            NSString* lastSendDate = [defaults stringForKey:@"AG_Date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            if (dateFormat != nil)
            {
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString* today = [dateFormat stringFromDate:[NSDate date]];
                if (today != nil)
                {
                    if (![today isEqualToString:lastSendDate])
                    {
                        [defaults setObject:today forKey:@"AG_Date"];
                        [defaults synchronize];
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
    }
    @catch(NSException *exception)
    {
    }
    
    sendLog(kStartLog,NULL,NULL);
}

__attribute__((visibility("hidden"))) bool LogNCrash::checkSetUp()
{
    return setUp_;
}

__attribute__((visibility("hidden"))) void LogNCrash::set()
{
    char* data = NULL;
    
    packetEncryptor.encryptAndEncode((unsigned char*)NS2CString(STInstance(EnvironmentManager)->getUserId()), (int)strlen(NS2CString(STInstance(EnvironmentManager)->getUserId())), &data);
    
    [LogNCrashManager init:STInstance(EnvironmentManager)->getLogServerUrl() ofAppKey:C2NSString(STInstance(EnvironmentManager)->getApiKey().c_str()) withVersion:C2NSString(STInstance(EnvironmentManager)->getEngineVersion().c_str()) forUserId:C2NSString(data)];
    
    if (data != NULL)
    {
        free(data);
        data = NULL;
    }
}


__attribute__((visibility("hidden"))) BOOL LogNCrash::sendLog(int logType, void* eventInfo, const char* action)
{
    char* data = NULL;
    if (isSended(logType, eventInfo) == true)
    {
        return TRUE;
    }
    
    pthread_mutex_lock(&sendLock);
    
    //reset();
    [LogNCrashManager removeAllCustomFields];
    
    addFields();
    
    switch (logType)
    {
        case kDetectLog:
            if(STInstance(CommonAPI)->cStrcmp(action, SECURE_STRING(block)) == 0)
            {
                STInstance(TweakManager)->removeTweakA();
            }
            addDetectFields(reinterpret_cast<DetectInfo*>(eventInfo), action);
            break;
        case kStartLog:
            if (STInstance(EnvironmentManager)->getEngineVersion().size() != 0)
            {
                packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getEngineVersion().c_str(), (unsigned int) STInstance(EnvironmentManager)->getEngineVersion().size(), &data);
                [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kSDKVersion])];
                if (data != NULL)
                {
                    free(data);
                    data = NULL;
                }
                
                std::string protectLevel = STInstance(EnvironmentManager)->getProtectLevel();
                packetEncryptor.encryptAndEncode((unsigned char*)protectLevel.c_str(), (unsigned int)protectLevel.size(), &data);
                [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kRuleGroup])];
                if(data != NULL)
                {
                    free(data);
                    data = NULL;
                }
                
                // Country code
                std::string country = STInstance(EnvironmentManager)->getCountry();
                packetEncryptor.encryptAndEncode((unsigned char*)country.c_str(), (unsigned int)country.size(), &data);
                [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kCountry])];
                if(data != NULL)
                {
                    free(data);
                    data = NULL;
                }
            }
            break;
        case kRealTime:
            addDetectFields(reinterpret_cast<DetectInfo*>(eventInfo), action);
            break;
        default:
            return FALSE;
    }
    
    // send info type log
    [LogNCrashManager sendLog:C2NSString(kAppGuardLogType[logType])];
    
    pthread_mutex_unlock(&sendLock);
    return TRUE;
}

__attribute__((visibility("hidden"))) void LogNCrash::addFields()
{
    char* data = NULL;
    
    if (STInstance(EnvironmentManager)->getAppVersion().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getAppVersion().c_str(), (int)STInstance(EnvironmentManager)->getAppVersion().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kAppVersion])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getDeviceInfo().size() != 0)
    {
        // { "DIF" },		//{ "deviceInfo" },
        // "Google Galaxy Nexus - 4.2.2 - API 17 - blahblah
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getDeviceInfo().c_str(), (int)STInstance(EnvironmentManager)->getDeviceInfo().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kPhoneInfo])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getPackageInfo().size() != 0)
    {
        //com.nhnent.appguard
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getPackageInfo().c_str(), (int)STInstance(EnvironmentManager)->getPackageInfo().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kPackageInfo])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getDeviceId().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getDeviceId().c_str(), (int)STInstance(EnvironmentManager)->getDeviceId().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kDeviceId])];
        
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getOsVersion().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getOsVersion().c_str(), (int)STInstance(EnvironmentManager)->getOsVersion().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kOsVersion])];
        
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getKernelVersion().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getKernelVersion().c_str(),(int)STInstance(EnvironmentManager)->getKernelVersion().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kKernelVersion])];
        
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getCpuArchitecture().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getCpuArchitecture().c_str(), (int)STInstance(EnvironmentManager)->getCpuArchitecture().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kCpuArchitecture])];
        
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getLanguage().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getLanguage().c_str(), (int)STInstance(EnvironmentManager)->getLanguage().size(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kLanguage])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(EnvironmentManager)->getUuid().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*) STInstance(EnvironmentManager)->getUuid().c_str(), (int)STInstance(EnvironmentManager)->getUuid().length(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kUuid])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    if (STInstance(PolicyManager)->getPolicyFileUuid().size() != 0)
    {
        packetEncryptor.encryptAndEncode((unsigned char*) STInstance(PolicyManager)->getPolicyFileUuid().c_str(), (int)STInstance(PolicyManager)->getPolicyFileUuid().length(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kPolicyFileUuid])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
    
    // push appkey
    [LogNCrashManager setCustomField:C2NSString(STInstance(EnvironmentManager)->getApiKey().c_str()) forKey:C2NSString(kAppGuardLogKeyName[kAppKey])];
}


__attribute__((visibility("hidden"))) void LogNCrash::addDetectFields(DetectInfo* detectInfo, const char* pAction)
{
    char* data = NULL;
    
    if (detectInfo != NULL)
    {
        // kAppGuardLogKeyName[kRuleVersion]);
        if (STInstance(PatternManager)->getVersion().size() != 0)
        {
            packetEncryptor.encryptAndEncode((unsigned char*) STInstance(PatternManager)->getVersion().c_str(), (int)STInstance(PatternManager)->getVersion().length(), &data);
            [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kRuleVersion])];
            if (data != NULL)
            {
                free(data);
                data = NULL;
            }
        }
        
        std::string patternGroupCString = NS2CString(detectInfo->getPatternGroup());
        packetEncryptor.encryptAndEncode((unsigned char*) patternGroupCString.c_str(), (int)patternGroupCString.length(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kRuleGroup])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
        
        std::string patternNameCString = NS2CString(detectInfo->getPatternName());
        packetEncryptor.encryptAndEncode((unsigned char*)patternNameCString.c_str(), (int)patternNameCString.length(), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kRuleName])];
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
        
        if (STInstance(EnvironmentManager)->getCollectionTime().size() != 0)
        {
            packetEncryptor.encryptAndEncode((unsigned char*)STInstance(EnvironmentManager)->getCollectionTime().c_str(), (int)STInstance(EnvironmentManager)->getCollectionTime().size(), &data);
            [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kCollectionTime])];
            if (data != NULL)
            {
                free(data);
                data = NULL;
            }
        }
        
        if (detectInfo->detail_.size() != 0)
        {
            packetEncryptor.encryptAndEncode((unsigned char*) detectInfo->detail_.c_str(), (int)detectInfo->detail_.length(), &data);
            [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kDetail])];
            
            if (data != NULL)
            {
                free(data);
                data = NULL;
            }
        }
    }
    
    if (pAction != NULL)
    {
        packetEncryptor.encryptAndEncode((unsigned char*) pAction, (int)STInstance(CommonAPI)->cStrlen(pAction), &data);
        [LogNCrashManager setCustomField:C2NSString(data) forKey:C2NSString(kAppGuardLogKeyName[kAction])];
        
        if (data != NULL)
        {
            free(data);
            data = NULL;
        }
    }
}

__attribute__((visibility("hidden"))) bool LogNCrash::isSended(int logType, void* info)
{
    bool result = false;
    
    if (logType == kDetectLog)
    {
        DetectInfo* detectInfo = reinterpret_cast<DetectInfo*>(info);
        if (detectInfo->patternName_ == AGPatternNameDefaultCallback)
        {
            AGLog(@"Except default callback");
            result = true;
        }
    }
    AGLog(@"Sended result - [%d]", result);
    return result;
}
