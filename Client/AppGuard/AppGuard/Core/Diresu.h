//
//  appguard_ios.h
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#import <AppGuard/SymbolObfuscate.h>
#import <Foundation/Foundation.h>

@interface AppGuardCore : NSObject
+ (int) doAppGuard: (NSString*) apiKey :(NSString*)userName :(NSString*)appName :(NSString*)version;
+ (int) setCallback:(IMP) pointer :(bool) useAlert;
+ (int) setAppGuardUnityCallback:(void*) func :(bool) useAlert;
+ (int) setUseAlert:(bool) useAlert;
+ (int) setUserName: (NSString*) username;
+ (NSString *) getDeviceID;
+ (void) setSignerIntegrity:(NSString*)signer __attribute__((deprecated));
+ (void) sslPinningCheck;
+ (void) offDebugDetect;
+ (void) forceExitWithAlert;
+ (void) free;
@end


@interface AppGuardCore2 : NSObject
+ (void) ptraceCheck;
+ (void) dummy1;
+ (void) checkAppGuardRunning;
+ (void) detectTweak;
+ (void) checkAppGuardSwizzled;
+ (void) dummy2;
@end

@interface AppGuardCore3 : NSObject
- (void) sslPinningCheckk;
+ (void) antiABypass;
+ (void) checkTweak2;
+ (void) checkTweak3;
+ (void) checkTweak4;
@end


@interface AppGuardCore4 : NSObject
+ (void) antiIOSGod;
+ (void) dummy3:(void*)a option:(bool)b;
+ (void) checkTweak5:(NSString*)a;
+ (void) dummy4:(NSString*)a;
+ (void) dummy5:(IMP)a option:(bool)b;
+ (void) checkAppGuardHookk;
+ (void) checkTweakk;
+ (void) checkTweakk2;
+ (void) checkTweakk3;
+ (void) checkTweakk4;
@end

FOUNDATION_EXPORT int checkSwizzled();
FOUNDATION_EXPORT int checkCodeHashByAppGuard();





static NSString * const NHNAppGuardVersion = @"1.4.11";



