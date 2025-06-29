//
//  AGLocationMon.m
//  AppGuard
//
//  Created by NHN on 4/22/24.
//

// CLCoreLocation.framework를 import 하지 않는 앱에서도 빌드 가능하도록 reflection 구현
#import "AGAntiLocationSpoofManager.hpp"
#import "AGLocationMon.h"
#include "util.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLLocationManager;
@class CLLocation;

NS_ENUM(int, AGLocationAuthorizationStatus) {
    AGLocationAuthorizationStatusAuthorizedAlways = 3,
    AGLocationAuthorizationStatusAuthorizedWhenInUse = 4
};




@interface AGLocationMon()
@property (strong, nonatomic) id locationMonManager;

@end


@implementation AGLocationMon

+ (instancetype)shared {
    static AGLocationMon *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[AGLocationMon alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization
        BOOL isUsing = [self usingCoreLocation];
        AGLog(@"Using Core Location: %@", isUsing ? @"USING" : @"NOT USING");
        
        if (isUsing) {
            self.locationMonManager = [[NSClassFromString(NS_SECURE_STRING(class_name_locationmanager)) alloc] init];
            [self.locationMonManager performSelector:@selector(setDelegate:) withObject:self];
        }
    }
    return self;
}

- (BOOL)usingCoreLocation {
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *locationWhenInUseUsageDescription = [info objectForKey:NS_SECURE_STRING(plist_key_nslocation_when_in_use_usage_desc)];
    NSString *locationAlwaysUsageDescription = [info objectForKey:NS_SECURE_STRING(plist_key_nslocation_always_usage_desc)];
    NSString *locationAlwaysAndWhenInUseUsageDescription = [info objectForKey:NS_SECURE_STRING(plist_key_nslocation_always_and_when_in_use_usage_desc)];
   
    if (locationWhenInUseUsageDescription != nil || locationAlwaysUsageDescription != nil || locationAlwaysAndWhenInUseUsageDescription != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)locationManagerDidChangeAuthorization:(id)manager {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"14.0")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        int status = [AGLocationMon returnIntInvokeWithTarget:manager selector:@selector(authorizationStatus)];

        AGLog(@"locationManagerDidChangeAuthorization: %d", status);
        if (status == AGLocationAuthorizationStatusAuthorizedAlways || status == AGLocationAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationMonManager performSelector:@selector(startUpdatingLocation)];
            AGLog(@"locationManagerDidChangeAuthorization kCLAuthorizationStatusAuthorizedAlways || kCLAuthorizationStatusAuthorizedWhenInUse : %d", status);
        }
#pragma clang diagnostic pop
    }
}

- (void)locationManager:(id)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    AGLog(@"didUpdateLocations: %@", locations);
    STInstance(AGAntiLocationSpoofManager)->DidUpdateLocations(locations);
}

// Invoke Utils.....
+ (int)returnIntInvokeWithTarget:(id)target selector:(SEL)selector {
    
    int result = -999;
    
    if ([target respondsToSelector:selector]) {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:target];
        [invocation setSelector:selector];
        [invocation retainArguments];
        [invocation invoke];
        [invocation getReturnValue:&result];
        
    }
    
    return result;
}


+ (BOOL)returnBoolInvokeWithTarget:(id)target selector:(SEL)selector {
    
    BOOL result = NO;
    
    if ([target respondsToSelector:selector]) {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:target];
        [invocation setSelector:selector];
        [invocation retainArguments];
        [invocation invoke];
        [invocation getReturnValue:&result];
        
    }
    
    return result;
}


+ (double)returnDoubleInvokeWithTarget:(id)target selector:(SEL)selector {
    
    double result = -999;
    
    if ([target respondsToSelector:selector]) {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:target];
        [invocation setSelector:selector];
        [invocation retainArguments];
        [invocation invoke];
        [invocation getReturnValue:&result];
    }
    
    return result;
}


+ (Coordinate)returnCoordinateInvokeWithTarget:(id)target selector:(SEL)selector {
    
    Coordinate result = {-999, -999};
    
    if ([target respondsToSelector:selector]) {
        NSMethodSignature *signature = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setTarget:target];
        [invocation setSelector:selector];
        [invocation retainArguments];
        [invocation invoke];
        [invocation getReturnValue:&result];
    }
    
    return result;
}

@end
