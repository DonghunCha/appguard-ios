//
//  DeviceInfoCollector.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 26..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "DeviceInfoCollector.h"
#include "Log.h"
#include "Util.h"
#include "AGKeychainItemWrapper.h"
#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/machine.h>
#include <sys/utsname.h>

__attribute__((visibility("hidden"))) int DeviceInfoCollector::Collect(std::string c) {
    
//    UIDevice* device = [UIDevice currentDevice];
//    NSString* name = [device systemName];
//    name = [device systemVersion];
    return 0;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getUuid()
{
    std::string result = "N/A";
    @try{
        // Keychain에 저장된 UUID값 사용, 없는 경우 생성해서 Keychain에 추가 - 참고 : http://reysion.tistory.com/55
        // initialize keychaing item for saving UUID.
        AGKeychainItemWrapper *wrapper = [[AGKeychainItemWrapper alloc] initWithIdentifier:@"AG_UUID" accessGroup:nil];
        if (wrapper != nil)
        {
            NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
            if( uuid == nil || uuid.length == 0)
            {
                // if there is not UUID in keychain, make UUID and save it.
                CFUUIDRef uuidRef = CFUUIDCreate(NULL);
                CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
                CFRelease(uuidRef);
                uuid = [NSString stringWithString:(__bridge NSString *) uuidStringRef];
                CFRelease(uuidStringRef);
                
                // save UUID in keychain
                [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
            }
            result = NS2CString(uuid);
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getOs()
{
    std::string result = "N/A";
    @try{
       UIDevice* device = [UIDevice currentDevice];
        if(device != nil)
        {
            NSString* name = [device systemName];
            NSString* version = [device systemVersion];
            if(Util::checkNSStringLen(name) && Util::checkNSStringLen(version))
            {
                NSString* os = [name stringByAppendingString:version];
                if(Util::checkNSStringLen(os))
                {
                    result = NS2CString(os);
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getDeviceInfo()
{
    std::string result = "N/A";
    @try{
        std::string machine = "";
        struct utsname u = {0,};
        UIDevice* device = nullptr;
        
        if (uname(&u) == 0 && strcmp(u.machine, "") != 0)
        {
            machine = u.machine;
            return machine;
        }
        else
        {
            device = [UIDevice currentDevice];
            if(device != nil)
            {
                NSString* deviceModel = device.model;
                if(Util::checkNSStringLen(deviceModel))
                {
                    result = NS2CString(deviceModel);
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getDeviceId()
{
    std::string result = "N/A";
    @try{
        UIDevice* device = [UIDevice currentDevice];
        if(device != nil)
        {
            NSString* deviceId = [device.identifierForVendor UUIDString];
            if(Util::checkNSStringLen(deviceId))
            {
                result = NS2CString(deviceId);
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getCpuArch()
{
    std::string result = "N/A";
    @try{
        NSMutableString *cpu = [[NSMutableString alloc] init];
        if(cpu != nil)
        {
            size_t size;
            cpu_type_t type;
            cpu_subtype_t subtype;

            size = sizeof(type);
            sysctlbyname("hw.cputype", &type, &size, NULL,0);
            size = sizeof(subtype);
            sysctlbyname("hw.cpusubtype", &subtype, &size, NULL,0);
            
            if (type == CPU_TYPE_ARM)
            {
                [cpu appendString:@"ARM"];
            }
            else if (type == CPU_TYPE_ARM64)
            {
                [cpu appendString:@"ARM64"];
            }
            else if (type == CPU_TYPE_X86)
            {
                [cpu appendString:@"x86"];
            }
            else if (type == CPU_TYPE_X86_64)
            {
                [cpu appendString:@"x86_64"];
            }
            else if (type == CPU_TYPE_VAX)
            {
                [cpu appendString:@"VAX"];
            }
            else if (type == CPU_TYPE_HPPA)
            {
                [cpu appendString:@"HPPA"];
            }
            else if (type == CPU_TYPE_I386)
            {
                [cpu appendString:@"I386"];
            }
            else
            {
                [cpu appendString:@"etc"];
            }
            result = NS2CString(cpu);
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getKernelVersion()
{
    std::string result = "N/A";
    @try{
        char buf[100];
        size_t buflen = 100;
        buf[99]=0;
        
        sysctlbyname("kern.osrelease", &buf, &buflen, NULL,0);
        buf[99]=0;
        std::string str(buf);
        result = str;
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getPackageInfo()
{
    std::string result = "N/A";
    @try{
        NSBundle *bundle = [NSBundle mainBundle];
        if(bundle != nil)
        {
            NSDictionary *info = [bundle infoDictionary];
            if(info != nil)
            {
                NSString *prodName = [info objectForKey:@"CFBundleIdentifier"];
                if(Util::checkNSStringLen(prodName))
                {
                    result = NS2CString(prodName);
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getLanguage()
{
    std::string result = "N/A";
    @try{
        NSString* language = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        if(Util::checkNSStringLen(language))
        {
            result = NS2CString(language);
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getCountry()
{
    std::string result = "N/A";
    @try{
        NSString* country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        if(Util::checkNSStringLen(country))
        {
            result = NS2CString(country);
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) std::string DeviceInfoCollector::getCollectionTime()
{
    std::string result = "N/A"; // ex) "2017-07-27 15:47:28"
    @try{
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        if (dateFormat != nil)
        {
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString* date = [dateFormat stringFromDate:[NSDate date]];
            if(Util::checkNSStringLen(date))
            {
                result = NS2CString(date);
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}
