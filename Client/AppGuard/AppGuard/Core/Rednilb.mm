//
//  DiresuPlus.m
//  AppGuard
//
//  Created by NHN on 9/13/24.
//

#import "Rednilb.h"
#import "Singleton.hpp"
#import "EnvironmentManager.hpp"
#import "AGContentProtectorManager.hpp"

#import <Foundation/Foundation.h>
@interface AppGuardCoreBlinder () {
    
}
@end

@implementation AppGuardCoreBlinder
+ (BOOL)checkApiKey {
    return (STInstance(EnvironmentManager)->getApiKey().length() == 0 || 
            STInstance(EnvironmentManager)->getApiKey().compare("unknown") == 0);
}

+ (void)protectContent:(BOOL)active {
    if([AppGuardCoreBlinder checkApiKey])
    {
        return;
    }
    STInstance(AGContentProtectorManager)->SetProtectContent(active == YES ? true : false);
}

+ (void)protectSnapshot:(BOOL)active {
    if([AppGuardCoreBlinder checkApiKey])
    {
        return;
    }
    STInstance(AGContentProtectorManager)->SetProtectSnapshot(active == YES ? true : false);
}

#ifdef DEBUG
+ (void)detectScreenshot:(BOOL)active {
    if([AppGuardCoreBlinder checkApiKey])
    {
        return;
    }
    
    STInstance(AGContentProtectorManager)->SetDetectScreenshot(active == YES ? true : false);
}

+ (void)detectScreenRecord:(BOOL)active {
    if([AppGuardCoreBlinder checkApiKey])
    {
        return;
    }
    STInstance(AGContentProtectorManager)->SetDetectScreenRecord(active == YES ? true : false);
}
#endif


@end
