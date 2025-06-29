//
//  StartUpMessage.m
//  AppGuard
//
//  Created by NHN on 1/6/25.
//

#import "AGStartupMessage.h"
#import "AGCommon.hpp"
#import "Util.h"
#import <UIKit/UIKit.h>

#ifndef DEBUG
#define isActiveStartupMessage ililiiiiliiliiliiiiii
#define showToastMessage iiiilililiililiiiiii
#define appDidFinishLaunching iliiliililililililil
#define isActive iiiilililililiiiilil
#endif

#define STARTUP_SIGNATURE_MAX_LEN 256

union StartupMessageSignature {
    unsigned char rawData[STARTUP_SIGNATURE_MAX_LEN];
    struct {
        char signature[68];
        unsigned int durationMillisec;
        unsigned int delayMillisec;
    };
};

static double durationSec = 2.0;
static double delaySec = 1.0;

static AG_PRIVATE_API bool isActiveStartupMessage(unsigned int* durationMillisecond, unsigned int* delayMillisecond) {
    StartupMessageSignature startupMessageSignature = {"37b92a8534a39946aae833f08f287acb520bf3f7fe063c5038c07efb077969b5a2334e0124968f95435230bf99a37154b3b2d19fc7c979b73382ac3dedaf6eb3"};
    //bcbfce8d5b64aacefe0af8bffe873699a7f2156d28fec6498aad5160c38b5f6d
    
    NSString* signature = [NSString stringWithUTF8String:startupMessageSignature.signature];
    if([NS_SECURE_STRING(startup_message_replace_signature) isEqualToString:signature]) {
        
        if(durationMillisecond) {
            *durationMillisecond = startupMessageSignature.durationMillisec;
        }
        
        if(delayMillisecond) {
            *delayMillisecond = startupMessageSignature.delayMillisec;
        }
        return true;
    }
    return false;
}

@interface AGStartUpMessage()
@end


@implementation UIView (Welcome)
- (void)showToastMessage:(NSString *)message duration:(NSTimeInterval)duration {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.numberOfLines = 0.0;
    label.alpha = 0.0;
    label.clipsToBounds = YES;
   
    CGFloat maxWidth = self.bounds.size.width * 0.8;
    CGSize textSize = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    CGFloat width = MIN(textSize.width, maxWidth) + 20;
    CGFloat height = textSize.height + 20;
    label.layer.cornerRadius = height/2;
    
    label.frame = CGRectMake( (self.bounds.size.width - width) / 2, (self.bounds.size.height - height) - 80, width, height);

    [self addSubview:label];

    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:duration options:UIViewAnimationOptionCurveEaseIn animations:^{
           label.alpha = 0.0;
        } completion:^(BOOL finished) {
           [label removeFromSuperview];
        }];
    }];
}

@end

@implementation AGStartUpMessage

+ (BOOL)isActive {
    unsigned int durationMillisecond = 2000;
    unsigned int delayMillisecond = 1000;
    BOOL active = isActiveStartupMessage(&durationMillisecond, &delayMillisecond);
    durationMillisecond  = (double)durationMillisecond / 1000.0;
    delaySec = (double)delayMillisecond / 1000.0;
    return active;
}

+ (void)dummy {
    
}

+ (void)load {
    if([AGStartUpMessage isActive]) {
        AGLog(@"start up message is active : duration: %f delay:%f sec", durationSec, delaySec);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidFinishLaunching:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
}

+ (void)appDidFinishLaunching:(NSNotification *)notif {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView* topMostView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        if(topMostView) {
            [topMostView showToastMessage:NS_SECURE_STRING(secured_by_nhn_appguard) duration: durationSec];
        }
    });
}



@end
