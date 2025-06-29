//
//  AGProtectContent.m
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import "AGProtectContent.h"
#import "util.h"
#import "ContentProtectorUtils.h"

AG_PRIVATE_API AGProtectContent::AGProtectContent()
: secureView_(nil),
secureBlockView_(nil),
customSecureBlockView_(nil),
alreadySet_(false){
}

AG_PRIVATE_API AGProtectContent::~AGProtectContent() {
    
}

AG_PRIVATE_API void AGProtectContent::SetActive(bool active) {
   
    if(active) {
        if(!alreadySet_) {
            RegisterSecureView();
            AGLog(@"AGProtectContent is activated. first.");
        }
    }
    
    if(!secureView_)
    {
        AGLog(@"secureView_ is not created.");
        return;
    }
    
    secureView_.secureTextEntry = active ? YES : NO;
}

AG_PRIVATE_API void AGProtectContent::RegisterSecureView() {
    UIWindow* currentWindow = [ContentProtectorUtils currentWindow];
    if(currentWindow == nil) {
        AGLog(@"Can't find current Window.");
        return;
    }
    
    secureView_ = [[UITextField alloc] init];
    secureView_.secureTextEntry = YES;
 
    [currentWindow addSubview:secureView_];
    [currentWindow.layer.superlayer addSublayer:secureView_.layer];
    
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"17.0")) {
        [secureView_.layer.sublayers.lastObject addSublayer:currentWindow.layer]; // >= ios 17
    } else {
        [secureView_.layer.sublayers.firstObject addSublayer:currentWindow.layer]; // < ios 17
    }
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, secureView_.frame.size.width, secureView_.frame.size.height)];
    view.backgroundColor = [UIColor greenColor];
  
    secureBlockView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    secureBlockView_.backgroundColor = [UIColor blackColor];

    secureBlockView_.userInteractionEnabled = NO;
    [view addSubview:secureBlockView_];
    
    [currentWindow addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.leadingAnchor constraintEqualToAnchor:view.superview.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:view.superview.trailingAnchor].active = YES;
    [view.topAnchor constraintEqualToAnchor:view.superview.topAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:view.superview.bottomAnchor].active = YES;
    
    secureView_.leftView = view;
    secureView_.leftViewMode = UITextFieldViewModeAlways;
    [currentWindow layoutIfNeeded]; //ui업데이트
    alreadySet_ = true;
}
