//
//  LocationManager.h
//  AGLocation
//
//  Created by NHN on 4/4/24.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AccuracyLevel) {
    AccuracyLevelVisit = 0,
    AccuracyLevelSignificant = 1,
    AccuracyLevelStand = 2,
};

@protocol LocationManagerDelegate <NSObject>

- (void)updateLocation:(nullable CLLocation *)location error:(nullable NSError *)error;
- (void)didVisit:(CLVisit *)visit;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) id<LocationManagerDelegate> delegate;
@property (assign) BOOL isLocationRunning;
@property (assign) AccuracyLevel currentAccuracyLevel;

+ (instancetype)shared;
- (void)requestLocationServiceAuthorization;

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy;

- (void)startWithAccuracyLevel:(AccuracyLevel)level;
- (void)stopWithAccuracyLevel:(AccuracyLevel)level;

@end

NS_ASSUME_NONNULL_END
