//
//  appguard_ios.m
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#import "Diresu.h"
#import "LogNCrash.h"
#import "Singleton.hpp"
#import "HookManager.hpp"
#import "TweakManager.hpp"
#import "DebugManager.hpp"
#import "EncryptionAPI.hpp"
#import "DetectManager.hpp"
#import "PolicyManager.hpp"
#import "EncryptionAPI.hpp"
#import "ScanDispatcher.hpp"
#import "PatternManager.hpp"
#import "NetworkManager.hpp"
#import "AppGuardChecker.hpp"
#import "AGSelfProtectionEntry.hpp"
#import "ResponseManager.hpp"
#import "SecurityEventHandler.h"
#import "EnvironmentManager.hpp"
#import "CommonAPI.hpp"
#import "objc/message.h"
#include "RealtimeManager.hpp"
#import "sdkversion.hpp"
#import "AGAntiDumpManager.hpp"
#import "AGStatusMonitor.hpp"
#import "AGReactNativeManager.hpp"
#import "AGAntiLocationSpoofManager.hpp"
#import "AGContentProtectorManager.hpp"
#import "AGStartupMessage.h"

@interface AppGuardCore () {
    
}

@end

@interface AppGuardCore2 () {
    
}
@end

@interface  AppGuardCore3() <NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *urlSession;
@end

@interface AppGuardCore4 () {
    
}
@end

@implementation AppGuardCore

+ (void) load
{
    if(STInstance(DebugManager)->checkIsatty() == false )
    {
        STInstance(DebugManager)->ptracePtr();
    }
    STInstance(EnvironmentManager)->setApplicationStartTime();
    STInstance(AGStatusMonitor)->start();
    AGLog(@"Protect Level : %s", STInstance(EnvironmentManager)->getProtectLevel().c_str());
    
    char signer_signature[] =
    {
        "1235c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643d11235c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643d1"
    };
    
    AGLog(@"signer_signature : %s", signer_signature);
    
    STInstance(AGReactNativeManager)->Initialize();
    if(CommonAPI::cStrstr(signer_signature, SECURE_STRING(CHECK_SIGNER_PROTECT_ERROR_STRING))) return;
    STInstance(EnvironmentManager)->setSigner([[NSString alloc] initWithUTF8String:signer_signature]);
    
    const AG_SDK_VERSION SDK_VERSION __unused = {
                                        AG_SDK_VERSION_SIGNATURE,
                                        AG_SDK_MAJOR_VERSION,
                                        AG_SDK_MINOR_VERSION,
                                        AG_SDK_PATCH_VERSION,
                                        AG_SDK_RESERVED_VERSION_STRING,
                                        AG_PROTECTOR_VERSION_SIGNATURE
                                        } ;
    [AGStartUpMessage dummy];
}

+ (void)setSignerIntegrity:(NSString*)signer {
#ifdef APPGUARD_RELEASE
    NSLog(NS_SECURE_STRING(f_function_deprecated));
#else
    NSLog(@"The setSignerIntegrity function is deprecated. It no longer works.");
#endif
    return;
}

+ (int) doAppGuard: (NSString*)apiKey :(NSString*)userName :(NSString*)appName :(NSString*)version
{
    __block int ret = -1;
    NSString* unknown = @"unknown";
    static dispatch_once_t onceToken;
    
    if (apiKey == nullptr || ![apiKey isKindOfClass:[NSString class]] || [apiKey length] == 0 || [apiKey compare:unknown options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        ret = -2;
        AGLog(@"doAppGuard ret = %d (The api key is invaild.)", ret);
        return ret;
    }
    
    if (userName == nullptr) {
        userName = unknown;
    }
    if (appName == nullptr) {
        appName = unknown;
    }
    if (version == nullptr) {
        version = unknown;
    }
    
    //여러 번 호출 되더라도 1번만 초기화 할 수 있도록 함.
    dispatch_once(&onceToken, ^{
        dispatch_queue_t appguardStartQueue = dispatch_queue_create(NULL, NULL);
        dispatch_async(appguardStartQueue, ^{
            sleep(1); // #NHN-AppGuard-iOS/511
            AGLog(@"doAppGuard is started.");
            STInstance(EnvironmentManager)->setEngineStartTime();
            STInstance(EnvironmentManager)->setBasicInfo(apiKey, userName, appName, version);
            STInstance(PatternManager)->initPatterns();
            STInstance(PolicyManager)->setDefaultPolicy();
            STInstance(TweakManager)->AntiIG();
            STInstance(AGAntiDumpManager)->Initialize(); // TODO: 덤프로직은 sleep이전에 해야할 것.
            STInstance(ResponseManager)->startResponseThread();
            if(apiKey != nullptr) // CDN에서 앱가드 정책 다운로드 전에 App Key를 확인하는 로직이며 App Key를 전달 받지 못할 경우 그냥 pass 시킴 (앱키를 변경하면 우회가 됨)
            {
                STInstance(PolicyManager)->downloadPolicy(apiKey);
            }
            
            STInstance(LogNCrash)->setUp();
            STInstance(SecurityEventHandler)->callRegisterCallback();
            STInstance(AppGuardChecker)->setCheckFlagE();
            STInstance(RealtimeManager)->startCheckBlackListPolicy();
            STInstance(AGAntiLocationSpoofManager)->Initialize();
            STInstance(AGContentProtectorManager)->Initialize();
            AGLog(@"doAppGuard start");
        });
        ret = 0;
    });
    
    AGLog(@"doAppGuard ret = %d", ret);
    
    return ret;
}

+ (int) setCallback:(IMP) pointer :(bool) useAlert
{
    STInstance(SecurityEventHandler)->setObjcCallback(pointer, useAlert);
    return 0;
}

+ (int) setAppGuardUnityCallback:(void*) pointer :(bool) useAlert
{
    STInstance(SecurityEventHandler)->setUnityCallback(pointer, useAlert);
    return 0;
}

+ (int) setUseAlert:(bool) useAlert
{
    STInstance(SecurityEventHandler)->setAlert(useAlert);
    return 0;
}
//    다음과 같은 히스토리로 주석처리
//    https://nhnent.dooray.com/project/1887598915138729759/3367385966952787630?contentsType=contents
//+ (void) appGuardEncryption: (NSString*) data
//{
//    STInstance(EncryptionAPI)->startEncryptionAPI(data);
//}

+ (int) setUserName: (NSString*) username
{
    if (username == nullptr) {
        username = @"unknown";
    }
    
    STInstance(EnvironmentManager)->replaceUserId(username);
    return 0;
}

+ (NSString *)getDeviceID {
    // DeviceInfoCollector::getDeviceId()로직과 같아야함. 보안이슈로 인해 이원화됨. #NHN-AppGuard-iOS/263
    NSString* deviceId = @"N/A";
    UIDevice* device = [UIDevice currentDevice];
    if(device != nil) {
        deviceId = [device.identifierForVendor UUIDString];
        if( deviceId.length == 0) {
            deviceId = @"N/A";
        }
    }
    return deviceId;
}

+ (void) sslPinningCheck
{
    AppGuardCore3 *AGN = [[AppGuardCore3 alloc]init];
    [AGN sslPinningCheckk];
}

+ (void) offDebugDetect
{
    STInstance(PatternManager)->offDebug();
}

+ (void) forceExitWithAlert
{
    STInstance(SecurityEventHandler)->setForceExit();
}

+ (void)free
{
    STInstance(DetectManager)->releaseDetectInfos();
    STInstance(PatternManager)->releasePatterns();
}
@end

@implementation AppGuardCore2
+ (void) ptraceCheck // Dummy Method
{
    STInstance(DebugManager)->ptraceAsm();
}
+ (void) dummy1 // Dummy Method
{
#define REGISTER_SELECTOR(sel, notif_name)                    \
if([self respondsToSelector:sel])                            \
[[NSNotificationCenter defaultCenter]    addObserver:self    \
selector:sel    \
name:notif_name    \
object:nil        \
];
    REGISTER_SELECTOR(@selector(didEnterBackground:), UIApplicationDidEnterBackgroundNotification);
    REGISTER_SELECTOR(@selector(willHide:), UIKeyboardWillHideNotification);
    REGISTER_SELECTOR(@selector(didShow:), UIMenuControllerDidShowMenuNotification);
#undef REGISTER_SELECTOR
}

+ (void) checkAppGuardRunning // Check AppGuard excute
{
    STInstance(AppGuardChecker)->checkTweak();
    STInstance(AppGuardChecker)->checkAppGuard();
    STInstance(AppGuardChecker)->checkAppGuardScan();
    STInstance(AppGuardChecker)->checkAppGuardResponse();
    STInstance(AppGuardChecker)->checkThread();
    STInstance(AppGuardChecker)->checkIntegrity();
    STInstance(AppGuardChecker)->checkFinal();
}
+ (void) detectTweak // Anti Tweak
{
    STInstance(TweakManager)->AntiIG();
}
+ (void) checkAppGuardSwizzled // Anti A-Bypass
{
    STInstance(HookManager)->swizzlingAppGuardAPIB();
}
+ (void) dummy2 // Dummy Method
{
    STInstance(ResponseManager)->doResponseAll();
}
+ (void)didEnterBackground:(NSNotification*)notification
{
    STInstance(TweakManager)->removeTweakA();
}
+ (void)willHide:(NSNotification*)notification
{
    STInstance(TweakManager)->removeTweakB();
}
+ (void)didShow:(NSNotification*)notification
{
    STInstance(TweakManager)->removeTweakC();
}
@end

@implementation AppGuardCore3
- (void) sslPinningCheckk // Check SSL Pinning
{
    @try{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if(sessionConfig)
        {
            sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            if(self.urlSession)
            {
                NSString* url = STInstance(NetworkManager)->getURL();
                AGLog(@"ssl url - [%@]", url);
                if(url != nil)
                {
                    char* queue = SECURE_STRING(appguardPinningQueue);
                    dispatch_queue_t appguardPinningQueue = dispatch_queue_create(queue, NULL);
                    if(appguardPinningQueue)
                    {
                        [[self.urlSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                dispatch_async(appguardPinningQueue, ^{
                                    if (error)
                                    {
                                        int errorCode = (int)[error code];
                                        AGLog(@"[%d]", errorCode);
                                        if(errorCode == -999)
                                        {
                                            STInstance(NetworkManager)->setPinningValue((char*)"A");
                                        }
                                        else if(errorCode == 310)
                                        {
                                            STInstance(NetworkManager)->setPinningValue((char*)"B");
                                        }
                                    }
                                });
                        }] resume];
                    }
                }
            }
        }
    }@catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

#pragma mark - NSURLSession delegate
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    // Get remote certificate
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
    
    // Set SSL policies for domain name check
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    // Get local and remote cert data
    NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
    NSData *localCertificate = STInstance(NetworkManager)->getPublicKey();
    // The pinnning check
    if([remoteCertificateData isEqualToData:localCertificate])
    {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
    }
}

+ (void) antiABypass // Check ABypass
{
    if(STInstance(JailbreakManager)->checkABypass() != false)
    {
        STInstance(HookManager)->stopNetworkD();
    }
}
+ (void) checkTweak2 // Check Tweak
{
    STInstance(HookManager)->stopNetworkA();
}
+ (void) checkTweak3 // Check Tweak
{
    STInstance(HookManager)->stopNetworkB();
}
+ (void) checkTweak4 // Check Tweak
{
    STInstance(HookManager)->stopNetworkC();
}

@end

@implementation AppGuardCore4
+ (void) antiIOSGod // Anti IG
{
    STInstance(TweakManager)->AntiIG();
}
+ (void) dummy3:(void*)a option:(bool)b // Dummy Method
{
    STInstance(SecurityEventHandler)->setUnityCallback(a, b);
}
+ (void) checkTweak5:(NSString*)a // Check Tweak
{
    STInstance(AppGuardChecker)->tweakMonitor(a);
}
+ (void) dummy4:(NSString*)a // Dummy Method
{
    STInstance(EnvironmentManager)->replaceUserId(a);
}
+ (void) dummy5:(IMP)a option:(bool)b // Dummy Method
{
    STInstance(SecurityEventHandler)->setObjcCallback(a, b);
}
+ (void) checkAppGuardHookk // Check AppGuard hook
{
    STInstance(AppGuardChecker)->checkAppGuardHook();
}
+ (void) checkTweakk // Check Tweak
{
    STInstance(AppGuardChecker)->checkTweak();
}
+ (void) checkTweakk2 // Check Tweak
{
    STInstance(TweakManager)->removeTweakA();
}
+ (void) checkTweakk3 // Check Tweak
{
    STInstance(TweakManager)->removeTweakB();
}
+ (void) checkTweakk4 // Check Tweak
{
    STInstance(TweakManager)->removeTweakC();
}
@end
