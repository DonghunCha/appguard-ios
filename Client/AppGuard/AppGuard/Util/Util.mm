//
//  Util.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "Util.h"
#import <CommonCrypto/CommonDigest.h>
#include <memory>

__attribute__((visibility("hidden"))) const char* NS2CString(NSString* str)
{
    if(str == nil)
        return NULL;
    
    return [str UTF8String];
    
}

__attribute__((visibility("hidden"))) NSString* C2NSString(const char* str)
{
    if(str == NULL)
        return nil;
    
    NSString * converted = [NSString stringWithUTF8String:str];
    return converted;
}

__attribute__((visibility("hidden"))) bool Util::checkFileSymlink(const char* path)
{
    if(path == NULL)
        return false;
    
    bool result = false;
    struct stat s = {0,};
    if (lstat(path, &s) == 0)
    {
        if(s.st_mode & S_IFLNK)
        {
            AGLog(@"Find - [%s] [lstat]", path);
            result = true;
        }
    }
    return result;
}

__attribute__((visibility("hidden"))) bool Util::checkFileExist(const char* path)
{
    if(path == nullptr) {
        return false;
    }
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:C2NSString(path)]) {
        AGLog(@"Find - [%s] [fileExistsAtPath]", path);
        return true;
    }
    
    FILE *fp = fopen(path, "r");
    if(fp != NULL) {
        AGLog(@"Find - [%s] [fopen]", path);
        fclose(fp);
        return true;
    }
    
    DIR *dir = opendir(path);
    if(dir != NULL) {
        AGLog(@"Find - [%s] [open dir]", path);
        closedir(dir);
        dir = NULL;
        return true;
    }
    
    int fd = STInstance(SVCManager)->svcOpen(path);
    if(fd > 0) {
        AGLog(@"Find - [%s] [svc open]", path);
        close(fd);
        return true;
    }
    
    if(STInstance(SVCManager)->svcAccess(path) != false) {
        AGLog(@"Find - [%s] [svc access a]", path);
        return true;
    }
    
    if(STInstance(SVCManager)->svcLstat64(path) != false) {
        AGLog(@"Find - [%s] [svc lstat64]", path);
        return true;
    }
    
    if(STInstance(SVCManager)->svcStat64(path) != false) {
        AGLog(@"Find - [%s] [svc stat64]", path);
        return true;
    }
    
    if(STInstance(SVCManager)->svcStatfs64(path) != false) {
        AGLog(@"Find - [%s] [svc statfs64]", path);
        return true;
    }
    
    return false;
}

__attribute__((visibility("hidden"))) char* Util::checkDynamicLibrary(const char* dir, const char* pattern, const char* fileExt)
{
    char* result = NULL;
    if(dir == NULL) {
        return result;
    }
        
    DIR *dir_info = NULL;
    struct dirent *dir_entry;
    dir_info = opendir(dir);
    
    if(!dir_info) {
        return result;
    }
    
    while(true) {
        dir_entry = readdir(dir_info);
        if(!dir_entry) {
            break;
        }
        // open file and check for patterns
        const size_t filePathLen = STInstance(CommonAPI)->cStrlen(dir) + dir_entry->d_namlen + 2;
        std::unique_ptr<char[]> filePath(new char[filePathLen]);
        memset(filePath.get(), '\0', filePathLen);
        snprintf(filePath.get(), filePathLen, "%s/%s", dir, dir_entry->d_name);
        
        if(Util::checkFileExtension(filePath.get(), fileExt) && Util::checkFileForPattern(filePath.get(), pattern, fileExt)) {
        
            const size_t libPathLen = filePathLen + 10;
            std::unique_ptr<char[]> libPath(new char[libPathLen]);
            memset(libPath.get(), '\0', libPathLen);
    
            AGLog(@"Find - directory : [%s], pattern : [%s] file extension : [%s]", filePath.get(), pattern, fileExt);
            snprintf(libPath.get(), libPathLen, "%s%s", strtok(filePath.get(), "."), SECURE_STRING(_dylib));
            
            if(Util::checkFileExist(libPath.get())) {
                result = (char*)malloc(STInstance(CommonAPI)->cStrlen(libPath.get())+1); //dealloc은 어디서?
                STInstance(CommonAPI)->cStrcpy(result, libPath.get());
                AGLog(@"Library path - [%s]", result);
                break;
                
            } else {
                AGLog(@"Library path is not found. - [%s]", libPath.get());
            }
        }
    }
    
    if(dir_info != NULL) {
        closedir(dir_info);
        dir_info = NULL;
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool Util::checkDirForPattern(const char* dir, const char* pattern, const char* fileExt)
{
    bool result = false;
    
    if(dir == NULL)
        return result;
    
    DIR *dir_info = NULL;
    struct dirent *dir_entry;
    char filePath[100];
    
    dir_info = opendir(dir);
    if(!dir_info)
    {
        return result;
    }
    
    while(true)
    {
        dir_entry = readdir(dir_info);
        if(!dir_entry)
        {
            break;
        }
        // open file and check for patterns
        memset(filePath, 0, 100);
        snprintf(filePath, 100, "%s/%s",dir,dir_entry->d_name);
        if(Util::checkFileExtension(filePath, fileExt) && Util::checkFileForPattern(filePath, pattern, fileExt))
        {
            AGLog(@"Find - directory : [%s], pattern : [%s] file extension : [%s]", filePath, pattern, fileExt);
            result = true;
        }
    }
    if(dir_info != NULL) {
        closedir(dir_info);
        dir_info = NULL;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool Util::checkFileExtension(const char* fileName, const char* fileExt)
{
    bool result = false;
    if(fileName == NULL || fileExt == NULL)
        return result;

    if(STInstance(CommonAPI)->cStrstr(fileName, fileExt))
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool Util::checkFileForPattern(const char* filename, const char* pattern, const char* fileExt)
{
    bool result = false;
    if(STInstance(CommonAPI)->cStrlen(fileExt) > 0)
    {
        if(!STInstance(CommonAPI)->cStrstr(filename, fileExt))
        {
            return result;
        }
    }
    FILE* fp = fopen(filename, "r");
    char fbuf[512];

    if(!fp)
    {
        return result;
    }
    
    memset(fbuf,0,512);
    
    while(fgets(fbuf,512,fp) != NULL)
    {
        fbuf[511] = NULL;
        if(STInstance(CommonAPI)->cStrstr(fbuf, pattern))
        {
            result = true;
            break;
        }
    }
    return result;
}

// @author  : daejoon kim
// @return  : 디버그 모드 확인 결과
// @brief   : 디버그 모드인지 확인
__attribute__((visibility("hidden"))) bool Util::checkDebugMode()
{
    bool result = false;
#ifdef DEBUG
    result = true;
#endif
    return result;
}

// @author  : daejoon kim
// @return  : tmp 경로
// @brief   : tmp 경로를 전달
__attribute__((visibility("hidden"))) NSString* Util::getTmpPath()
{
    return NSTemporaryDirectory();
}

__attribute__((visibility("hidden"))) NSString* Util::getApplicationSupportPath()
{
    NSURL* url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    return [url path];
}

// @return  : 번들 경로
// @brief   : 번들 경로를 전달
__attribute__((visibility("hidden"))) NSString* Util::getBundlePath()
{
    return [[NSBundle mainBundle]bundlePath];
}

// @author  : daejoon kim
// @return  : 번들 이름
// @brief   : 번들 이름을 전달
__attribute__((visibility("hidden"))) NSString* Util::getBundleName()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

__attribute__((visibility("hidden"))) NSString* Util::getBundleID()
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

__attribute__((visibility("hidden"))) NSString* Util::getBundleExecutableFromInfoPlist()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
}

// @author  : daejoon kim
// @return  : 실행 파일 경로
// @brief   : 실행 파일 경로를 전달
__attribute__((visibility("hidden"))) NSString* Util::getExecuteFilePath()
{
    NSString * excuteFilePath = NULL;
    NSString * bundlePath = Util::getBundlePath(); // /var/containers/Bundle/Application/118A5322-71CE-4713-BD66-0DD46BFCBE78/AppGuard-iOS-Test.app
    NSString * executableName = Util::getBundleExecutableFromInfoPlist(); // AppGuard-iOS-Test
    if(bundlePath != NULL && executableName != NULL) // 번들 경로와 이름을 가져오지 못하면 pass
    {
        NSArray * contents = Util::getContentsOfDirectory(bundlePath); // 번들 경로의 파일 이름을 가져옴
        if(contents != NULL)
        {
            for(NSString * content in contents)
            {
                if([content hasPrefix:executableName]) // 파일중에 실행 파일을 찾음
                {
                    bundlePath = [bundlePath stringByAppendingString:@"/"];
                    excuteFilePath = [bundlePath stringByAppendingString:executableName]; // 번들 경로와 실행파일을 조합하여 실행 파일 경로 만듦
                    break;
                }
            }
        }
    }
    return excuteFilePath; // /var/containers/Bundle/Application/118A5322-71CE-4713-BD66-0DD46BFCBE78/AppGuard-iOS-Test.app/AppGuard-iOS-Test
}

// @author  : daejoon kim
// @return  : 경로의 파일 이름
// @brief   : 경로의 파일 이름을 전달
__attribute__((visibility("hidden"))) NSArray* Util::getContentsOfDirectory(NSString* path)
{
    return [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:NULL];
}

// @author  : daejoon kim
// @param   : 파일 경로
// @brief   : 파일 사이즈
__attribute__((visibility("hidden"))) size_t Util::getFileSizeByStat(const char* path)
{
    struct stat st = {0, };
    stat(path, &st);
    return (size_t)st.st_size;
}

// @author  : daejoon kim
// @return  : 파일 사이즈
// @brief   : 파일 사이즈를 전달
__attribute__((visibility("hidden"))) size_t Util::getFileSizeByFstat(int fd)
{
    struct stat st = {0, };
    fstat(fd, &st);
    return (size_t)st.st_size;
    
}

// @author  : daejoon kim
// @param   : 파일 경로
// @brief   : 파일 삭제의 정상 처리 유무
__attribute__((visibility("hidden"))) bool Util::removeFile(NSString* path)
{
    bool result = false;
    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if(error == nil)
    {
        AGLog(@"Remove File - [%@]", path);
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool Util::excludeiCloudBackupFile(NSString* filePath) {
    NSError *error = nil;
    NSURL* url = [NSURL fileURLWithPath:filePath];
    BOOL isSuccess = [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    if(isSuccess == NO) {
        AGLog(@"%@", error);
        return false;
    }
    return true;
}

// @author  : daejoon kim
// @param   : 파일 복사 시작 주소, 파일 복사 도착 주소
// @brief   : 파일 복사의 정상 처리 유무
__attribute__((visibility("hidden"))) bool Util::copyFile(NSString* srcPath, NSString* destPath)
{
    const char* srcPathC = NS2CString(srcPath);
    const char* dstPathC = NS2CString(destPath);
    
    FILE* srcFile =  fopen(srcPathC ,"rb");
    if(!srcFile)
    {
        AGLog(@"fail fopen src %s", srcPathC);
        return false;
    }
    
    FILE* dstFile = fopen(dstPathC, "wb");
    if(!dstFile)
    {
        AGLog(@"fail fopen dst %s", dstPathC);
        fclose(srcFile);
        return false;
    }
    
    size_t readBytes = 0;
    unsigned char buf[512] = {};
    memset(buf, 0x0, sizeof(buf));
    
    while(0 < ( readBytes = fread(buf, 1,sizeof(buf), srcFile)))
    {
        if(fwrite(buf, 1, readBytes, dstFile) == 0)
        {
            AGLog(@"fail fwrite %@", destPath);
            fclose(srcFile);
            fclose(dstFile);
            unlink(NS2CString(destPath));
            return false;
        }
        memset(buf, 0x0, sizeof(buf));
    }
    
    AGLog(@"success copy file %@ -> %@", srcPath, destPath);
    fclose(srcFile);
    fclose(dstFile);
    
    return true;
}

// @author  : daejoon kim
// @param   : 이미지 번호
// @brief   : 이미지 번호를 리턴
__attribute__((visibility("hidden"))) int Util::getImageNumber()
{
    //ios 16에서 Debug모드 Xcode Attach를 하면 Image Index 0이 현재 실행파일이 아닐 수 있음. Debug 모드에서는 해당함수로 Image Index를 가져오도록 해야함.
    int result = -1;
    const char * target = NS2CString(getExecuteFilePath());
    for(int i = 0; i < _dyld_image_count(); i++)
    {
        const char * imageName = (char*)_dyld_get_image_name(i);
        if(imageName == NULL || target == NULL)
            continue;
        if(STInstance(CommonAPI)->cStrcmp(imageName, target) == 0)
        {
            AGLog(@"Find image number - [%d]", i);
            result = i;
            break;
        }
    }

    return result;
}

// @author  : daejoon kim
// @param   : 앱스토어 빌드 유무 확인
// @brief   : 앱스토어 빌드 유무
__attribute__((visibility("hidden"))) bool Util::checkAppStoreBuild()
{
    bool result = false;
#ifdef DEBUG
    AGLog(@"Pass Debug Mode");
#elif TARGET_IPHONE_SIMULATOR
    AGLog(@"Pass Simulator");
#else
    AGLog(@"Check Store Build");
    NSString * bundlePath = Util::getBundlePath();
    if(bundlePath != NULL)
    {
        NSString* scInfoName = NS_SECURE_STRING(sc_info);
        bundlePath = [bundlePath stringByAppendingString:scInfoName];
        result = checkFileExist(NS2CString(bundlePath));
    }
#endif
    AGLog(@"Store build - [%d]", result);
    return result;
}

__attribute__((visibility("hidden"))) bool Util::checkNSStringLen(NSString* data)
{
    if(data == nil)
        return false;
    bool result = true;
    if([data length] == 0)
    {
        result = false;
    }
    return result;
}

#pragma mark - Version check

static __attribute__((visibility("hidden"))) NSComparisonResult compareVersion(NSString* currentVersion, NSString* targetVersion)
{
    NSArray<NSString *> *components = [currentVersion componentsSeparatedByString:@"."];
    NSArray<NSString *> *targetComponents = [targetVersion componentsSeparatedByString:@"."];
    NSInteger spareCount = components.count - targetComponents.count;
    
    if (spareCount == 0) {
        return [currentVersion compare:targetVersion options:NSNumericSearch];
    }
    
    NSString *current = [currentVersion copy];
    while ([current hasSuffix:@".0"]) {
        current = [current substringToIndex:current.length - @".0".length];
    }
    
    NSString *target = [targetVersion copy];
    while ([target hasSuffix:@".0"]) {
        target = [target substringToIndex:target.length - @".0".length];
    }
    
    return [current compare:target options:NSNumericSearch];
}

__attribute__((visibility("hidden"))) bool Util::isVersionEqualOrGreater(NSString* currentVersion, NSString* targetVersion)
{
    return (compareVersion(currentVersion, targetVersion) != NSOrderedAscending) == YES ? true : false;
}

__attribute__((visibility("hidden"))) bool Util::isVersionEqual(NSString* currentVersion, NSString* targetVersion)
{
    return (compareVersion(currentVersion, targetVersion) == NSOrderedSame) == YES ? true : false;
}

__attribute__((visibility("hidden"))) bool Util::isVersionGreater(NSString* currentVersion, NSString* targetVersion)
{
    return (compareVersion(currentVersion, targetVersion) == NSOrderedDescending) == YES ? true : false;
}

__attribute__((visibility("hidden"))) bool Util::isVersionLess(NSString* currentVersion, NSString* targetVersion)
{
    return (compareVersion(currentVersion, targetVersion) == NSOrderedAscending) == YES ? true : false;
}

__attribute__((visibility("hidden"))) bool Util::isVersionEqualOrLess(NSString* currentVersion, NSString* targetVersion)
{
    return (compareVersion(currentVersion, targetVersion) != NSOrderedDescending) == YES ? true : false;
}

__attribute__((visibility("hidden"))) NSString* Util::sha256Hash(NSString * strInput) {
    const char *str = [strInput UTF8String];
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)STInstance(CommonAPI)->cStrlen(str), hash);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (NSUInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", hash[i]];
    }
    return output;
}

__attribute__((visibility("hidden"))) NSData* Util::sha256HashDigest(NSString * strInput) {
    const char *str = [strInput UTF8String];
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)STInstance(CommonAPI)->cStrlen(str), hash);
    return [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
}

__attribute__((visibility("hidden"))) NSData* Util::sha256HashDigest(NSData * data) {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([data bytes], (CC_LONG)[data length], hash);
    return [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
}

__attribute__((visibility("hidden"))) int64_t Util::chronoTimePointToEpochMillisec(std::chrono::system_clock::time_point time) {
    auto epoch = std::chrono::duration_cast<std::chrono::milliseconds>(time.time_since_epoch());
    return epoch.count();
}


__attribute__((visibility("hidden"))) bool Util::getSegmentSectionSha256(int imageIndex, char* hashStringBuffer, size_t hashStringBufferLength, const char* segmentName, const char* sectionName) {
    
    if(imageIndex < 0) {
        AGLog(@"The image index must greater then 0.");
        return false;
    }
    
    constexpr size_t kMinimumHashStringBufferLength = CC_SHA256_DIGEST_LENGTH * 2 + 1;
    
    if( kMinimumHashStringBufferLength > hashStringBufferLength  ) {
        AGLog(@"The hashStringBufferLength must be at least greater than %lu.", kMinimumHashStringBufferLength);
        return false;
    }
    
    if( !hashStringBuffer ) {
        AGLog(@"The hashStringBuffer must be an allocated buffer.");
        return false;
    }
    
    
    struct mach_header_64 * header = (struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
        
    for(int i = 0; i < header->ncmds; i++) {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 ) {
            // 세그먼트를 찾기 위한 로직
            if(CommonAPI::cStrcmp(segment->segname, segmentName) == 0) {
                struct section_64 * section = (struct section_64 *)(segment +1);
                for(int j=0; j< segment->nsects; j++) {
                    // 섹션 이름으로 찾음.
                    if(CommonAPI::cStrcmp(section->sectname, sectionName) == 0) {
                        AGLog(@"Segment Name : %s", segment->segname);
                        AGLog(@"Section Name : %s", section->sectname);
                        AGLog(@"Section Size : %llu", section->size);
                        
                        uint64_t sectionSize = section->size;
                        uint8_t * sectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        
                        uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
                        CC_SHA256(sectionPtr, (CC_LONG)sectionSize, digest); // text 섹션의 sha256해싱

                        for (NSUInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
                            sprintf(hashStringBuffer + (2 * i), "%02x", digest[i]);
                        }

                        return true;
                    }
                    section = section + 1;
                }
            }
        }
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    
    
    return false;
}


__attribute__((visibility("hidden"))) int Util::getImageIndexByImagePath(NSString* imagePath) {
    
    int imageIndex = -1;
    const char* imagePathCString = [imagePath cStringUsingEncoding:NSUTF8StringEncoding];
    for(int i = 0; i < _dyld_image_count(); i++)
    {
        const char * imageName = (char*)_dyld_get_image_name(i);
        if( imageName == NULL ) {
            continue;
        }
        
        if(STInstance(CommonAPI)->cStrcmp(imageName, imagePathCString) == 0)
        {
            AGLog(@"Find image number - [%d] %s", i, imageName);
            imageIndex = i;
            break;
        }
    }

    return imageIndex;
}

__attribute__((visibility("hidden"))) NSString* Util::getFrameworkPath(NSString* frameworkName) {
    
    NSString* bundlePath = Util::getBundlePath();
    NSString* frameworkPath = [NSString stringWithFormat:@"%@/Frameworks/%@.framework", bundlePath, frameworkName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:frameworkPath]) {
        return nil;
    }
    return frameworkPath;
}
