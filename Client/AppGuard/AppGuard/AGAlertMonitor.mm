//
//  AGAlertMonitor.cpp
//  AppGuard
//
//  Created by HyupM1 on 2023/12/04.
//

#include "AGAlertMonitor.h"
#import "ExitManager.hpp"

__attribute__((visibility("hidden"))) AGAlertMonitor::AGAlertMonitor()
:showAlert_(false), group_(AGPatternGroupNone), pattern_(AGPatternNameNone) {
}

__attribute__((visibility("hidden"))) AGAlertMonitor::~AGAlertMonitor() {
    group_ = AGPatternGroupNone;
    pattern_ = AGPatternNameNone;
    showAlert_ = false;
}

__attribute__((visibility("hidden"))) void AGAlertMonitor::start() {
    startDetectedPatternDataMonitor();
}

__attribute__((visibility("hidden"))) void AGAlertMonitor::setData(AGPatternGroup group, AGPatternName pattern) {
    if(showAlert_ == false) {
        group_ = group;
        pattern_ = pattern;
        
        STInstance(AGAlert)->setData(group_, pattern_);
        AGLog(@"Alert set detectCode code : [%d] [%d]", group, pattern);
    }
}

__attribute__((visibility("hidden"))) void AGAlertMonitor::startDetectedPatternDataMonitor() {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperationQueue *monitorQueue = [[NSOperationQueue alloc] init];
        [monitorQueue addOperationWithBlock:^{
            while (!showAlert_) {
                if (group_ != AGPatternGroupNone && pattern_ != AGPatternNameNone) {
                    AGLog(@"Show Alert %d %d", group_, pattern_);
                    showAlert_ = true;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        AGNotice *alert = [[AGNotice alloc] init];
                        
                        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                        while(vc.presentedViewController)
                        {
                            vc = vc.presentedViewController;
                        }
                        [vc presentViewController:alert animated:NO completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    #if defined __arm64__ || defined __arm64e__
                                __asm __volatile("mov x0, #0");
                                __asm __volatile("mul x0, x0, x0");
                                __asm __volatile("mov w1, #0");
                                __asm __volatile("mov w2, #1");
                                __asm __volatile("add w3, w2, w1");
                                __asm __volatile("mov w16, w3");
                                __asm __volatile("svc #0x80");
    #endif
                                STInstance(ExitManager)->callExit(); // 종료
                                makeCrash();
                            });
                        }];
                        
                        group_ = AGPatternGroupNone;
                        pattern_ = AGPatternNameNone;                 
                    });
                }
                STInstance(CommonAPI)->stdSleepFor(1);
            }
        }];
    });
    
    
}
