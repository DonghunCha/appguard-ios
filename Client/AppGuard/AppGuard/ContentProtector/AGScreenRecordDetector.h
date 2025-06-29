//
//  AGScreenRecordDetector.h
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import <Foundation/Foundation.h>
#import "AGCommon.hpp"

class AG_PRIVATE_API AGScreenRecordDetector {
public:
    AGScreenRecordDetector();
    ~AGScreenRecordDetector();
    void SetActive(bool active, int recordedTimeThresholdSec = 3);    
private:
    bool active_;
    int recordedTimeSec_;
    int recordedTimeThresholdSec_;
    NSOperationQueue *monitorQueue_;
};
