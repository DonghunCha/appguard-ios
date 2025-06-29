//
//  ResourceIntegrityManager.cpp
//  AppGuard
//
//  Created by NHN on 2023/05/02.
//

#include "AGResourceIntegrityManager.hpp"
#include "CommonAPI.hpp"
#include "Util.h"
#include "EncodedDatum.h"
#include <CommonCrypto/CommonDigest.h>


__attribute__((visibility("hidden"))) AGResourceIntegrityManager::AGResourceIntegrityManager() {
}

__attribute__((visibility("hidden"))) AGResourceIntegrityManager::~AGResourceIntegrityManager() {
}

__attribute__((visibility("hidden"))) bool AGResourceIntegrityManager::checkInfoPlist(NSString** infoPlistHashOriginalString) {
    
    if(!isValidSignature(infoPlistSignature)) {
        AGLog(@"Resource signature is not updated %s", (char*)infoPlistSignature.rawData);
        return false;
    }
    
    NSString* info = @"I";
    info = [info stringByAppendingString:@"n"];
    info = [info stringByAppendingString:@"f"];
    info = [info stringByAppendingString:@"o"];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:info ofType:@"plist"];
    if(!isFileExists(plistPath)) {
        AGLog(@"path: %@ is not exists", plistPath);
        return false;
    }
    
    *infoPlistHashOriginalString = getInfoPlistValueHashOriginalString(plistPath);
    if(*infoPlistHashOriginalString == nil) {
        return false;
    }
   
    NSString* InfoPlistHash = Util::sha256Hash(*infoPlistHashOriginalString);
    if(InfoPlistHash == nil) {
        return false;
    }
    
    return ![InfoPlistHash isEqual:C2NSString(infoPlistSignature.sha256Hash)]; // 무결성 검증 실패시 true
}

__attribute__((visibility("hidden"))) NSString* AGResourceIntegrityManager::getInfoPlistValueHashOriginalString(NSString* plistPath) {

    NSString* InfoPlistValues = @"";
    NSDictionary* infoPlistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if(infoPlistDictionary == nil) {
        AGLog(@"Can't read Info.plist (%@)", plistPath);
        return nil;
    }
    
    NSArray* keyArray = @[ NS_SECURE_STRING(plist_key_CFBundleExecutable),
                           NS_SECURE_STRING(plist_key_CFBundleIdentifier),
                           NS_SECURE_STRING(plist_key_CFBundleVersion),
                           NS_SECURE_STRING(plist_key_CFBundleShortVersionString),
    ];
    
    for(NSString* key in keyArray) {
        NSString* value = [infoPlistDictionary objectForKey: key];

        if(value == nil) {
            value = @"";
        }
        
        InfoPlistValues = [InfoPlistValues stringByAppendingFormat:@"%@|",value];
    }
    AGLog(@"Info.plist values: %@", InfoPlistValues);
    return InfoPlistValues;
}

__attribute__((visibility("hidden"))) bool AGResourceIntegrityManager::isValidSignature(const AGResourceIntegritySignature& signature) {
  
    if(STInstance(CommonAPI)->cStrlen(signature.updatedSignature) != AG_UPDATED_RESOURCE_SIGNATRUE_LEN) {
        return false;
    }
    
    if(STInstance(CommonAPI)->cStrlen(signature.sha256Hash) != AG_UPDATED_RESOURCE_SIGNATRUE_LEN) {
        return false;
    }
    
    char* updatedSignature = nullptr;
    
    if(signature.type == AGResourceTypeInfoPlist) {
        updatedSignature = SECURE_STRING(updated_infoplist_signature);
    } else {
        return false;
    }
    
    if(STInstance(CommonAPI)->cStrcmp(signature.updatedSignature, updatedSignature) != 0) {
        AGLog(@"Resource updatedSignature is not updated %s", signature.updatedSignature);
        return false;
    }
    
    return true;
}

__attribute__((visibility("hidden"))) bool AGResourceIntegrityManager::isFileExists(NSString* filePath) {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}
