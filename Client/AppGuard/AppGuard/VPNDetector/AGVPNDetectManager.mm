//
//  AGVPNDetectManager.m
//  AppGuard
//
//  Created by NHN on 10/29/24.
//

#import "AGVPNDetectManager.hpp"
#include "util.h"
AG_PRIVATE_API AGVPNDetectManager::AGVPNDetectManager() {
}

AG_PRIVATE_API AGVPNDetectManager::~AGVPNDetectManager() {
}


bool AG_PRIVATE_API AGVPNDetectManager::IsVPNNetwork(std::vector<NSString*>* vpnInterfaces) {
    CFDictionaryRef cfDict = CFNetworkCopySystemProxySettings();
    if (cfDict == NULL) {
        AGLog(@"Failed to get proxy settings");
        return false;
    }

    NSDictionary *nsDict = (__bridge NSDictionary *)cfDict;
    
    NSDictionary *scopedKeys = nsDict[@"__SCOPED__"];
    if (![scopedKeys isKindOfClass:[NSDictionary class]]) {
        AGLog(@"No __SCOPED__ key found in proxy settings.");
        return false;
    }
    
    bool isVPN = false;
    
    NSString* findKeys = NS_SECURE_STRING(string_vpn_interfaces);
    NSArray *findKeyArray = [findKeys componentsSeparatedByString:@"/"];
    
    for (NSString *key in [scopedKeys allKeys]) {
        for (NSString* findKey in findKeyArray) {
            if([key hasPrefix:findKey]) {
                AGLog(@"VPN is connected via %@", key);
                if(vpnInterfaces) {
                    vpnInterfaces->push_back(key);
                }
                isVPN = true;
                break;
            }
        }
    }
    
    CFRelease(cfDict);
    return isVPN;
}
