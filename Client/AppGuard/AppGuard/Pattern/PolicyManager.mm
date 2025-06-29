//
//  PolicyManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 2. 27..
//  Copyright © 2019년 nhnent. All rights reserved.
//

#include "PolicyManager.hpp"



// @author  : daejoon kim
// @param   : API Key (App Key)
// @brief   : 정책 파일 다운로드의 쓰레드 생성
__attribute__((visibility("hidden"))) void PolicyManager::downloadPolicy(NSString* apiKey)
{
    @try{
        char* queue = SECURE_STRING(appguardPolicyQueue);
        appguardPolicyQueue = dispatch_queue_create(queue, NULL);
        AGLog(@"Create queue - [%s]", queue);
        if(appguardPolicyQueue != NULL)
        {
            dispatch_async(appguardPolicyQueue, ^{
                pthread_mutex_lock(&downloadLock);
                download(apiKey);
                pthread_mutex_unlock(&downloadLock);
            });
        }
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

__attribute__((visibility("hidden"))) bool PolicyManager::setDefaultPolicy() {
    bool result = false;
    //백업된 정책파일이 있다면 기본 정책으로 바로 적용
    NSString *backupPolicyFile = getBackupPolicyPath();
    if(Util::checkFileExist(NS2CString(backupPolicyFile))) {
        result = setPolicyWithFile(backupPolicyFile);
    }
    
    if(result == false) {
        AGLog(@"Unable to retrieve the default policy from the backed up policy file. Gets the default policy from the signature.");
        //Protector에 의해 삽입된 시그니처에서 정책을 가져와 기본정책 적용
        NSString *defaultPolicy = getDefaultPolicyFromSignature();
        if(defaultPolicy.length != 0) {
            if(setPolicyWithJson(defaultPolicy)) {
                AGLog(@"Set Defualt Policy from signature. [%@]", defaultPolicy);
                result = true;
            }
        }
    } else {
        AGLog(@"The backed up policy was successfully loaded. (%@)", backupPolicyFile);
    }
    return result;
}

__attribute__((visibility("hidden"))) bool PolicyManager::backupPolicyFile(NSString* srcPath) {
 
    if(!Util::checkFileExist(NS2CString(srcPath))) {
        AGLog(@"%@ is not found.", srcPath);
        return false;
    }
    NSString* policyBackupPath = getBackupPolicyPath();
    if(Util::checkFileExist(NS2CString(policyBackupPath))) {
        if(!Util::removeFile(policyBackupPath)) {
            AGLog(@"Unable to delete file.(%@)", policyBackupPath);
            return false;
        }
    }
    
    if(Util::copyFile(srcPath, policyBackupPath) == false) {
        AGLog(@"Unable to backup file.(%@)", policyBackupPath);
        return false;
    }
    
    if(Util::excludeiCloudBackupFile(policyBackupPath) == false) {
        AGLog(@"Unable to exclude iCloud backup file.(%@)", policyBackupPath);
    }
    
    return true;
}
// @author  : daejoon kim
// @param   : API Key (App Key)
// @brief   : 정책 파일 다운로드를 수행
__attribute__((visibility("hidden"))) void PolicyManager::download(NSString* apiKey)
{
    STInstance(EncryptionAPI)->setEncFlagC();
    STInstance(AppGuardChecker)->setCheckFlagC();
    
    while(true)
    {
        if(downloadComplete) {
            AGLog(@"Download task - complete");
            break; // 다운로드가 완료되었으면 다운로드 수행 중지 (다운로드가 안되면 10초마다 재실행)
        }
        NSString * policyURL = getPolicyURL(apiKey);
        NSURL * url = [NSURL URLWithString:policyURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        NSURLSession * sharedSession = [NSURLSession sharedSession];
        NSURLSessionDownloadTask * downloadTask =
            [sharedSession downloadTaskWithRequest:request
                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                {
                                    if(error == nil) // request 에러 확인
                                    {
                                        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*) response;
                                        if(httpResponse != nil)
                                        {
                                            NSInteger stCode = [httpResponse statusCode];
                                            AGLog(@"Status Code - [%ld] %@", stCode, policyURL);
                                            if(stCode == 200)
                                            {
                                                NSString* contentType = httpResponse.allHeaderFields[ NS_SECURE_STRING(content_type)  ];
                                                AGLog(@"Content Type - [%@]", contentType);
                                                if(contentType != nil)
                                                {
                                                    if(CommonAPI::cStrcmp(NS2CString(contentType), SECURE_STRING(octet_stream)) == 0)
                                                    {
                                                        if(setPolicyWithFile(location.path)) {
                                                            downloadComplete = true;
                                                            AGLog(@"Start Scan thread with downloaded policy.");
                                                            STInstance(ScanDispatcher)->startScanThread();
                                                            //정책 파일을 백업
                                                            backupPolicyFile(location.path);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }else
                                    {
                                        if(error.code == -999)
                                        {
                                            if(STInstance(JailbreakManager)->checkDyld( SECURE_STRING(AppFirewall_dylib) ) != false)
                                                
                                            {
                                                AGLog(@"Detected AppFirewall");
                                                STInstance(PatternManager)->setResponse(AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock,
                                                                                        AGResponseTypeBlock
                                                                                        );
                                                downloadComplete = true;
                                            }
                                        }
                                    }
                
                                    if(downloadComplete == false) {
                                        AGLog(@"The policy download task is not completed.");
                                        if(defaultPolicy == false) {
                                            if (setDefaultPolicy()) {
                                                defaultPolicy = true;
                                                AGLog(@"Start Scan thread with default policy.");
                                                STInstance(ScanDispatcher)->startScanThread();
                                            }
                                        } else {
                                            AGLog(@"Already set Defualt Policy.");
                                        }
                                    }
                }];
        AGLog(@"Donwload task - resume");
        [downloadTask resume];
        STInstance(CommonAPI)->stdSleepFor(10);
    }
}

// @author  : daejoon kim
// @param   : API Key (App Key)
// @return  : 다운로드 정책 파일의 CDN URL (NSString*)
// @brief   : 다운로드 정책 파일의 CDN URL을 조합
__attribute__((visibility("hidden"))) NSString* PolicyManager::getPolicyURL(NSString * apiKey)
{
    //https://adam.cdn.toastoven.net/ios/(apiKey)/policy.json
    NSString * policyFileName = NS_SECURE_STRING(policy_json);
    NSString * policyURL      = NS_SECURE_STRING(cdn_address);
    NSString * policySubUrl = NS_SECURE_STRING(cdn_policy_sub_path);
    
    AGServerEnvType serverEnv = STInstance(EnvironmentManager)->getServerEnv();
    if(serverEnv == AGServerEnvTypeAlpha) {
        policySubUrl = NS_SECURE_STRING(cdn_policy_sub_path_alpha);
    } else if (serverEnv == AGServerEnvTypeBeta) {
        policySubUrl = NS_SECURE_STRING(cdn_policy_sub_path_beta);
    }
    
    policyURL = [policyURL stringByAppendingString:policySubUrl];
    policyURL = [policyURL stringByAppendingString:@"/"];
    policyURL = [policyURL stringByAppendingString:apiKey];
    policyURL = [policyURL stringByAppendingString:@"/"];
    policyURL = [policyURL stringByAppendingString:policyFileName];
    policyURL = [policyURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AGLog(@"CDN URL : %@", policyURL);
    return policyURL;
}

__attribute__((visibility("hidden"))) NSString* PolicyManager::getBackupPolicyPath()
{
    NSString* applicationSupportDirectory = Util::getApplicationSupportPath();
    NSString* hashKey = [NSString stringWithFormat:@"%@.%@.%@",C2NSString(STInstance(EnvironmentManager)->getApiKey().c_str()), C2NSString(STInstance(EnvironmentManager)->getPackageInfo().c_str()), NS_SECURE_STRING(policy_json)];
    hashKey = [hashKey stringByAppendingString:@"4"]; // policy 파일 버전 4 (policy.json)
    NSString* backupPolicyFileName = Util::sha256Hash(hashKey);
    applicationSupportDirectory = [applicationSupportDirectory stringByAppendingPathComponent:backupPolicyFileName];
    AGLog(@"Backup Policy file path : %@", applicationSupportDirectory);
    return applicationSupportDirectory;
}

// @author  : daejoon kim
// @param   : 정책 파일 경로
// @brief   : 정책을 세팅
__attribute__((visibility("hidden"))) bool PolicyManager::setPolicyWithFile(NSString* path)
{
    bool result = false;
    NSString * decData = STInstance(Decryptor)->decryptFile(path);
    AGLog(@"Decrypt policy data : %@", decData);
    if(decData != nil) {
        result = setPolicyWithJson(decData);
    }
    return result;
}

bool PolicyManager::validatePolicyJsonDict(NSDictionary *jsonDict) {
    if(!jsonDict[NS_SECURE_STRING(policy_json_key_version)]) {
        AGLog(@"Error while validating JSON: version field is not found");
        return false;
    }
    
    if(!jsonDict[NS_SECURE_STRING(policy_json_key_updatedDateTime)]) {
        AGLog(@"Error while validating JSON: updatedDateTime field is not found");
        return false;
    }
    
    if(!jsonDict[NS_SECURE_STRING(policy_json_key_appkey)]) {
        AGLog(@"Error while validating JSON: appKey field is not found");
        return false;
    }
    
    NSString *appKey = jsonDict[NS_SECURE_STRING(policy_json_key_appkey)];
    if(![appKey isEqualToString: C2NSString(STInstance(EnvironmentManager)->getApiKey().c_str())]) {
        AGLog(@"Appkey is invalid. policy: %@, EnvironmentManager: %@", appKey, C2NSString(STInstance(EnvironmentManager)->getApiKey().c_str()));
        return false;
    }
    
    if(!jsonDict[@"os"]) {
        AGLog(@"Error while validating JSON: os field is not found");
        return false;
    }
    
    if(!jsonDict[NS_SECURE_STRING(policy_json_key_uuid)]) {
        AGLog(@"Error while validating JSON: uuid field is not found");
        return false;
    }
    
    if(!jsonDict[NS_SECURE_STRING(policy_json_key_ruleGroups)]) {
        AGLog(@"Error while validating JSON: ruleGroups field is not found");
        return false;
    }
    
    for (NSDictionary *ruleGroup in jsonDict[NS_SECURE_STRING(policy_json_key_ruleGroups)]) {
        // 각 ruleGroup의 "seq"와 "action" 키에 접근
      
        if(!ruleGroup[@"seq"]) {
            AGLog(@"Error while validating JSON: ruleGroups > seq field is not found");
            return false;
        }
        if(!ruleGroup[NS_SECURE_STRING(policy_json_key_action)]) {
            AGLog(@"Error while validating JSON: ruleGroups > action field is not found %@", NS_SECURE_STRING(policy_json_key_action));
            return false;
        }
    }
    
    return true;
}

bool PolicyManager::setPolicyWithJson(NSString* decJsonPolicy) {
    bool result = false;
    NSError *error = nil;
    NSData *jsonData = [decJsonPolicy dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        AGLog(@"Error while parsing JSON: %@", error);
        return result;
    }
    
    if(!validatePolicyJsonDict(jsonDict)) {
        return result;
    }
    NSString *uuid = jsonDict[NS_SECURE_STRING(policy_json_key_uuid)];
#ifdef DEBUG
    NSString *version = jsonDict[NS_SECURE_STRING(policy_json_key_version)];
    NSString *updatedDateTime = jsonDict[NS_SECURE_STRING(policy_json_key_updatedDateTime)];
    NSString *appKey = jsonDict[NS_SECURE_STRING(policy_json_key_appkey)];
    NSNumber *os = jsonDict[@"os"];

    AGLog(@"Version: %@", version);
    AGLog(@"Updated DateTime: %@", updatedDateTime);
    AGLog(@"App Key: %@", appKey);
    AGLog(@"OS: %@", os);
    AGLog(@"policy file UUID: %@", uuid);
    
#endif
    NSArray *ruleGroups = jsonDict[NS_SECURE_STRING(policy_json_key_ruleGroups)];
    
    AGResponseType jailbreak = AGResponseTypeOff;
    AGResponseType cheating  = AGResponseTypeOff;
    AGResponseType debugger  = AGResponseTypeOff;
    AGResponseType modification = AGResponseTypeOff;
    AGResponseType simulator = AGResponseTypeOff;
    AGResponseType hook = AGResponseTypeOff;
    AGResponseType network = AGResponseTypeOff;
    AGResponseType locationSpoof = AGResponseTypeOff;
    AGResponseType screenCapture = AGResponseTypeOff;
    AGResponseType screenRecord = AGResponseTypeOff;
    AGResponseType macroTool = AGResponseTypeOff;
    AGResponseType vpnDetection = AGResponseTypeOff;

    
    for (NSDictionary *ruleGroup in ruleGroups) {
        // 각 ruleGroup의 "seq"와 "action" 키에 접근
        NSNumber *seq = ruleGroup[@"seq"];
        NSNumber *action = ruleGroup[NS_SECURE_STRING(policy_json_key_action)];
        switch ([seq intValue]) {
            case AGPatternGroupJailbreak:
                AGLog(@"Seq: %@ jailbreak, Action: %@", seq, action);
                jailbreak = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupCheatingTool:
                AGLog(@"Seq: %@ cheating, Action: %@", seq, action);
                cheating = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupDebugger:
                AGLog(@"Seq: %@ debugger, Action: %@", seq, action);
                debugger = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupModification:
                AGLog(@"Seq: %@ modification, Action: %@", seq, action);
                modification = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupSimulator:
                AGLog(@"Seq: %@ simulator, Action: %@", seq, action);
                simulator = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupHooking:
                AGLog(@"Seq: %@ hook, Action: %@", seq, action);
                hook = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupNetwork:
                AGLog(@"Seq: %@ network, Action: %@", seq, action);
                network = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupLocationSpoofing:
                AGLog(@"Seq: %@ location spoofing, Action: %@", seq, action);
                locationSpoof = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupScreenCapture:
                AGLog(@"Seq: %@ screen capture, Action: %@", seq, action);
                screenCapture = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupScreenRecord:
                AGLog(@"Seq: %@ screen record, Action: %@", seq, action);
                screenRecord = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupMacroTool:
                AGLog(@"Seq: %@ macrotool, Action: %@", seq, action);
                macroTool = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            case AGPatternGroupVPN:
                AGLog(@"Seq: %@ vpn, Action: %@", seq, action);
                vpnDetection = STInstance(PatternManager)->getResponseType([action intValue]);
                break;
            default:
                AGLog(@"Unknown Seq: %@ network, Action: %@", seq, action);
                break;
        }
 
    }

    STInstance(PatternManager)->setResponse(jailbreak, cheating, debugger, modification, simulator, hook, network, locationSpoof, screenCapture, screenRecord, macroTool, vpnDetection); // 정책을 셋팅

    policyFileUuid_ = [uuid cStringUsingEncoding:NSUTF8StringEncoding];

    result = true;
    
    return result;
}

__attribute__((visibility("hidden"))) NSString* PolicyManager::getDefaultPolicyFromSignature() {
    
    NSString* defaultPolicy = @"";
    if(defaultPolicySignature.signature[0] == '7' && defaultPolicySignature.signature[1] == '8') {
        AGLog(@"default policy signature is not updated.");
        return defaultPolicy;
    }
    
    if(defaultPolicySignature.signature[0] != 0x01 && defaultPolicySignature.signature[1] != 0x01) {
        AGLog(@"default policy signature header is invalid.");
        return defaultPolicy;
    }
    
    if(defaultPolicySignature.payloadLength == 0 || defaultPolicySignature.payloadLength > MAX_DEFAULT_POLICY_PAYLOAD_LEN) {
        AGLog(@"default policy signature size is invalid.");
        return defaultPolicy;
    }
    AGLog(@"default policy signature size is %u", defaultPolicySignature.payloadLength);
    
    unsigned char* data = nullptr;
    data = new unsigned char[defaultPolicySignature.payloadLength+1];
    if(data == nullptr) {
        AGLog(@"default policy buffer alloc fail.");
        return defaultPolicy;
    }
    
    memset(data, 0x0, defaultPolicySignature.payloadLength+1);
    memcpy(data, defaultPolicySignature.payload, defaultPolicySignature.payloadLength);

    defaultPolicy = STInstance(Decryptor)->decryptData(reinterpret_cast<char*>(data), defaultPolicySignature.payloadLength);
    AGLog(@"default policy signature is updated. %@", defaultPolicy);
    
    delete[] data;
    data = nullptr;

    return defaultPolicy;
}

__attribute__((visibility("hidden"))) std::string PolicyManager::getPolicyFileUuid() {
    
    return policyFileUuid_;
}
