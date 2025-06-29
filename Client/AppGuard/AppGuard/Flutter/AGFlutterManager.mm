//
//  AGFlutterManager.cpp
//  AppGuard
//
//  Created by NHN on 3/19/24.
//


#include "AGFlutterManager.hpp"
#include "Log.h"
#include "Util.h"

__attribute__((visibility("hidden"))) AGFlutterSignature AGFlutterManager::flutterSignature_;


__attribute__((visibility("hidden")))
static int GetFrameworkImageIndex(NSString* frameworkName) {
    NSString* frameworkPath = Util::getFrameworkPath(frameworkName);
    if( frameworkPath == nil ) {
        AGLog(@"framework path is invalid");
        return -1;
    }
    NSString* excutablePath = [NSString stringWithFormat:@"%@/%@", frameworkPath, frameworkName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:excutablePath]) {
        return -1;
    }
    
    return Util::getImageIndexByImagePath(excutablePath);
}

__attribute__((visibility("hidden"))) 
AGFlutterManager::AGFlutterManager() {
    AGFlutterManager::flutterSignature_ = {"6dcd125524a20ddfdc3f1deee9d7985dd14458dec5e0e58be4dddfa5c5779f7f"};
}
__attribute__((visibility("hidden"))) 
AGFlutterManager::~AGFlutterManager() {
    
}


__attribute__((visibility("hidden"))) 
bool AGFlutterManager::CheckAppFrameworkIntegrity() {
    
    if(AGFlutterManager::IsFlutterProtection() == false) {
       return true;
    }
    
    NSString* frameworkName = @"App"; // SECURE string은 4자이상이라 그대로 사용함.
    
    int imageIndex = GetFrameworkImageIndex(frameworkName);
    if(imageIndex == -1) {
        AGLog(@"%@ is not found. ", frameworkName);
        return true;
    }

    char textSectionHash[kMinimumSha256HashStringBufferLength] = {'\0', };
    
    if(Util::getSegmentSectionSha256(imageIndex, textSectionHash, kMinimumSha256HashStringBufferLength, SECURE_STRING(text_segment), SECURE_STRING(__text)) == false) {
        AGLog(@"%@ hash is fail. ", frameworkName);
        return true;
    }
    AGLog(@"App.framework __TEXT.__text hash is %s ", textSectionHash);
    
    if(CommonAPI::cStrcmp( AGFlutterManager::flutterSignature_.appFrameworkTextSectionHash, textSectionHash) != 0) {
        AGLog(@"App.framework __TEXT.__text hash is invalid %s =! %s ",  AGFlutterManager::flutterSignature_.appFrameworkTextSectionHash, textSectionHash);
        return false;
    }
    
    char constSectionHash[kMinimumSha256HashStringBufferLength] = {'\0', };
    
    if(Util::getSegmentSectionSha256(imageIndex, constSectionHash, kMinimumSha256HashStringBufferLength,  SECURE_STRING(text_segment), SECURE_STRING(section_name_const)) == false) {
        AGLog(@"%@ hash is fail. ", frameworkName);
        return true;
    }
    AGLog(@"App.framework __TEXT.__const hash is %s ", constSectionHash);
    
    if(CommonAPI::cStrcmp( AGFlutterManager::flutterSignature_.appFrameworkConstSectionHash, constSectionHash) != 0) {
        AGLog(@"App.framework __TEXT.__const hash is invalid %s =! %s ",  AGFlutterManager::flutterSignature_.appFrameworkConstSectionHash, constSectionHash);
        return false;
    }

    return true;
}



__attribute__((visibility("hidden"))) 
bool AGFlutterManager::CheckFlutterFrameworkIntegrity() {
    
    if(AGFlutterManager::IsFlutterProtection() == false) {
        return true;
    }

    NSString* frameworkName = C2NSString(SECURE_STRING(string_Flutter));
    int imageIndex = GetFrameworkImageIndex(frameworkName);
    if(imageIndex == -1) {
        AGLog(@"%@ is not found. ", frameworkName);
        return true;
    }

    char textSectionHash[kMinimumSha256HashStringBufferLength] = {'\0', };
    
    if(Util::getSegmentSectionSha256(imageIndex, textSectionHash, kMinimumSha256HashStringBufferLength, SECURE_STRING(text_segment), SECURE_STRING(__text)) == false) {
        AGLog(@"%@ hash is fail. ", frameworkName);
        return true;
    }
    AGLog(@"Flutter.framework __TEXT.__text hash is %s ", textSectionHash);
    
    if(CommonAPI::cStrcmp( AGFlutterManager::flutterSignature_.flutterFrameworkTextSectionHash, textSectionHash) != 0) {
        AGLog(@"Flutter.framework __TEXT.__text hash is invalid %s=! %s ",  AGFlutterManager::flutterSignature_.flutterFrameworkTextSectionHash, textSectionHash);
        return false;
    }
    
    return true;
}

__attribute__((visibility("hidden"))) bool AGFlutterManager::IsFlutterProtection() {
   // return true;
   AGLog(@"IsFlutterProtection %d",(AGFlutterManager::flutterSignature_.magic == kAGFlutterProtectionMagic) );
   return (AGFlutterManager::flutterSignature_.magic == kAGFlutterProtectionMagic);
}
