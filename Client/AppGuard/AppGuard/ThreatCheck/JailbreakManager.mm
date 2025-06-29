//
//  JailbreakManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#include "JailbreakManager.hpp"

// [테스트용 함수] 아이폰 device 이름을 "NHN_JB_TEST"으로 설정하는 경우, 탈옥탐지
// iOS 16이상 부터 사용할 수 없음.
__attribute__((visibility("hidden"))) bool JailbreakManager::detectTest()
{
    bool result = false;
    NSString* currentVersion = [UIDevice currentDevice].systemVersion;
    NSString* targetVersion = @"16";
    
    if(!Util::checkNSStringLen(currentVersion))
    {
        return result;
    }
    
    if(Util::isVersionEqualOrGreater(currentVersion, targetVersion))
    {
        AGLog(@"From ios %@ or later, jb test is not available.", targetVersion);
    }
    else
    {
        NSString * deviceName = [UIDevice currentDevice].name;
        result = [deviceName isEqualToString:NS_SECURE_STRING(NHN_JB_TEST)];
    }
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkSandbox()
{
    bool result = false;
    // iPhone 에뮬레이터에서 Sand Box가 탐지되어 예외처리
    if(!STInstance(SimulatorManager)->checkTarget())
    {
        if (checkFork())
        {
            AGLog(@"Found sandbox");
            result = true;
        }
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkFork()
{
    bool result = false;
    int forkResult = fork();
    if (!forkResult)
    {
        AGLog(@"Fork result : false");
        exit(0);
    }
    
    if (forkResult >= 0)
    {
        AGLog(@"Found fork");
        result = true;
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkDyld(const char* libName)
{
    bool result = false;
    if(checkDyldA(libName) != false)
    {
        result = true;
    }
    else
    {
        if(checkDyldB(libName) != false)
        {
            result = true;
        }
        else
        {
//            Crash issue in 14.2, iPhoneXS : https://nhnent.dooray.com/project/1636117176113101143/2878981410478774830
//            if(checkDyldC(libName) != false)
//            {
//                result = true;
//            }
        }
    }
    return result;
}
__attribute__((visibility("hidden"))) bool JailbreakManager::checkDyldA(const char* libName)
{
    bool result = false;
    
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++)
    {
        const char* dyld = _dyld_get_image_name(i);
        if(CommonAPI::cStrstr(dyld, libName))
        {
            AGLog(@"Find : [%s] -> [%s]", dyld, libName);
            result = true;
            break;
        }
    }
    return result;
}
__attribute__((visibility("hidden"))) bool JailbreakManager::checkDyldB(const char* libName)
{
    bool result = false;
    Dl_info dylibInfo;
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++)
    {
        dladdr(_dyld_get_image_header(i), &dylibInfo);
        if(CommonAPI::cStrstr(dylibInfo.dli_fname, libName))
        {
            AGLog(@"Find : [%s] -> [%s]", dylibInfo.dli_fname, libName);
            result = true;
            break;
        }
    }
    return result;
    
}
__attribute__((visibility("hidden"))) bool JailbreakManager::checkDyldC(const char* libName)
{
    bool result = false;
#if defined __arm64__ || defined __arm64e__
    integer_t task_info_out[TASK_DYLD_INFO_COUNT];
    mach_msg_type_number_t task_info_outCnt = TASK_DYLD_INFO_COUNT;
    if(task_info(mach_task_self_, TASK_DYLD_INFO, task_info_out, &task_info_outCnt) == KERN_SUCCESS)
    {
        struct task_dyld_info dyld_info = *(struct task_dyld_info*)(void*)(task_info_out);
        struct dyld_all_image_infos* infos = (struct dyld_all_image_infos *) dyld_info.all_image_info_addr;
        struct dyld_uuid_info* pUuid_info  = (struct dyld_uuid_info*) infos->uuidArray;

        for( int i = 0; i < infos->uuidArrayCount; i++, pUuid_info += 1)
        {
            const struct mach_header_64* mheader = (const struct mach_header_64*)pUuid_info->imageLoadAddress;
            if (mheader->filetype == MH_DYLIB)
            {
                if(mheader->magic == MH_MAGIC_64 && mheader->ncmds > 0)
                {
                    void *loadCmd = (void*)(mheader + 1);
                    struct segment_command_64 *sc = (struct segment_command_64 *)loadCmd;
                    for (int index = 0; index < mheader->ncmds; ++index, sc = (struct segment_command_64*)((BYTE*)sc + sc->cmdsize))
                    {
                        if (sc->cmd == LC_ID_DYLIB)
                        {
                            struct dylib_command *dc = (struct dylib_command *)sc;
                            struct dylib dy = dc->dylib;
                            const char *dyldName = (char*)dc + dy.name.offset;
                            if(CommonAPI::cStrstr(dyldName, libName))
                            {
                                AGLog(@"Find : [%s] -> [%s]", dyldName, libName);
                                result = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
#else
    // pass
#endif
    return result;
}

// 탐지는 가능하나 아래와 같은 에러가 발생하여 사용할 수 없음 (개발자가 plist 수정이 필요)
// -canOpenURL: failed for URL: "cydia://" - error: "This app is not allowed to query for scheme cydia"
__attribute__((visibility("hidden"))) bool JailbreakManager::checkCydiaUrl()
{
    bool result = false;
    
    NSString* cydiaUrl = NS_SECURE_STRING(cydia_url);
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:cydiaUrl]])
    {
        AGLog(@"Found cydia url");
        result = true;
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkDirectoryPermission()
{
    bool result = false;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* tempFileName = NS_SECURE_STRING(temp_ag_file);
    NSError* error = nil;
    NSString* string = @".";
    
    [string writeToFile:tempFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error)
    {
        AGLog(@"Create temp file");
        [fileManager removeItemAtPath:tempFileName error:nil];
        result = true;
    }
    else
    {
        AGLog(@"Not Create temp file");
    }
    
    return result;
}


__attribute__((visibility("hidden"))) bool JailbreakManager::checkInsertLib(const char* libName)
{
    bool result = false;
    
    const char* insertLibraries = getenv(SECURE_STRING(DYLD_INSERT_LIBRARIES));
    if(insertLibraries != NULL)
    {
        if(CommonAPI::cStrstr(insertLibraries, libName))
        {
            AGLog(@"Find : [%s] -> [%s]", insertLibraries, libName);
            result = true;
        }
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkClass(const char* className)
{
    bool result = false;
    if(NSClassFromString(C2NSString(className)))
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkInject(const char* functionName)
{
    bool result = false;
    void* dlpoint = dlsym((void*)RTLD_DEFAULT, functionName);
    if(dlpoint != 0x0)
    {
        result = true;
    }
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkABypass()
{
    bool result = false;
    if(checkClass(SECURE_STRING(AQPattern)) != false)
    {
        result = true;
    }
    if(checkInject(SECURE_STRING(_Z12hookingSVC80v)) != false)
    {
        result = true;
    }
    if(checkDyld(SECURE_STRING(ABLicense)) != false)
    {
        result = true;
    }
    if(Util::checkFileExist(SECURE_STRING(ABypass_dylib)))
    {
        result = true;
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkEnv(const char* envString)
{
    bool result = false;
    if(checkEnvA(envString) != false)
    {
        result = true;
    }
    else
    {
        if(checkEnvB(envString) != false)
        {
            result = true;
        }
    }
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkEnvA(const char* envString)
{
    bool result = false;
    char ***envp = _NSGetEnviron();
    if (envp)
    {
        char **env = *envp;
        while(*env)
        {
            if(CommonAPI::cStrstr(*env, envString))
            {
                AGLog(@"Find : [%s]", *env);
                result = true;
                break;
            }
            env++;
        }
    }
    return result;
}

__attribute__((visibility("hidden"))) bool JailbreakManager::checkEnvB(const char* envString)
{
    bool result = false;
    extern char **environ;
    for(int i = 0; environ[i]; i++)
    {
        if(CommonAPI::cStrstr(environ[i], envString))
        {
            AGLog(@"Find : [%s]", environ[i]);
            result = true;
            break;
        }
    }
    return result;
}
