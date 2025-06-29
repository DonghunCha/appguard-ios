//
//  AGVPNDetectManager.h
//  AppGuard
//
//  Created by NHN on 10/29/24.
//

#ifndef AGVPNDetectManager_h
#define AGVPNDetectManager_h


#include "AGCommon.hpp"
#include <vector>
#import <Foundation/Foundation.h>

class AG_PRIVATE_API AGVPNDetectManager {
public:
    AGVPNDetectManager();
    ~AGVPNDetectManager();
    bool IsVPNNetwork(std::vector<NSString*>* vpnInterfaces);
};

#endif /* AGVPNDetectManager_h */
