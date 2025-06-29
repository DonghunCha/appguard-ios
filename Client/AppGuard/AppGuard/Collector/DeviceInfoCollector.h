//
//  DeviceInfoCollector.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 26..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef DeviceInfoCollector_hpp
#define DeviceInfoCollector_hpp

#include <stdio.h>
#include "ICollector.hpp"
#include <UIKit/UIKit.h>
#include <CoreFoundation/CoreFoundation.h>
#include <string>


class __attribute__((visibility("hidden"))) DeviceInfoCollector : public ICollector {
public:
    int Collect(std::string c);
    std::string getDeviceId();
    std::string getDeviceInfo();
    std::string getUuid();
    std::string getOs();
    std::string getCpuArch();
    std::string getPackageInfo();
    std::string getLanguage();
    std::string getKernelVersion();
    std::string getCollectionTime();
    std::string getCountry();
};

#endif /* DeviceInfoCollector_hpp */
