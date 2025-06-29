//
//  AGAntiDumpManager.hpp
//  AppGuard
//
//  Created by NHN on 2023/06/14.
//

#ifndef AGAntiDumpManager_hpp
#define AGAntiDumpManager_hpp

#import <Foundation/Foundation.h>

class __attribute__((visibility("hidden"))) AGAntiDumpManager {

public:
    AGAntiDumpManager();
    ~AGAntiDumpManager();
    void Initialize();
private:
    BOOL InitFridaIOSDumpDetection();
    BOOL checkFridaServer();
    BOOL checkMobileSubstrateDynamicLibLoaded();
    BOOL InitBfdecryptDumpDetection();
};

#endif /* AGAntiDumpManager_hpp */
