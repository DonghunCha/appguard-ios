//
//  AGSnapshotProtector.m
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import "AGSnapshotProtector.h"
#import "ContentProtectorUtils.h"
#import "util.h"
@interface AGSnapshotLifecycleNotification()
@property SnapshotNoficationCallback callback;
@property void* context;

@end

@implementation AGSnapshotLifecycleNotification

- (void)snapshotActiveNotification:(NSNotification *)notification {
    if(self.callback) {
        self.callback(true, self.context);
    }
}

- (void)snapshotDeactiveNotification:(NSNotification *)notification {
    if(self.callback) {
        self.callback(false, self.context);
    }
}
- (void)registerSnapshotNotification:(SnapshotNoficationCallback)callback : (void*)context {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        if ([ContentProtectorUtils isUsingSceneDelegate]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(snapshotActiveNotification:)
                                                         name:UISceneWillDeactivateNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(snapshotDeactiveNotification:)
                                                         name:UISceneDidActivateNotification
                                                       object:nil];
            AGLog(@"Scene Delegate");
            
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(snapshotActiveNotification:)
                                                         name:UIApplicationWillResignActiveNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(snapshotDeactiveNotification:)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
            AGLog(@"App Delegate");
        }
        self.callback = callback;
        self.context = context;
    }
}

-(void)unregisterSnapshotNotification {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        if ([ContentProtectorUtils isUsingSceneDelegate]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                         name:UISceneWillDeactivateNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                         name:UISceneDidActivateNotification
                                                       object:nil];
            AGLog(@"Scene Delegate");
            
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                         name:UIApplicationWillResignActiveNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
            AGLog(@"App Delegate");
        }
        self.callback = nullptr;
        self.context = nullptr;
    }
}
@end

AG_PRIVATE_API AGSnapshotProtector::AGSnapshotProtector()
:blockingView_(nil),
active_(false),
notification_(nil){
    
}

AG_PRIVATE_API AGSnapshotProtector::~AGSnapshotProtector() {
    if(notification_) {
        [notification_ unregisterSnapshotNotification];
        notification_ = nil;
    }
}

AG_PRIVATE_API void AGSnapshotProtector::SetActive(bool active, UIView* customView) {
    if(!notification_) {
        notification_ = [[AGSnapshotLifecycleNotification alloc] init];
    }
    
    if(active) {
        [notification_ registerSnapshotNotification: SnapshotCallback :this];
        blockingView_ = customView ? customView : GetDefaultBlockView();
    } else {
        [notification_ unregisterSnapshotNotification];
        blockingView_ = nil;
    }

}

AG_PRIVATE_API UIView* AGSnapshotProtector::GetDefaultBlockView() {
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

AG_PRIVATE_API void AGSnapshotProtector::AddSnapshotBlockView() {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        if(blockingView_) {
            UIWindow* currentWindow = [ContentProtectorUtils currentWindow];
            if(currentWindow) {
                [[ContentProtectorUtils currentWindow] addSubview:blockingView_];
                blockingView_.translatesAutoresizingMaskIntoConstraints = NO;
                [blockingView_.leadingAnchor constraintEqualToAnchor:blockingView_.superview.leadingAnchor].active = YES;
                [blockingView_.trailingAnchor constraintEqualToAnchor:blockingView_.superview.trailingAnchor].active = YES;
                [blockingView_.topAnchor constraintEqualToAnchor:blockingView_.superview.topAnchor].active = YES;
                [blockingView_.bottomAnchor constraintEqualToAnchor:blockingView_.superview.bottomAnchor].active = YES;
            }
        }
    }
    
}

AG_PRIVATE_API void AGSnapshotProtector::RemoveSnapshotBlockView() {
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"13.0")) {
        if(blockingView_) {
            [blockingView_ removeFromSuperview];
        }
    }
}


void AGSnapshotProtector::SnapshotCallback(bool activeSnapshot, void* context) {
    AGSnapshotProtector* protector = reinterpret_cast<AGSnapshotProtector*>(context);
    if(protector) {
        if(activeSnapshot) {
            AGLog(@"activeSnapshot : true");
            protector->AddSnapshotBlockView();
        } else {
            AGLog(@"activeSnapshot : false");
            protector->RemoveSnapshotBlockView();
        }
    }
}
