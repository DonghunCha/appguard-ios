//
//  NHNAG.hpp
//  AppGuard
//
//  Created by NHNEnt on 25/02/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef NHNAG_hpp
#define NHNAG_hpp
#import "SymbolObfuscate.h"
#import <Foundation/Foundation.h>


@interface ProtectSelf: NSObject
- (void) checkAppGuardSwizzled2;
- (int) doAppGuardAPI:(NSString*)apiKey :(NSString*)userName :(NSString*)appName :(NSString*)version; // s
- (int) setCallbackAPI:(IMP) pointer :(bool) useAlert; // o
- (int) setUnityCallbackAPI:(void*) func :(bool) useAlert; // v
- (int) useAlertAPI:(bool) useAlert; // w
- (int) setUserNameAPI:(NSString*) username; // n
- (void) appGuardEncAPI:(NSString*) data; // e
- (void) sslPinningAPI; // k
- (void) offDebugDetectAPI; // t
- (void) forceExitWithAlertAPI; // z
- (void) freeAPI; // free
@end


// -------------------------------------------------------------------------------
// --------------------------------Deprecated-------------------------------------
// -------------------------------------------------------------------------------
@interface RNCryptorUnLoader : NSObject
+ (void) unload;
+ (void) error;
+ (void) check;
+ (void) finish;
@end
// -------------------------------------------------------------------------------
#endif /* NHNAG_hpp */
