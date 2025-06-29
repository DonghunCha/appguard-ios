//
//  AGAntiDumpManager.cpp
//  AppGuard
//
//  Created by NHN on 2023/06/14.
//

#import "AGAntiDumpManager.hpp"
#import <objc/runtime.h>
#import "Log.h"
#import "JailbreakManager.hpp"
#import "DetectManager.hpp"
#import "Util.h"

static IMP ORIGIN_FILE_EXISTS_AT_PATH_IMP;
static IMP ORIGIN_OPEN_URL_IMP;

__attribute__((visibility("hidden"))) static NSString* getQueryValueFromURLByKey(NSURL* url, NSString* key) {
    NSURLComponents *components = [NSURLComponents componentsWithString:[url absoluteString]];
    NSString* value = nil;
    if(components) {
        NSArray *items = [components queryItems];
        for (NSURLQueryItem* item in items) {
            if ([item.name isEqual:key]) {
                AGLog(@"key: %@ item.value = %@", item.name, item.value);
                value = item.value;
                break;
            }
        }
    }
    return value;
}

__attribute__((visibility("hidden"))) static int newFileExistsAtPathMethod(id self, SEL _cmd, NSString* path, BOOL* isDir) {
    if([[NSThread currentThread].name isEqual:NS_SECURE_STRING(gum_js_loop_thread_name)]) {
      
        DetectInfo* detectInfo = new DetectInfo(1802, AGPatternGroupDebugger, AGPatternNameIPADump, AGResponseTypeDetect, SECURE_STRING(frida_ios_dump));
        //block로그를 남기면 앱 자체가 차단되어 공격자가 알아챌 수 있으므로 탐지로그로 남기고 덤프만 차단함.
        STInstance(DetectManager)->addDetectInfo(detectInfo);
        
        AGLog(@"Detect frida-ios-dump %@ %@ EXIT!!", path, [NSThread currentThread].name);
        [NSThread exit];
        return 0;
    }
    return ((int(*)(id, SEL, NSString*, BOOL*))ORIGIN_FILE_EXISTS_AT_PATH_IMP)(self, _cmd, path, isDir);
}

__attribute__((visibility("hidden"))) static void newOpenURL(id self, SEL _cmd, NSURL *url, NSDictionary<UIApplicationOpenExternalURLOptionsKey, id>  *options, void (^completion)(BOOL success)) {
  
    if([[url absoluteString] containsString:NS_SECURE_STRING(crackerxi_url_scheme_data)]) {
        AGLog(@"Detect crackerxi %@",[url absoluteString]);
        
        DetectInfo* detectInfo = new DetectInfo(1803, AGPatternGroupDebugger, AGPatternNameIPADump, AGResponseTypeDetect, SECURE_STRING(crackerxi_url_scheme_data));
        //block로그를 남기면 앱 자체가 차단되어 공격자가 알아챌 수 있으므로 탐지로그로 남기고 덤프만 차단함.
        STInstance(DetectManager)->addDetectInfo(detectInfo);
        
        NSString* zipPath = getQueryValueFromURLByKey(url, NS_SECURE_STRING(url_scheme_query_key_data));
        if(zipPath) {
            if(Util::removeFile(zipPath)) {
                AGLog(@"The dumped app by crackerxi bfdecrypt is deleted....");
            } else {
                AGLog(@"Deleting the dumped app by crackerxi bfdecrypt is failed..");
            }
        }
        url = [NSURL URLWithString:@""];
      
    } else if ([[url absoluteString] containsString:NS_SECURE_STRING(igamegod_url_scheme_bfdecrypt_decryptedPath)]) {
        AGLog(@"Detect igamegod bfdecrypt %@",[url absoluteString]);
        
        DetectInfo* detectInfo = new DetectInfo(1803, AGPatternGroupDebugger, AGPatternNameIPADump, AGResponseTypeDetect, SECURE_STRING(igamegod_url_scheme_bfdecrypt_decryptedPath));
        STInstance(DetectManager)->addDetectInfo(detectInfo);
        
        NSString* decryptPath = getQueryValueFromURLByKey(url, NS_SECURE_STRING(url_scheme_query_key_decryptedPath));
        if(decryptPath) {
            if(Util::removeFile(decryptPath)) {
                AGLog(@"The dumped app folder by igamegod bfdecrypt is deleted..(%@)", decryptPath);
            } else {
                AGLog(@"Deleting the dumped app folder by igamegod bfdecrypt is failed..");
            }
        }
        
        url = [NSURL URLWithString:@""];
    }
    return ( (void(*)(id, SEL, NSURL*, NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *, void (^)(BOOL))) ORIGIN_OPEN_URL_IMP)(self, _cmd, url, options, completion);
}

__attribute__((visibility("hidden"))) AGAntiDumpManager::AGAntiDumpManager() {
    
}

__attribute__((visibility("hidden"))) AGAntiDumpManager::~AGAntiDumpManager() {
    
}


__attribute__((visibility("hidden"))) void AGAntiDumpManager::Initialize() {
    InitFridaIOSDumpDetection();
    InitBfdecryptDumpDetection();
}

__attribute__((visibility("hidden"))) BOOL AGAntiDumpManager::InitFridaIOSDumpDetection() {
    
    BOOL result = NO;
    
    //frida server가 존재하거나, MobileSubstrate라이브러리가 로드된 경우
    if(checkFridaServer() == YES ||
       checkMobileSubstrateDynamicLibLoaded() == YES) {
        AGLog(@"Active frida-ios-dump detection.");
        Method originalMethod = class_getInstanceMethod([NSFileManager class], @selector(fileExistsAtPath:isDirectory:));
        ORIGIN_FILE_EXISTS_AT_PATH_IMP = method_setImplementation(originalMethod, (IMP)newFileExistsAtPathMethod);
        result = (ORIGIN_FILE_EXISTS_AT_PATH_IMP != nil);
    } else {
        AGLog(@"Deactive frida-ios-dump detection.");
    }
    
    return result;
}

__attribute__((visibility("hidden"))) BOOL AGAntiDumpManager::InitBfdecryptDumpDetection() {
    BOOL result = NO;
    
    if(checkMobileSubstrateDynamicLibLoaded() == YES) { //crackerxihook.dylib가 로드됨.
        AGLog(@"Active BfdecryptDump(crackerXI+, iGameGod) detection.");
        Method originalOpenURL = class_getInstanceMethod([UIApplication class], @selector(openURL:options:completionHandler:));
        ORIGIN_OPEN_URL_IMP = method_setImplementation(originalOpenURL, (IMP)newOpenURL);
        result = (ORIGIN_OPEN_URL_IMP != nil);
    } else {
        AGLog(@"Deactive BfdecryptDump(crackerXI+, iGameGod) detection.");
    }
    
    return result;
}

__attribute__((visibility("hidden"))) BOOL AGAntiDumpManager::checkFridaServer() {
    return [[NSFileManager defaultManager] fileExistsAtPath: NS_SECURE_STRING(frida_server_bin_path)];
}


__attribute__((visibility("hidden"))) BOOL AGAntiDumpManager::checkMobileSubstrateDynamicLibLoaded() {
    return (BOOL)(STInstance(JailbreakManager)->checkDyld(SECURE_STRING(dynamic_libraries)));
}
