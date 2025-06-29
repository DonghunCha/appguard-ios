//
//  EnvironmentManager.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 8..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "EnvironmentManager.hpp"
#include "RealtimeManager.hpp"
#import "Diresu.h"

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getEngineVersion()
{
    return NHNAppGuardVersion.UTF8String;
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getOsVersion()
{
    if (deviceInfoCollector.getOs().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getOs();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getAppVersion()
{
    if(!appVersion.length)
        return "N/A";
    else
        return NS2CString(appVersion);
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getDeviceId()
{
    if (deviceInfoCollector.getDeviceId().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getDeviceId();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getKernelVersion()
{
    if (deviceInfoCollector.getKernelVersion().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getKernelVersion();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getCpuArchitecture()
{
    if (deviceInfoCollector.getCpuArch().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getCpuArch();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getLanguage()
{
    if (deviceInfoCollector.getLanguage().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getLanguage();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getCountry()
{
    if (deviceInfoCollector.getCountry().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getCountry();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getCollectionTime()
{
    if (deviceInfoCollector.getCollectionTime().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getCollectionTime();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getDeviceInfo()
{
    if (deviceInfoCollector.getDeviceInfo().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getDeviceInfo();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getPackageInfo()
{
    if (deviceInfoCollector.getPackageInfo().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getPackageInfo();
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getUuid()
{
    if (deviceInfoCollector.getUuid().size() == 0)
        return "N/A";
    else
        return deviceInfoCollector.getUuid();
}

__attribute__((visibility("hidden"))) NSString* EnvironmentManager::getLogServerUrl()
{
    AGServerEnvType env = getServerEnv();
    
    if( env == AGServerEnvTypeAlpha) {
        serverUrl = NS_SECURE_STRING(alpha_server);
    } else if( env == AGServerEnvTypeBeta) {
        serverUrl = NS_SECURE_STRING(beta_server);
    } else {
        serverUrl = NS_SECURE_STRING(real_server);
    }
    
    AGLog(@"Server URL : %@", serverUrl);
    return serverUrl;
}

__attribute__((visibility("hidden"))) NSString* EnvironmentManager::getUserId()
{
    if(userId.length == 0) {
        return @"unknown"; //길이가 0인 userId인 경우 unknown
    }
  
    return userId;
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getApiKey()
{
    if(!apiKey.length)
        return getProtectorInjectedApiKey();
    else
        return NS2CString(apiKey);
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getProtectLevel() {
  
    std::string protectLevel(1, AGProtectLevelTypeBusiness) ;
    const char protectLevelSignature[] = { "fbef3cfdae30535c9d61764ca3b2b90d4ed1969097bafa36192dc21df3ce36865ff01fe288fd2bc67a2fe9ed7e27786e2cab8e2c0f31f262cb71fb93346e34064" };
    size_t currnetSignatureLen = CommonAPI::cStrlen(protectLevelSignature);
    
    if(currnetSignatureLen == kNewProtectLevelSignatureLen) { // Protector적용 검증.
        const char* replacedSignature = SECURE_STRING(updated_protectlevel_signature_prefix); //"c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee"
        
        for(int i = 0; i < currnetSignatureLen - 1; i++) {
            if(protectLevelSignature[i] != replacedSignature[i]) {
                AGLog(@"Protect Level is invalid.(%s)(sig len: %lu) ", protectLevelSignature, currnetSignatureLen);
                //crash
                STInstance(ExitManager)->callExit();
                makeCrash();
            }
        }
            
        const char protectLevelChar = protectLevelSignature[currnetSignatureLen-1];
        
        if(( AGProtectLevelTypeBusiness <= protectLevelChar && protectLevelChar <=  AGProtectLevelTypeGame) ||
           protectLevelChar ==  AGProtectLevelTypeObsolete) {
            protectLevel = protectLevelChar;
            AGLog(@"Protect Level is valid(%c)(sig len: %lu). Set protect level(%s)", protectLevelChar, currnetSignatureLen, protectLevel.c_str());
        }
        else {
            AGLog(@"Protect Level is invalid.(%c)(sig len: %lu) ", protectLevelChar, currnetSignatureLen);
            //crash
            STInstance(ExitManager)->callExit();
            makeCrash();
        }
        
    } else { // Protector적용 하지 않았을 때 검증.
        
        if(currnetSignatureLen != kProtectLevelSignatureLen) { //시그니처 길이가 달라진 경우.
            AGLog(@"Protect Level signature length is invalid(len: %lu).", currnetSignatureLen);
            //crash
            STInstance(ExitManager)->callExit();
            makeCrash();
        }
        
        const char protectLevelChar = protectLevelSignature[strlen(protectLevelSignature)-1];
        
        // 시그니처 길이는 같으나 default 레벨인 AGProtectLevelTypeBusiness가 아닌 경우 위변조 탐지 crash
        if( AGProtectLevelTypeBusiness != protectLevelChar ) {
            AGLog(@"Protect Level is invalid.(%c)(sig len: %lu) Set default protect level(%s)", protectLevelChar, currnetSignatureLen, protectLevel.c_str());
            //crash
            STInstance(ExitManager)->callExit();
            makeCrash();
        }
        
    }
    
    AGLog(@"Set protect level(%s)", protectLevel.c_str());
    
    return protectLevel;
}

__attribute__((visibility("hidden"))) NSString* EnvironmentManager::getSigner()
{
    if(signer != NULL){
        return signer;
    }
    return NULL;
}

// SETTER
__attribute__((visibility("hidden"))) void EnvironmentManager::setAppName(NSString* name)
{
    appName = name;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setUserId(NSString* user)
{
    userId = user;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setApiKey(NSString* key)
{
    apiKey = key;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setAppVersion(NSString* version)
{
    appVersion = version;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setBasicInfo(NSString* key, NSString* user, NSString* name, NSString* version)
{
    STInstance(AppGuardChecker)->setCheckFlagA();
    setApiKey(key);
    setUserId(user);
    setAppName(name);
    setAppVersion(version);
    getServerEnv();
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setSigner(NSString* _signer)
{
    signer = _signer;
}

// Replace
__attribute__((visibility("hidden"))) void EnvironmentManager::replaceUserId(NSString* user)
{

    setUserId(user);
    
    char* encUserId = nullptr;
    PacketEncryptor packetEncryptor;
    packetEncryptor.encryptAndEncode((unsigned char*)NS2CString(STInstance(EnvironmentManager)->getUserId()), (int)strlen(NS2CString(STInstance(EnvironmentManager)->getUserId())), &encUserId);

    [LogNCrashManager setUserId:C2NSString(encUserId)];
    
    if (encUserId != nullptr) {
        free(encUserId);
        encUserId = nullptr;
    }
    
    STInstance(RealtimeManager)->startCheckBlackListPolicy();
    STInstance(DetectManager)->resetSendFlags();
    STInstance(ResponseManager)->doNotifyResponse();
    STInstance(ScanDispatcher)->wakeUpScanThread();
}

__attribute__((visibility("hidden"))) AGServerEnvType EnvironmentManager::getServerEnv() {
     
    if( serverEnv != AGServerEnvTypeNone) {
        AGLog(@"env is already set. %d", serverEnv);
        return serverEnv;
    }
    
    serverEnv = AGServerEnvTypeReal;
    
    //launch argument에서 -Server Argument를 가져옴
    NSString* env = nil;
    NSArray<NSString *>* args = [NSProcessInfo processInfo].arguments;
    if(args.count > 1) {
        NSString *argsKey = @"-";
        argsKey = [argsKey stringByAppendingString:NS_SECURE_STRING(appguard_plist_dict_key)];
        argsKey = [argsKey stringByAppendingString:NS_SECURE_STRING(appguard_plist_env_key)];
        for(int i = 1; i<args.count; i++) {
            if([argsKey isEqual:args[i]]) {
                if(i+1 <= args.count-1) {
                    env = args[++i];
                    break;
                }
            }
        }
    }
    
    if(env){
        AGLog(@"Server Env from launch Argument : %@", env);
        if(![env isEqual: NS_SECURE_STRING(env_alpha)] && ![env isEqual: NS_SECURE_STRING(env_beta)]) {
            AGLog(@"Server env is invalid %@", env);
            env = nil;
        }
    } else {
        AGLog(@"Server env is not found from launch argument");
        env = nil;
    }
    
    if(!env) {
        //info.plist에서 서버 정보를 가져옴
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        if(!infoDict) {
            AGLog(@"Can't get info plist. server env: real.");
            return serverEnv;
        }
        
        NSDictionary* appGuardDict = [infoDict objectForKey:NS_SECURE_STRING(appguard_plist_dict_key)];
        if(!appGuardDict) {
            AGLog(@"Can't get appguard dict key from info plist. server env: real.");
            return serverEnv;
        }
        
        NSString* envKey = NS_SECURE_STRING(appguard_plist_env_key);
        env = [appGuardDict objectForKey:envKey];
        if(!env) {
            AGLog(@"Can't get env key from info plist. server env: real.");
            return serverEnv;
        }
    }
    
    if([env isEqual: NS_SECURE_STRING(env_alpha)]) {
        AGLog(@"Server env set Alpha.");
        serverEnv = AGServerEnvTypeAlpha;
    } else if ([env isEqual: NS_SECURE_STRING(env_beta)]) {
        AGLog(@"Server env set Beta.");
        serverEnv = AGServerEnvTypeBeta;
    } else {
        AGLog(@"Server env set real(unknown value).");
    }

    return serverEnv;
}

static __attribute__((visibility("hidden"))) std::string decodeApiKey(const char* encodedApiKey, int apiKeyLen) {
    char* decodedApiKey = new char[apiKeyLen+1];
    memset(decodedApiKey, '\0', apiKeyLen+1);
    
    for(int i = 0; i < apiKeyLen; i++) {
        char decode = encodedApiKey[0] ^ encodedApiKey[i];
        decodedApiKey[i] = decode == '\0' ? encodedApiKey[i] : decode;
    }
    std::string apikey = decodedApiKey;
    delete[] decodedApiKey;
    
    return apikey;
}

__attribute__((visibility("hidden"))) std::string EnvironmentManager::getProtectorInjectedApiKey() {
    ProtectorInjectedApiKeySignature apiKeySignature = {
        {"d24c3a8875bbc8f7f2ffb9fef4d74becb3d4f8f89b9a8aaf033d70b620efb35be44dfb187339529b9c23e480b8ddd063e74648251e033e3d200f156d1716c85a"}, // replace 2a02a552ab75c5de1367b69d135a4fffb121bedd2bd934440560035e83d1d0c7
        {'\0'},
        0
    };
    
    if(CommonAPI::cStrcmp(SECURE_STRING(protector_injected_apikey_signature), apiKeySignature.signature) != 0) {
        AGLog(@"Protector injected API key is not updated.");
        return "unknown";
    }
    
    if(apiKeySignature.apiKeyStrlen == 0 ) {
        AGLog(@"Updated Protector injected API key is invalid. (apikey len field == 0)");
        return "unknown";
    }

    std::string decodedApiKey = decodeApiKey(apiKeySignature.encApiKey, apiKeySignature.apiKeyStrlen);
    AGLog(@"Protector injected API key is %s.", decodedApiKey.c_str());
    
    return decodedApiKey;
}


__attribute__((visibility("hidden"))) void EnvironmentManager::setApplicationStartTime(std::chrono::system_clock::time_point time) {
    applicationStartTime_ = time;
    AGLog(@"Set application start time");
    return;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setEngineStartTime(std::chrono::system_clock::time_point time) {
    engineStartTime_ = time;
    AGLog(@"Set engine start time");
    return;
}

__attribute__((visibility("hidden"))) void EnvironmentManager::setCheckSwizzledCallTime(std::chrono::system_clock::time_point time) {
    checkSwizzledCallTime_ = time;
    AGLog(@"Set checkSwizzled start time");
    return;
}

__attribute__((visibility("hidden"))) std::chrono::system_clock::time_point EnvironmentManager::getApplicationStartTime() {
    return applicationStartTime_;
}

__attribute__((visibility("hidden"))) std::chrono::system_clock::time_point EnvironmentManager::getEngineStartTime() {
    return engineStartTime_;
}

__attribute__((visibility("hidden"))) std::chrono::system_clock::time_point EnvironmentManager::getCheckSwizzledCallTime() {
    return checkSwizzledCallTime_;
}
