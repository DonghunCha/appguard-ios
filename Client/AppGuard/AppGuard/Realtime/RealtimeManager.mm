//
//  RealtimeManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 22/06/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "RealtimeManager.hpp"

__attribute__((visibility("hidden"))) void RealtimeManager::startCheckBlackListPolicy()
{
    @try{
        char* queue = SECURE_STRING(appguardBlockQueue);
        realTimeQueue = dispatch_queue_create(queue, NULL);
        AGLog(@"Create queue - [%s]", queue);
        if(realTimeQueue != NULL)
        {
            dispatch_async(realTimeQueue, ^{
                pthread_mutex_lock(&realTimeLock);
                
                EnvironmentManager* envMgr = STInstance(EnvironmentManager);
               
               
                if(checkRealTimePolicy(C2NSString(envMgr->getApiKey().c_str()), envMgr->getUserId(), C2NSString(envMgr->getDeviceId().c_str()), AGPatternGroupBlackList))
                {
                    sleep(3); // 차단 Alert창이 너무 바로 뜨는 것을 방지하기 위해.
                    DetectInfo* blockDetectInfo = new DetectInfo(0, AGPatternGroupBlackList, AGPatternNameBlackList, AGResponseTypeBlock, "");
                    blockDetectInfo->patternIndex_ = 0;
                    blockDetectInfo->detail_ = [[@(userSeq_) stringValue] cStringUsingEncoding:NSUTF8StringEncoding];
                    STInstance(LogNCrash)->sendLog(kRealTime, blockDetectInfo, SECURE_STRING(block));
                    STInstance(ResponseManager)->BlockMsg(blockDetectInfo);
                    delete blockDetectInfo;
                }
                
                
                pthread_mutex_unlock(&realTimeLock);
            });
        }
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

__attribute__((visibility("hidden"))) bool RealtimeManager::isBlockConditionalPolicy(AGPatternGroup patterngroup) {
    EnvironmentManager* envMgr = STInstance(EnvironmentManager);
    return checkRealTimePolicy(C2NSString(envMgr->getApiKey().c_str()), envMgr->getUserId(), C2NSString(envMgr->getDeviceId().c_str()), patterngroup);
}

__attribute__((visibility("hidden"))) bool RealtimeManager::checkRealTimePolicy(NSString* appKey, NSString* userId, NSString* deviceId, AGPatternGroup patterngroup)
{
    __block bool result = false;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    PacketEncryptor *packetEncryptor = STInstance(PacketEncryptor);
    
    NSString* encAppKey = packetEncryptor->encryptAndEncode(appKey);
    NSString* encUserId = packetEncryptor->encryptAndEncode(userId);
    NSString* encDeviceId = packetEncryptor->encryptAndEncode(deviceId);
    NSString* encRuleGroupSeq = packetEncryptor->encryptAndEncode([@(patterngroup) stringValue]);
    NSString* OS = @"i";
    OS = [OS stringByAppendingString:@"O"];
    OS = [OS stringByAppendingString:@"S"];
    NSString* encOS = packetEncryptor->encryptAndEncode(OS);
    
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    [contentDictionary setValue:encAppKey forKey:@"A"];
    [contentDictionary setValue:encUserId forKey:@"U"];
    [contentDictionary setValue:encDeviceId forKey:@"D"];
    [contentDictionary setValue:encRuleGroupSeq forKey:@"R"];
    [contentDictionary setValue:encOS forKey:@"O"];
    
    NSData *_data = [NSJSONSerialization dataWithJSONObject:contentDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSData *encodeJsonStr = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithUTF8String:SECURE_STRING(real_realtime_policy_url)];
    AGServerEnvType serverEnv = STInstance(EnvironmentManager)->getServerEnv();
    if(serverEnv == AGServerEnvTypeAlpha) {
        url = [NSString stringWithUTF8String:SECURE_STRING(alpha_realtime_policy_url)];
    } else if (serverEnv == AGServerEnvTypeBeta) {
        url = [NSString stringWithUTF8String:SECURE_STRING(beta_realtime_policy_url)];
    }
    
    AGLog(@"Realtime Request URL: %@", url);
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:encodeJsonStr];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (error != nil) {
            AGLog(@"Error - %@", error);
            dispatch_semaphore_signal(sem);
            return;
        }
        if (httpResponse == nil) {
            AGLog(@"Error - Response");
            dispatch_semaphore_signal(sem);
            return;
        }
           
        NSInteger stCode = [httpResponse statusCode];
        if (stCode != 200) {
            AGLog(@"Error - Status : [%ld]", stCode);
            dispatch_semaphore_signal(sem);
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError) {
            AGLog(@"Error - JSON parse");
            dispatch_semaphore_signal(sem);
            return;
        }
                    
        AGLog(@"checkRealTimePolicy::JSON Content: %@", responseDictionary);
        
        NSDictionary* dicData = [responseDictionary objectForKey:@"data"];
        NSString* decodedST = packetEncryptor->decryptAndDecode([dicData objectForKey:@"ST"]);
        if (decodedST != nil) {
            AGLog(@"checkRealTimePolicy:: ST: %@", decodedST);
            if ([decodedST containsString:NS_SECURE_STRING(BLOCK)]) {
                NSString* decodedBS = packetEncryptor->decryptAndDecode([dicData objectForKey:@"BS"]);
                if (decodedBS != nil) {
                    userSeq_ = (int)[decodedBS integerValue];
                }
                result = true;
            }
            else {
                AGLog(@"Error - Nomal");
            }
        } else {
            AGLog(@"Error - Decrypt");
        }
        dispatch_semaphore_signal(sem);
    }];
    
    [dataTask resume];
    
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10ull * NSEC_PER_SEC);
    dispatch_semaphore_wait(sem, timeout);
    
    return result;
}
