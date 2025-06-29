//
//  AGProtectContent.h
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AGCommon.hpp"

class AG_PRIVATE_API AGProtectContent {
public:
    AGProtectContent();
    ~AGProtectContent();
    void SetActive(bool active);
    
private:
    void RegisterSecureView();
    bool alreadySet_;
    UITextField *secureView_;
    UIView *secureBlockView_;
    UIView *customSecureBlockView_;
};

