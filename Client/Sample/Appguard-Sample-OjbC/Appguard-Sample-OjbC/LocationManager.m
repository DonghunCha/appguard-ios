//
//  LocationManager.m
//  AGLocation
//
//  Created by NHN on 4/4/24.
//

#import "LocationManager.h"


@implementation LocationManager


+ (instancetype)shared {
    static LocationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] init];

    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.isLocationRunning = NO;
        
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.pausesLocationUpdatesAutomatically = NO;
    }
    
    return self;
}

- (void)requestLocationServiceAuthorization {
    self.manager.allowsBackgroundLocationUpdates = YES;
    [self.manager requestAlwaysAuthorization];
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    self.manager.desiredAccuracy = desiredAccuracy;
}

- (void)startWithAccuracyLevel:(AccuracyLevel)level {
    
    //[self.manager requestLocation]; //1회 반환, 내부적으로 startUpdating, stopUpdating을 수행
    
    self.isLocationRunning = YES;
    self.currentAccuracyLevel = level;
    switch (level) {
        case AccuracyLevelVisit:
            [self.manager startMonitoringVisits];
            break;
        case AccuracyLevelSignificant:
            [self.manager startMonitoringSignificantLocationChanges];
            break;
        case AccuracyLevelStand:
            [self.manager startUpdatingLocation];
            break;
            
        default:
            break;
    }
}

- (void)stopWithAccuracyLevel:(AccuracyLevel)level {
    
    switch (level) {
        case AccuracyLevelVisit:
            [self.manager stopMonitoringVisits];
            break;
        case AccuracyLevelSignificant:
            [self.manager stopMonitoringSignificantLocationChanges];
            break;
        case AccuracyLevelStand:
            [self.manager stopUpdatingLocation];
            break;
            
        default:
            break;
    }
        
    self.isLocationRunning = NO;
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus status = [manager authorizationStatus];
        
        switch (status) {
            case kCLAuthorizationStatusNotDetermined : {
                NSLog(@"locationManagerDidChangeAuthorization: kCLAuthorizationStatusNotDetermined");
                break;
            }
            case kCLAuthorizationStatusRestricted : {
                NSLog(@"locationManagerDidChangeAuthorization: kCLAuthorizationStatusRestricted");
                break;
            }
                
            case kCLAuthorizationStatusDenied : {
                NSLog(@"locationManagerDidChangeAuthorization: kCLAuthorizationStatusDenied");
                [self.manager requestWhenInUseAuthorization];
                break;
            }
            case kCLAuthorizationStatusAuthorizedAlways : {
                NSLog(@"locationManagerDidChangeAuthorization: kCLAuthorizationStatusAuthorizedAlways");
                
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse : {
                NSLog(@"locationManagerDidChangeAuthorization: kCLAuthorizationStatusAuthorizedWhenInUse");
                break;
            }
                
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
    }
}

// iOS 14 Deprecated - locationManagerDidChangeAuthorization
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined : {
            NSLog(@"didChangeAuthorizationStatus: kCLAuthorizationStatusNotDetermined");
            break;
        }
        case kCLAuthorizationStatusRestricted : {
            NSLog(@"didChangeAuthorizationStatus: kCLAuthorizationStatusRestricted");
            break;
        }

        case kCLAuthorizationStatusDenied : {
            NSLog(@"didChangeAuthorizationStatus: kCLAuthorizationStatusDenied");
            [self.manager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways : {
            NSLog(@"didChangeAuthorizationStatus: kCLAuthorizationStatusAuthorizedAlways");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse : {
            NSLog(@"didChangeAuthorizationStatus: kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
        }
            
        default:
        break;
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"locationManager: didUpdateLocations:");
    NSLog(@"locations [%lu] : %@", (unsigned long)locations.count, [locations description]);
    for (CLLocation *location in locations) {
        [self.delegate updateLocation:location error:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager: didFailWithError:");
    NSLog(@"error: %@", [error description]);
    [self.delegate updateLocation:nil error:error];
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    NSLog(@"locationManager: didVisit:");
    [self.delegate didVisit:visit];
    
}

//.....




- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"locationManager: didEnterRegion:");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"locationManager: didExitRegion:");
}




- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"locationManagerDidPauseLocationUpdates:");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"locationManagerDidResumeLocationUpdates:");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"locationManager: didRangeBeacons: inRegion:");
}



- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"locationManager: didStartMonitoringForRegion:");
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state didDetermineState:(CLRegion *)region {
    NSLog(@"locationManager: didDetermineState: didDetermineState:");
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"locationManager: didFinishDeferredUpdatesWithError:");
}



- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons satisfyingConstraint:(CLBeaconIdentityConstraint *)beaconConstraint  API_AVAILABLE(ios(13.0)){
    NSLog(@"locationManager: didRangeBeacons: satisfyingConstraint:");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"locationManager: monitoringDidFailForRegion:");
}

- (void)locationManager:(CLLocationManager *)manager didFailRangingBeaconsForConstraint:(CLBeaconIdentityConstraint *)beaconConstraint error:(NSError *)error  API_AVAILABLE(ios(13.0)){
    NSLog(@"locationManager: didFailRangingBeaconsForConstraint: error:");
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"locationManager: rangingBeaconsDidFailForRegion: withError:");
}

@end
