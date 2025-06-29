//
//  ViewController.m
//  Appguard-Sample-OjbC
//
//  Created by HyupM1 on 2022/12/01.
//

#import "ViewController.h"

#import <AppGuard/Diresu.h>
#import <AppGuard/Rednilb.h>
#import <AppGuard/NHNAG.h>
#import "AGAttacker.hpp"
#import "LocationManager.h"

@interface ViewController () <LocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *agVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *iosVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *callbackLogTextView;
@property (weak, nonatomic) IBOutlet UILabel *isDebugModeLabel;
@property (weak, nonatomic) IBOutlet UIButton *modificationButton;
@property (weak, nonatomic) IBOutlet UIButton *hookingButton;
@property (weak, nonatomic) IBOutlet UIButton *setUserIdButton;
@property (weak, nonatomic) IBOutlet UITextField *setUserIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *runLocationButton;
@property (weak, nonatomic) IBOutlet UISwitch *contentProtectinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *snapshotProtectionSwitch;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUserIdTextField].delegate = self;
    
    NSString* str =@"HelloWord";
    
    //UI 설정
    if([AGAttacker findSubstrateIndex] == -1) { //탈옥이 아닐경우 테스트 하지 못하도록 hidden
        [self.hookingButton setHidden:YES];
        [self.modificationButton setHidden:YES];
    } else {
        [self.modificationButton setTitle:@"변조 되었음." forState: UIControlStateDisabled];
        [self.hookingButton setTitle:@"후킹 되었음." forState: UIControlStateDisabled];
    }
    [_contentProtectinSwitch setOn:NO];
    [_snapshotProtectionSwitch setOn:NO];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(callbackListener:) name:@"AGCallback" object:nil];
    NSString *server = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppGuard"] objectForKey:@"Server"] ?: @"REAL";
    NSString *appKey = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppGuard"] objectForKey:@"AppKey"] ?: @"RJbjBOxk4vT4ROwZ";
    NSLog(@"[+] Server: %@, AppKey: %@", server, appKey);
    NSString* userName = @"DEV";
    IMP callback = [self methodForSelector:@selector(callback:)];
    NSString* deviceId = @"N/A";
#ifdef APPGUARD_RELEASE
    [Diresu s:appKey :userName :[self appName] :[self appVersion]];
    [Diresu o:callback :YES];
    deviceId = [Diresu g];
    //parseJsonSvrLog();
#else
    [AppGuardCore doAppGuard:appKey :userName :[self appName] :[self appVersion]];
    [AppGuardCore setCallback:callback :YES];
    deviceId = [AppGuardCore getDeviceID];
  //  checkSwizzled();
  
  
    
#endif
    
    [[self appKeyLabel] setText:[NSString stringWithFormat:@"APPKEY : %@ (%@)",  appKey, server]];
    [[self userNameLabel] setText:[NSString stringWithFormat:@"UserName : %@",  userName]];
    [[self iosVersionLabel] setText:[NSString stringWithFormat:@"iOS Version: v%@", [self systemVersion]]];
    [[self agVersionLabel] setText:[NSString stringWithFormat:@"SDK Version : v%@", NHNAppGuardVersion]];
    [[self appNameLabel] setText:[NSString stringWithFormat:@"AppName : %@",  [self appName]]];
    [[self appVersionLabel] setText:[NSString stringWithFormat:@"AppVersion : %@",  [self appVersion]]];
    [[self deviceUUIDLabel] setText:[NSString stringWithFormat:@"DeviceID : \n%@", deviceId]];
    [[self isDebugModeLabel] setText: [self buildMode]];
    [[self callbackLogTextView] setText: @"AppGuard is started.\n"];
    [[self sdkClassLabel] setText:[NSString stringWithFormat:@"SDK Class Name : %@" ,[self agClassName]]];
    
    [self appendCallbakLogTextView:[NSString stringWithFormat:@"Substrate library index: %d", [AGAttacker findSubstrateIndex]]];
}
- (IBAction)onModificationButton:(id)sender {
    if([AGAttacker binaryPatchAttack]) {
        [self.modificationButton setEnabled:NO];
        [self.modificationButton setBackgroundColor:[UIColor systemPinkColor]];
        [self appendCallbakLogTextView:@"## The modification is success."];
    } else {
        [self appendCallbakLogTextView:@"## The modification is failed."];
    }
  
}
- (IBAction)onHookingButton:(id)sender {
    if([AGAttacker findSubstrateIndex] == -1) {
        [self appendCallbakLogTextView:@"## libsubstrate.dylib is not found."];
        return;
    }
    if([AGAttacker hookingAttack]) {
        [self.hookingButton setEnabled:NO];
        [self.hookingButton setBackgroundColor:[UIColor systemPinkColor]];
        [self appendCallbakLogTextView:@"## The API Hooking is success."];
    } else {
        [self appendCallbakLogTextView:@"## The modification is failed."];
    }
}

- (void)callbackListener:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendCallbakLogTextView:(NSString*)notification.object];
    });
}
- (IBAction)onContentProtectionSwitch:(id)sender {
    if(_contentProtectinSwitch.isOn) {
    
        [AppGuardCoreBlinder protectContent:YES ];
        [self appendCallbakLogTextView:@"## Snapshot content protection is activated."];
    } else {
        [AppGuardCoreBlinder protectContent:NO ];
        [self appendCallbakLogTextView:@"## Snapshot content protection is deactivated."];
    }
}
- (IBAction)onSnapshotProtectionSwitch:(id)sender {
    if(_snapshotProtectionSwitch.isOn) {
      
        [AppGuardCoreBlinder protectSnapshot:YES];
        [self appendCallbakLogTextView:@"## Snapshot screen protection is activated."];
    } else {
        [AppGuardCoreBlinder protectSnapshot:NO];
        [self appendCallbakLogTextView:@"## Snapshot screen protection is deactivated."];
    }
}

- (IBAction)runLocationButtonAction:(id)sender {
    if([LocationManager shared].isLocationRunning == NO)
    {
        [LocationManager shared].delegate = self;
        [[LocationManager shared] requestLocationServiceAuthorization];
        [[LocationManager shared] setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.runLocationButton setEnabled:NO];
        [self.runLocationButton setBackgroundColor:[UIColor systemPinkColor]];
        [self.runLocationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.runLocationButton setTitle:@"Running Location" forState:UIControlStateDisabled];

        [[LocationManager shared] startWithAccuracyLevel:AccuracyLevelStand];
    }
}

- (void)appendCallbakLogTextView:(NSString*)log {
    [[self callbackLogTextView] setText:[[self callbackLogTextView].text stringByAppendingFormat:@"\n%@", log]];
    [[self callbackLogTextView] scrollRangeToVisible:NSMakeRange([self callbackLogTextView].text.length, 0)];
}

- (void)callback:(NSString *)json {
    NSLog(@"%@", json);
    [NSNotificationCenter.defaultCenter postNotificationName:@"AGCallback" object:json];
}

- (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
- (void)setUserId:(NSString*)userId {
#ifdef APPGUARD_RELEASE
    [Diresu n:userId];
#else
    [AppGuardCore setUserName: userId];
#endif
    [[self setUserIdTextField] setText:@""];
    [[self userNameLabel] setText:[NSString stringWithFormat:@"UserName : %@",  userId]];
    [self appendCallbakLogTextView:[NSString stringWithFormat:@"## Set User Id: %@", userId]];
    [[self view] endEditing:YES];
}
- (IBAction)onSetUserIdButton:(id)sender {
    [self setUserId:[self.setUserIdTextField text]];
}

- (NSString *)agClassName {
#ifdef APPGUARD_RELEASE
    return NSStringFromClass([Diresu class]);
#else
    return NSStringFromClass([AppGuardCore class]);
#endif
}

- (NSString *)buildMode {
#ifdef DEBUG
    return @"DEBUG MODE BUILD";
#else
    return @"RELEASE MODE BUILD";
#endif
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self setUserId:[self.setUserIdTextField text]];
    return YES;
}
- (void)didVisit:(nonnull CLVisit *)visit { 

}

- (void)updateLocation:(nullable CLLocation *)location error:(nullable NSError *)error { 
    if (error == nil &&
        location != nil) {
    
        NSMutableString *locationString = [NSMutableString string];
        [locationString appendFormat:@"location: %@\n\thorizontalAccuracy:%.2f\n\tverticalAccuracy: %.2f\n\tspeed: %.2f\n\taltitude: %.2f\n\tlatitude: %.2f\n\tlongitude: %.2f",
         location.timestamp,
         location.horizontalAccuracy,
         location.verticalAccuracy,
         location.speed,
         location.altitude,
         location.coordinate.latitude,
         location.coordinate.longitude
        ];
        [self appendCallbakLogTextView:locationString];
 

    }

}

@end

