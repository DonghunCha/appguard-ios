//
//  AppGuardValidatorViewController.m
//  AppGuardTools
//
//  Created by NHN on 2023/01/31.
//

#import "AppGuardValidatorViewController.h"
#import "AppGuardValidator.hpp"


@interface AppGuardValidatorViewController()

@property (weak) IBOutlet NSButton *validateButton;
@property (weak) IBOutlet NSTextField *filePathTextField;
@property (weak) IBOutlet NSTextView *outputTextView;

@end

@implementation AppGuardValidatorViewController


- (void)viewWillAppear
{
    [super viewWillAppear];
    self.preferredContentSize = CGSizeMake(800, 800);
}
- (void)appendOutputView:(NSString*)log {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.outputTextView.string = [NSString stringWithFormat:@"%@%@\n", self.outputTextView.string, log];
        [self.outputTextView scrollRangeToVisible: NSMakeRange(self.outputTextView.string.length - 1, 1)];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (NSString*) shellTask:(NSString*)command {
    NSString* output = @"";
    @try {
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *file = pipe.fileHandleForReading;
        NSMutableArray* args = [[NSMutableArray alloc] init];
        
        [args addObject:@"-c"];
        [args addObject:command];
        
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/bin/bash" ;
        task.arguments = args;
        task.standardOutput = pipe;
        [task launch];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        output =  [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        [self appendOutputView:[NSString stringWithFormat:@"error shell task : reason:%@", exception.reason]];
    }
    return output;
}

- (BOOL) doValidate: (NSString*) filePath {
    [self appendOutputView:@"[+] --------- ---------------------------------"];
    
    NSError *error = nil;
    NSFileManager* fileMgr = [NSFileManager defaultManager];
 
    if(![fileMgr fileExistsAtPath:filePath]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tThe file not exists."]];
        return NO;
    }
    [self appendOutputView:@"[+] Start validation."];
    [self appendOutputView:[NSString stringWithFormat:@"\tIPA File path:%@", filePath]];
  
    // create working directory.
    [self appendOutputView:@"[+] Create working directory"];
    NSString* workingDirectory = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];

    if(![fileMgr createDirectoryAtPath:workingDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tCan not create working directory(%@).",workingDirectory]];
        return NO;
    }
    
    [self appendOutputView:[NSString stringWithFormat:@"\tworking Directory :%@", workingDirectory]];
    
    // copy ipa file
    [self appendOutputView:@"[+] Copy ipa file."];
    NSURL* filePathURL = [NSURL fileURLWithPath:filePath];
    NSString* copiedIPAPath = [NSString stringWithFormat:@"%@/%@", workingDirectory, [filePathURL lastPathComponent]];
    
    if(![fileMgr copyItemAtPath:filePath toPath: copiedIPAPath error:nil]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tCan not copy ipa file to working directory(%@).",copiedIPAPath]];
        return NO;
    }
    
    [self appendOutputView:[NSString stringWithFormat:@"\tThe IPA file is copied:%@", copiedIPAPath]];

    
    //Unzip ipa file
    [self appendOutputView:@"[+] Unzip ipa file."];
    NSString* shellOut = [self shellTask: [NSString stringWithFormat:@"unzip \"%@\" -d \"%@\"",copiedIPAPath, workingDirectory]];
    if([shellOut length] == 0) {
        return NO;
    }
  //  [self appendOutputView:shellOut];
    
//    shellOut = [self shellTask: [NSString stringWithFormat:@"ls -al \"%@/Payload\"", workingDirectory]];
//    if([shellOut length] == 0) {
//        return NO;
//    }
//    [self appendOutputView:shellOut];
    
    //find mach-o app path
    [self appendOutputView:@"[+] find mach-o app path"];
    NSString* payloadPath = [NSString stringWithFormat:@"%@/Payload", workingDirectory];
    NSArray* files = [fileMgr contentsOfDirectoryAtPath:payloadPath error:&error];
    if(!files) {
        [self appendOutputView:[NSString stringWithFormat:@"\tCan not find app path in payload directory.(%@).",error]];
        return NO;
    }
    
    NSString* appName = @"";
    for(NSString* f in files) {
        if([f rangeOfString:@".app"].location != NSNotFound) {
            appName = f;
            break;
        }
    }
    
    if([appName length] == 0) {
        [self appendOutputView:[NSString stringWithFormat:@"Can not find app path in payload directory."]];
        return NO;
    }
    
    [self appendOutputView:[NSString stringWithFormat:@"\tApp directory.: %@",appName]];
    
    //find mach-o executable
    [self appendOutputView:@"[+] find mach-o executable"];
    NSString *appDir = [NSString stringWithFormat:@"%@/%@",payloadPath, appName];
    NSString* executableName = [appName stringByReplacingOccurrencesOfString:@".app" withString:@""];
    NSString* executableNamePath = [NSString stringWithFormat:@"%@/%@", appDir, executableName];
    if(![fileMgr fileExistsAtPath:executableNamePath]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tCan not find executable in app directory."]];
        return NO;
    }
    [self appendOutputView:[NSString stringWithFormat:@"\texecutable path : %@", executableNamePath]];
    
    //find unityframework
    [self appendOutputView:@"[+] find unityframework"];
    NSString* unityFrameworkPath = [NSString stringWithFormat:@"%@/Frameworks/UnityFramework.framework/UnityFramework", appDir];
    if(![fileMgr fileExistsAtPath:unityFrameworkPath]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tPass!! Can not find unityframework in frameworks directory."]];
        unityFrameworkPath = @"";
    }else {
        [self appendOutputView:[NSString stringWithFormat:@"\tunityframework path : %@", unityFrameworkPath]];
    }
    
    [self appendOutputView:@"[+] Target"];
    NSString *targetMachOPath = [unityFrameworkPath length] != 0 ? unityFrameworkPath : executableNamePath;
    [self appendOutputView:[NSString stringWithFormat:@"\tThe Validation target Mach-O Path: %@", targetMachOPath]];
    [self appendOutputView:@"[+] Protect Level"];
    [self appendOutputView:[NSString stringWithFormat:@": %d",[AppGuardValidator getProtectLevel:targetMachOPath]]];
    
    [self appendOutputView:@"[+] Info.plist"];
    [self appendOutputView:[NSString stringWithFormat:@"\tHash from signature: %@",[AppGuardValidator getPlistInfoHashFromSignature:targetMachOPath]]];
    [self appendOutputView:@"[+] Signatures"];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getTextSectionSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getSignerSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getDefaultPolicySignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getNewDefaultPolicySignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getNumberOfLCSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getUnityTextSectionSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getUnityIl2cppSectionSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getDefaultProtectLevelSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getInfoPlistSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getApiKeySignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getApiKeyReplaceSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getStartupMessageSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getStartupMessageReplaceSignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getDefaultPolicySignature:targetMachOPath]]];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getDetectionPopupReplaceSignature:targetMachOPath]]];
    [self appendOutputView:@"[+] Protector Injected API Key: "];
    [self appendOutputView:[NSString stringWithFormat:@"\t%@",[AppGuardValidator getApiKey:targetMachOPath]]];
    
    [self appendOutputView:@"[+] SDK Version"];
    [self appendOutputView:[NSString stringWithFormat:@"\tv%@",[AppGuardValidator getSDKVersion:targetMachOPath]]];
    [self appendOutputView:@"[+] Protector Version"];
    [self appendOutputView:[NSString stringWithFormat:@"\tv%@",[AppGuardValidator getProtectorVersion:targetMachOPath]]];
    
    [self appendOutputView:@"[+] Startup Message"];
    if([AppGuardValidator getStartupMessageReplaceSignature:targetMachOPath]) {
        [self appendOutputView:[NSString stringWithFormat:@"\tStartup message is activated."]];
        [self appendOutputView:[NSString stringWithFormat:@"\tStartup message duration: %dms" ,[AppGuardValidator getStartupmessageDuration:targetMachOPath]]];
        [self appendOutputView:[NSString stringWithFormat:@"\tStartup message delay: %dms" ,[AppGuardValidator getStartupmessageDelay:targetMachOPath]]];
    } else {
        [self appendOutputView:[NSString stringWithFormat:@"\tStartup message is not activated."]];
    }
    
    [self appendOutputView:@"[+] Detection Popup Mode"];
    int detectionPopupMode = [AppGuardValidator getDetectionPopupMode:targetMachOPath];
    NSString* detectionPopupModeString;
    if(detectionPopupMode == 0) {
        detectionPopupModeString = @"detailed";
    } else if (detectionPopupMode == 1) {
        detectionPopupModeString = @"simple";
    } else {
        detectionPopupModeString = @"unknown";
    }
    [self appendOutputView:[NSString stringWithFormat:@"\tDetection Popup Mode: %@(%d)", detectionPopupModeString, detectionPopupMode ]];
    
    [self appendOutputView:@"[+] Classes"];
    NSArray* classList =  [AppGuardValidator getClassList:targetMachOPath];
    for(NSString* cls in classList) {
        [self appendOutputView:[NSString stringWithFormat:@"\t%@",cls]];
    }
    [self appendOutputView:@"[+] Done."];
    return YES;
}

- (IBAction)onValidate:(id)sender {
    NSLog(@"push Validate Button!");
 
    NSString* filePath = [self.filePathTextField stringValue];
   
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [self.validateButton setTitle:@"wait.."];
            [self.validateButton setEnabled:NO];
            [self.filePathTextField setEnabled:NO];
        });
    
        [self doValidate:filePath];
        dispatch_sync(dispatch_get_main_queue(), ^(void){

            [self.validateButton setTitle:@"Validate"];
            [self.validateButton setEnabled:YES];
            [self.filePathTextField setEnabled:YES];
        });
    });
}

@end
