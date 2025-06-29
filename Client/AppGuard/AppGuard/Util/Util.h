//
//  Util.hpp
//  appguard-ios
//

//  Created by NHNENT on 2016. 6. 2..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef Util_h
#define Util_h

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>
#include "Log.h"
#include "ASString.h"
#include "CommonAPI.hpp"
#include "Singleton.hpp"
#include "SVCManager.hpp"
#include "EncodedDatum.h"
#include <chrono>

#define SAFE_RELEASE_ARRAY(p) { if(p != nullptr){ delete[] p; p = nullptr;}}
#define SAFE_RELEASE(p) { if(p != nullptr){ delete p; p = nullptr;}}
#define SAFE_DESTORY(type, p) { if(p != nullptr){ CST<type>::Destroy(); p = nullptr;}}

const char* NS2CString(NSString*);
NSString* C2NSString(const char*);

class __attribute__((visibility("hidden"))) Util
{
public:
    static bool checkFileExist(const char* path);
    static bool checkFileSymlink(const char* path);
    static bool checkDirForPattern(const char* dir, const char* pattern, const char* fileExt);
    static bool checkFileForPattern(const char* filename, const char* pattern, const char* fileExt);
    static bool checkFileExtension(const char* fileName, const char* fileExt);
    static bool checkDebugMode();
    static bool checkAppStoreBuild();
    static char* checkDynamicLibrary(const char* dir, const char* pattern, const char* fileExt);
    
    static NSString* getTmpPath();
    static NSString* getApplicationSupportPath();
    static NSString* getBundlePath();
    static NSString* getBundleName();
    static NSString* getBundleID();
    static NSString* getExecuteFilePath();
    static NSString* getBundleExecutableFromInfoPlist();
    static NSArray* getContentsOfDirectory(NSString* path);
    static NSString* getFrameworkPath(NSString* frameworkName);
    static size_t getFileSizeByStat(const char* path);
    static size_t getFileSizeByFstat(int fd);
    
    static bool removeFile(NSString* path);
    static bool copyFile(NSString* srcPath, NSString* destPath);
    static bool excludeiCloudBackupFile(NSString* filePath);
    static int getImageNumber();
    
    static bool checkNSStringLen(NSString* data);
    
    static bool isVersionEqualOrGreater(NSString* currentVersion, NSString* targetVersion);
    static bool isVersionEqual(NSString* currentVersion, NSString* targetVersion);
    static bool isVersionGreater(NSString* currentVersion, NSString* targetVersion);
    static bool isVersionLess(NSString* currentVersion, NSString* targetVersion);
    static bool isVersionEqualOrLess(NSString* currentVersion, NSString* targetVersion);
    static NSString* sha256Hash(NSString * strInput);
    static NSData* sha256HashDigest(NSData * data);
    static NSData* sha256HashDigest(NSString * strInput);
    static int64_t chronoTimePointToEpochMillisec(std::chrono::system_clock::time_point time);
    
    static bool getSegmentSectionSha256(int imageIndex, char* hashStringBuffer, size_t hashStringBufferLength, const char* segmentName, const char* sectionName);
    static int getImageIndexByImagePath(NSString* imagePath);
};

#endif /* Util_h */
