//
//  Utils.m
//  ContentProtector
//
//  Created by NHN on 8/26/24.
//

#import "ContentProtectorUtils.h"
#include "util.h"
@implementation ContentProtectorUtils

+ (BOOL)isUsingSceneDelegate {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        NSSet *connectedScenes = [UIApplication.sharedApplication connectedScenes];
        if (connectedScenes.count > 0) {
            for (UIScene *scene in connectedScenes) {
                if ([scene.delegate conformsToProtocol:@protocol(UISceneDelegate)]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (UIWindow *)currentWindow {
    UIWindow* window = nil;
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        for (UIWindowScene* windowScene in UIApplication.sharedApplication.connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }
    if(window == nil)
    {
        window = UIApplication.sharedApplication.keyWindow ?  UIApplication.sharedApplication.keyWindow :  UIApplication.sharedApplication.windows.firstObject;
    }
    
    return window;
}

+ (UIImage *)blackImage {
    CGSize imageSize = CGSizeMake(64, 64);
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
