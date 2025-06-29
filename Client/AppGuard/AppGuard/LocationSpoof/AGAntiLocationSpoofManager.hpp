//
//  AGAntiLocationSpoofManager.hpp
//  AppGuard
//
//  Created by NHN on 4/22/24.
//

#ifndef AGAntiLocationSpoofManager_hpp
#define AGAntiLocationSpoofManager_hpp

#include <Foundation/Foundation.h>

@class CLLocationManager;
@class CLLocation;

typedef struct {
    double latitude;
    double longitude;
} Coordinate;

class __attribute__((visibility("hidden"))) AGAntiLocationSpoofManager {
public:
    AGAntiLocationSpoofManager();
    ~AGAntiLocationSpoofManager();
    bool Initialize();
    void DidUpdateLocations(NSArray<CLLocation *> *locations);
private:
    bool IsSimulate(id location);
    dispatch_queue_t responseQueue_;
};

#endif /* AGAntiLocationSpoofManager_hpp */
