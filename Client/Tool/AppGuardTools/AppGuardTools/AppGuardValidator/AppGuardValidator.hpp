//
//  AppGuardValidator.h
//  AppGuardMySample
//
//  Created by NHN on 2023/01/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AppGuardValidator : NSObject
+ (NSString*)getNumberOfLCSignature:(NSString*)machOFile;
+ (NSString*)getTextSectionSignature:(NSString*)machOFile;
+ (NSString*)getDefaultPolicySignature:(NSString*)machOFile;
+ (NSString*)getNewDefaultPolicySignature:(NSString*)machOFile;
+ (NSString*)getSignerSignature:(NSString*)machOFile;
+ (NSString*)getUnityTextSectionSignature:(NSString*)machOFile;
+ (NSString*)getUnityIl2cppSectionSignature:(NSString*)machOFile;
+ (NSString*)getInfoPlistSignature:(NSString*)machOFile;
+ (NSArray*)getClassList:(NSString*)machOFile;
+ (NSString*)getDefaultProtectLevelSignature:(NSString*)machOFile;
+ (int)getProtectLevel:(NSString*)machOFile;
+ (NSString*)getSDKVersion:(NSString*)machOFile;
+ (NSString*)getProtectorVersion:(NSString*)machOFile;
+ (unsigned long long)getPlistInfoSizeFromSignature:(NSString*)machOFile;
+ (NSString*)getPlistInfoHashFromSignature:(NSString*)machOFile;
+ (NSString*)getPlistInfoHashFromIPA;
+ (NSString*)getApiKey:(NSString*)machOFile;
+ (NSString*)getApiKeyReplaceSignature:(NSString*)machOFile;
+ (NSString*)getApiKeySignature:(NSString*)machOFile;
+ (NSString*)getStartupMessageSignature:(NSString*)machOFile;
+ (NSString*)getStartupMessageReplaceSignature:(NSString*)machOFile;
+ (unsigned int)getStartupmessageDuration:(NSString*)machOFile;
+ (unsigned int)getStartupmessageDelay:(NSString*)machOFile;
+ (NSString*)getDetectionPopupSignatre:(NSString*)machOFile;
+ (NSString*)getDetectionPopupReplaceSignature:(NSString*)machOFile;
+ (int)getDetectionPopupMode:(NSString*)machOFile;
@end

NS_ASSUME_NONNULL_END
