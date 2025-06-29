//
//  AGAlertMonitor.hpp
//  AppGuard
//
//  Created by HyupM1 on 2023/12/04.
//

#ifndef AGAlertMonitor_hpp
#define AGAlertMonitor_hpp

#include <stdio.h>

#import <Foundation/Foundation.h>

#import "AGNotice.h"
#import "Singleton.hpp"
#import "AGAlert.h"
#import "Pattern/Pattern.h"

class __attribute__((visibility("hidden"))) AGAlertMonitor {
public:
    AGAlertMonitor();
    ~AGAlertMonitor();
    void start();
    void setData(AGPatternGroup group, AGPatternName name);

private:
    void startDetectedPatternDataMonitor();
    bool showAlert_;
    AGPatternGroup group_;
    AGPatternName pattern_;
};


#endif /* AGAlertMonitor_hpp */
