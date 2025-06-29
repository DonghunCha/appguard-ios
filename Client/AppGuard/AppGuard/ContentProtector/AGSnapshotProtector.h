//
//  AGSnapshotProtector.h
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AGCommon.hpp"

// internal Objc class obfuscation
#ifndef DEBUG
#define AGSnapshotLifecycleNotification S4NSDDH9Z3PIME6YILSOC
#define registerSnapshotNotification U2YPM5WP14ATCKWYN1RPM
#define unregisterSnapshotNotification ETMBMZA8JS8METOJUD7YV
#endif

typedef void (*SnapshotNoficationCallback)(bool activeSnapshot, void* context);

@interface AGSnapshotLifecycleNotification : NSObject
- (void)registerSnapshotNotification:(SnapshotNoficationCallback)callback : (void*)context;
- (void)unregisterSnapshotNotification;
@end


class AG_PRIVATE_API AGSnapshotProtector {
public:
    AGSnapshotProtector();
    ~AGSnapshotProtector();
    void SetActive(bool active, UIView* customView = nil);
    static void SnapshotCallback(bool activeSnapshot, void* context);

private:
    void AddSnapshotBlockView();
    void RemoveSnapshotBlockView();
    static UIView* GetDefaultBlockView();
    bool active_;
    UIView* blockingView_;
    AGSnapshotLifecycleNotification* notification_;
};
