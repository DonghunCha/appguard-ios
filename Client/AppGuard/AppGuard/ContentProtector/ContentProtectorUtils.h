//
//  Utils.h
//  ContentProtector
//
//  Created by NHN on 8/26/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// internal Objc class obfuscation
#ifndef DEBUG
#define ContentProtectorUtils F77N6QW5P2E2X9O1UW2DR
#define isUsingSceneDelegate V1XT6JZVGNQNIKMA6V5VQ
#define currentWindow EO5SLONSPHDNCO8VIGLT1
#define blackImage EL89FR9XWW2DNRL89B5DO
#endif

@interface ContentProtectorUtils : NSObject
+ (BOOL)isUsingSceneDelegate;
+ (UIWindow *)currentWindow;
+ (UIImage *)blackImage;
@end

NS_ASSUME_NONNULL_END
