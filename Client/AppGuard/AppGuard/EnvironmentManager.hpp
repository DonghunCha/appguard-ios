//
//  EnvironmentManager.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 8..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef EnvironmentManager_hpp
#define EnvironmentManager_hpp

#include <stdio.h>
#include "Util.h"
#include "DeviceInfoCollector.h"
#include "Log.h"
#include "ASString.h"
#include "Singleton.hpp"
#include "EncodedDatum.h"
#include "LogNCrashManager.h"
#include <chrono>

typedef NS_ENUM(int, AGServerEnvType) {
    AGServerEnvTypeNone = -1,
    AGServerEnvTypeReal,
    AGServerEnvTypeAlpha,
    AGServerEnvTypeBeta
};

typedef NS_ENUM(char, AGProtectLevelType) {
    AGProtectLevelTypeObsolete = '0',
    AGProtectLevelTypeBusiness = '4',
    AGProtectLevelTypeEnterprise = '5',
    AGProtectLevelTypeGame = '6',
};

class __attribute__((visibility("hidden"))) EnvironmentManager
{

public:
        
    const size_t kProtectLevelSignatureLen = 129;
    const size_t kNewProtectLevelSignatureLen = 65;
    // GETTER
    std::string getEngineVersion();
    std::string getOsVersion();
    std::string getAppVersion();
    std::string getDeviceId();
    std::string getKernelVersion();
    std::string getCpuArchitecture();
    std::string getLanguage();
    std::string getCountry();
    std::string getCollectionTime();
    std::string getDeviceInfo();
    std::string getPackageInfo();
    std::string getUuid();
    std::string getApiKey();
    std::string getProtectLevel();
    std::chrono::system_clock::time_point getApplicationStartTime();
    std::chrono::system_clock::time_point getEngineStartTime();
    std::chrono::system_clock::time_point getCheckSwizzledCallTime();
    NSString* getLogServerUrl();
    NSString* getUserId();
    NSString* getSigner();
    AGServerEnvType getServerEnv();
    
    // SETTER
    void setAppName(NSString* );
    void setUserId(NSString*);
    void setApiKey(NSString*);
    void setAppVersion(NSString*);
    void setBasicInfo(NSString* key, NSString* user, NSString* name, NSString* version);
    void setSigner(NSString* signer);
    void setApplicationStartTime(std::chrono::system_clock::time_point time = std::chrono::system_clock::now());
    void setEngineStartTime(std::chrono::system_clock::time_point time = std::chrono::system_clock::now());
    void setCheckSwizzledCallTime(std::chrono::system_clock::time_point time = std::chrono::system_clock::now());
    
    // Replace
    void replaceUserId(NSString* user);
    
    //API Key
    struct ProtectorInjectedApiKeySignature {
        char signature[128+8];
        char encApiKey[512+8];
        int apiKeyStrlen;
    };
private:
    NSString* appName;
    NSString* userId;
    NSString* apiKey;
    NSString* appVersion;
    NSString* serverUrl;
    NSString * signer;
    DeviceInfoCollector deviceInfoCollector;
    AGServerEnvType serverEnv = AGServerEnvTypeNone;
    std::string getProtectorInjectedApiKey();
    std::chrono::system_clock::time_point applicationStartTime_;
    std::chrono::system_clock::time_point checkSwizzledCallTime_;
    std::chrono::system_clock::time_point engineStartTime_;
};

#endif /* EnvironmentManager_hpp */
