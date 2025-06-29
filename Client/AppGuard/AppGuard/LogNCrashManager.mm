//
//  AGLog.mm
//  AppGuard
//
//  Created by NHNENT on 2017. 6. 14..
//  Copyright © 2017년 NHNENT. All rights reserved.
//

#import "LogNCrashManager.h"

@interface LogNCrashManager () {
    
}
@end

@implementation LogNCrashManager

static NSURL *url_;
static NSString* appKey_;
static NSString* appguardVersion_;
static NSString* userId_;

static NSMutableDictionary *data_;
static NSData *jsonData_;

+ (void)initialize {
    if (self == [LogNCrashManager class]) {
        data_ = [[NSMutableDictionary alloc] init];
    }
}

+ (void) init:(NSString *)server ofAppKey:(NSString*)appKey withVersion:(NSString*)appVersion forUserId:(NSString*)userId
{
    @try{
        url_ = [NSURL URLWithString:[NSString stringWithFormat:@"%@/v2/log", server]];
        appKey_ = appKey;
        appguardVersion_ = appVersion;
        userId_ = userId;
        AGLog(@"URL : [%@] AppKey : [%@] AppGuard Version : [%@] User ID : [%@]", url_, appKey_, appguardVersion_, userId_);
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

+ (void) setUserId:(NSString *)userId {
    userId_ = userId;
}

+ (void) sendLog:(NSString*)body
{
    @try{
        if(!STInstance(LogNCrash)->checkSetUp())
        {
            STInstance(LogNCrash)->setUp();
        }
        [self setDefaultFields];
        [data_ setObject:body forKey:@"body"];
        jsonData_ = [NSJSONSerialization dataWithJSONObject:data_ options:NSJSONWritingPrettyPrinted error:NULL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url_];
        AGLog(@"Log Data : %@", [[NSString alloc] initWithData:jsonData_ encoding:NSUTF8StringEncoding]);
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData_];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)[jsonData_ length]] forHTTPHeaderField:@"Content-Length"];
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue: nil];
        NSURLSessionDataTask *currentTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil) // request 에러 확인
            {
                NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*) response;
                if(httpResponse != nil)
                {
                    NSInteger stCode = [httpResponse statusCode];
                    AGLog(@"Status Code - [%ld]", stCode);
                    if(stCode == 200)
                    {
                        AGLog(@"Success Netwoking...");
                        AGLog(@"Data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    }
                }
            }
            else
            {
                AGLog(@"Fail Netwoking...");
            }
        }];
        [currentTask resume];
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

+ (void) setCustomField:(NSString*)value forKey:(NSString*)key
{
    @try{
        [data_ setObject:value forKey:key];
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

+ (void) setDefaultFields
{
    @try{
        [data_ setObject:appKey_ forKey:@"projectName"];
        [data_ setObject:appguardVersion_ forKey:@"projectVersion"];
        [data_ setObject:userId_ forKey:@"UserID"];
        [data_ setObject:@"iOS" forKey:@"Platform"];
        [data_ setObject:@"v2" forKey:@"logVersion"];
        [data_ setObject:@"iOS_http" forKey:@"logSource"];
        [data_ setObject:@"iOS" forKey:@"logType"];
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

+ (void) removeAllCustomFields
{
    @try{
        [data_ removeAllObjects];
    }
    @catch(NSException *exception){
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}
@end
