//
//  PolicyCheckerViewController.m
//  AppGuardTools
//
//  Created by NHN on 2023/03/27.
//

#import "PolicyCheckerViewController.h"
#import "Decryptor.hpp"
#import "PacketEncryptor.hpp"

NSString const* gPolicyCDNDomain = @"https://adam.cdn.toastoven.net";
NSString const* gConditionalPolicyURL = @"https://api-appguard-policy.cloud.toast.com/v1/block";
NSString const* gAlphaConditionalPolicyURL = @"http://alpha-agd-policy.nhn.com/v1/block";
NSString const* gBetaConditionalPolicyURL = @"http://beta-agd-policy.nhn.com/v1/block";

typedef NS_ENUM(int, AGPolicyTypeIndex) {
    kJailbreakIdx = 0,
    kCheatingIdx,
    kDebuggerIdx,
    kModificationIdx,
    kSimulatorIdx,
    kHookIdx,
    kNetworkIdx,
};

NSArray const* AGPolicyTypeNameList = [NSArray arrayWithObjects:
                        @"Jailbreak",
                        @"Cheating",
                        @"Debugger",
                        @"Modification",
                        @"Simulator",
                        @"Hook",
                        @"MacroTool",
                        @"LocationSpoofing",
                        @"ScreenCapture",
                        @"ScreenRecord",
                        @"VPN",
                        @"Network",
                        nil
];

NSArray const* AGPolicyResponseTypeNameList = [NSArray arrayWithObjects:
                        @"Unknown 0",
                        @"Detect",
                        @"Block",
                        @"Off",
                        @"Conditional",
                        nil
];

NSArray const* AGNewPolicyResponseTypeNameList = [NSArray arrayWithObjects:
                        @"off",
                        @"Detect",
                        @"Block",
                        @"Conditional",
                        @"Individual",
                        nil
];

typedef NS_ENUM(int, AGPatternGroup) {
    AGPatternGroupRegisterCallback = -6,
    AGPatternGroupBehavior = -11,
    AGPatternGroupNone = 0,
    AGPatternGroupCheatingTool = 1,
    AGPatternGroupSimulator = 2,
    AGPatternGroupModification = 4,
    AGPatternGroupDebugger = 5,
    AGPatternGroupNetwork = 12,
    AGPatternGroupJailbreak = 10,
    AGPatternGroupHooking = 11,
    AGPatternGroupMacroTool = 17,
    AGPatternGroupLocationSpoofing = 18,
    AGPatternGroupScreenCapture = 20,
    AGPatternGroupScreenRecord = 21,
    AGPatternGroupVPN = 22,
    AGPatternGroupBlackList = 90,
};


typedef NS_ENUM(int, AGRuleGroupSeq)
{
    kJailbreakSeq = AGPatternGroup::AGPatternGroupJailbreak,
    kCheatingToolSeq = AGPatternGroupCheatingTool,
    kDebuggerSeq = AGPatternGroupDebugger,
    kModificationSeq = AGPatternGroupModification,
    kSimulatorSeq = AGPatternGroupSimulator,
    kHookSeq = AGPatternGroupHooking,
    kMacroToolSeq = AGPatternGroupMacroTool,
    kLocationSpoofingSeq = AGPatternGroupLocationSpoofing,
    kScreenRecordSeq = AGPatternGroupScreenRecord,
    kScreenCaptureSeq = AGPatternGroupScreenCapture,
    kVPNSeq = AGPatternGroupVPN,
    kBlackListSeq = AGPatternGroupBlackList,
};

NSDictionary const* AGRuleGroupSeqDictionary = @{
    @"Jailbreak": [NSNumber numberWithInt:kJailbreakSeq],
    @"Cheating": [NSNumber numberWithInt:kCheatingToolSeq],
    @"Debugger": [NSNumber numberWithInt:kDebuggerSeq],
    @"Modification": [NSNumber numberWithInt:kModificationSeq],
    @"Simulator": [NSNumber numberWithInt: kSimulatorSeq],
    @"Hook": [NSNumber numberWithInt:kHookSeq],
    @"MacroTool": [NSNumber numberWithInt:kMacroToolSeq],
    @"LocationSpoofing" :[NSNumber numberWithInt:kLocationSpoofingSeq],
    @"ScreenRecord" :[NSNumber numberWithInt:kScreenRecordSeq],
    @"ScreenCapture":[NSNumber numberWithInt:kScreenCaptureSeq],
    @"VPN":[NSNumber numberWithInt:kVPNSeq],
    @"BlackList": [NSNumber numberWithInt:kBlackListSeq]
};

@interface PolicyCheckerViewController ()
@property (weak) IBOutlet NSComboBox *serverCombo;
@property (weak) IBOutlet NSComboBox *policyFileCombo;
@property (weak) IBOutlet NSComboBox *appkeyCombo;
@property (weak) IBOutlet NSTextField *policyURLTextField;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (weak) IBOutlet NSComboBox *ruleGroupSeqCombo;
@property (weak) IBOutlet NSTextField *userIdTextField;
@property (weak) IBOutlet NSTextField *deviceIdTextField;

@end

@implementation PolicyCheckerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.serverCombo selectItemAtIndex:0];
    [self.policyFileCombo selectItemAtIndex:0];
    [self setPolicyURLTextField];
    
    for(NSString* seqKey in AGRuleGroupSeqDictionary) {
        [self.ruleGroupSeqCombo addItemWithObjectValue:seqKey];
    }
    [self.ruleGroupSeqCombo selectItemAtIndex:0];
    
    [self.appkeyCombo addItemWithObjectValue:@"RJbjBOxk4vT4ROwZ"];
    [self.appkeyCombo addItemWithObjectValue:@"8R8kdbhCJRYHWbCj"];
    [self.appkeyCombo addItemWithObjectValue:@"hpgTUUMpwOqrrOtW"];
    [self.appkeyCombo addItemWithObjectValue:@"bMICt5To9z2xHbgA"];
    [self.appkeyCombo addItemWithObjectValue:@"txLfz4YXSuCYJrR4"];
    [self.appkeyCombo addItemWithObjectValue:@"IA6lhCiPj214HFl9"];
    [self.appkeyCombo selectItemAtIndex:0];
    [self appendOutputView:@"====== Appkey ======="];
    [self appendOutputView:@"Real key: RJbjBOxk4vT4ROwZ (구 유저 WDI_APPGUARD)"];
    [self appendOutputView:@"alpha key: 8R8kdbhCJRYHWbCj (구 유저)"];
    [self appendOutputView:@"beta key: hpgTUUMpwOqrrOtW (구 유저)"];
    [self appendOutputView:@"real(QA) key: bMICt5To9z2xHbgA"];
    [self appendOutputView:@"japan test key: txLfz4YXSuCYJrR4 (구 유저)"];
    [self appendOutputView:@"beta user: IA6lhCiPj214HFl9"];
    [self appendOutputView:@"====================="];
    
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    self.preferredContentSize = CGSizeMake(500, 600);
}

- (void)appendOutputView:(NSString*)log {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.outputTextView.string = [NSString stringWithFormat:@"%@%@\n", self.outputTextView.string, log];
        [self.outputTextView scrollRangeToVisible: NSMakeRange(self.outputTextView.string.length - 1, 1)];
    });
}

- (IBAction)onServerPolicyFileCombo:(id)sender {
    [self setPolicyURLTextField];
}

- (void)setPolicyURLTextField {
    NSString* server = self.serverCombo.stringValue;
    const NSString* policyFile = self.policyFileCombo.stringValue;
    server = @"";
    if(![self.serverCombo.stringValue isEqual:@"real"]) {
        server = @"/";
        server = [server stringByAppendingString:self.serverCombo.stringValue];
    }
    server = [server stringByAppendingString:@"/ios"];
    NSString* appKey = self.appkeyCombo.stringValue;
    if(appKey.length == 0) {
        appKey = @"{Insert Appkey}";
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@/%@/%@", gPolicyCDNDomain, server, appKey, policyFile];
    [self.policyURLTextField setStringValue:url];
}

- (void)requestPolicy {
    [self appendOutputView:[NSString stringWithFormat:@"[+] Request Policy"]];
    [self appendOutputView:[NSString stringWithFormat:@"url: %@",self.policyURLTextField.stringValue]];
    NSURL* url = [NSURL URLWithString:self.policyURLTextField.stringValue];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSession* sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if(error) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Policy Error.(error=%ld)", (long)error.code]];
            return;
        }
        
        if(data==nil) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Policy Error.(data=nil)"]];
            return;
        }
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*) response;
        if(httpResponse==nil) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Policy Error.(httpResponse=nil)"]];
            return;
        }
        
        NSInteger stCode = [httpResponse statusCode];
        [self appendOutputView:[NSString stringWithFormat:@"Request Policy http response code: %ld", stCode]];
        if(stCode != 200) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Policy Error.(status code=%lu)", stCode]];
            return;
        }
        
        NSString* contentType = httpResponse.allHeaderFields[@"content-type"];
        NSString* contentLength = httpResponse.allHeaderFields[@"content-length"];
        [self appendOutputView:[NSString stringWithFormat:@"content-type: %@", contentType]];
        [self appendOutputView:[NSString stringWithFormat:@"content-length: %@", contentLength]];
        
        Decryptor dec;
        NSString* decPolicy = dec.decryptData(reinterpret_cast<const char*>([data bytes]), [data length]);
        if(decPolicy == nil) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Policy Error.(Decoding policy is Fail."]];
            return;
        }
        [self appendOutputView:[NSString stringWithFormat:@"Decoded policy raw data: %@", decPolicy]];
        [self parsePolicyAndOutput: decPolicy];
        
    }];
    [dataTask resume];
}
- (void)parseJsonPolicy:(NSString*)decJsonPolicy {
    bool result = false;
    NSError *error = nil;
    NSData *jsonData = [decJsonPolicy dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        [self appendOutputView:[NSString stringWithFormat:@"Error while parsing JSON: %@", error]];
        return ;
    }
    

    NSString *version = jsonDict[@"version"];
    NSString *updatedDateTime = jsonDict[@"updatedDateTime"];
    NSString *appKey = jsonDict[@"appKey"];
    NSNumber *os = jsonDict[@"os"];
    NSString *uuid = jsonDict[@"uuid"];
    NSArray *ruleGroups = jsonDict[@"ruleGroups"];
    [self appendOutputView:[NSString stringWithFormat:@"Version: %@", version]];
    [self appendOutputView:[NSString stringWithFormat:@"Updated DateTime: %@", updatedDateTime]];
    [self appendOutputView:[NSString stringWithFormat:@"App Key: %@", appKey]];
    [self appendOutputView:[NSString stringWithFormat:@"OS: %@", os]];
    [self appendOutputView:[NSString stringWithFormat:@"UUID: %@", uuid]];

    for (NSDictionary *ruleGroup in ruleGroups) {
        // 각 ruleGroup의 "seq"와 "action" 키에 접근
        NSNumber *seq = ruleGroup[@"seq"];
        NSNumber *action = ruleGroup[@"action"];
        NSString *actionName = AGNewPolicyResponseTypeNameList[[action intValue]];
        switch ([seq intValue]) {
            case AGPatternGroupJailbreak:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupJailbreak, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupCheatingTool:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupCheatingTool, Action: %@ %@", seq, action, actionName]];
            
                break;
            case AGPatternGroupDebugger:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupDebugger, Action: %@ %@", seq, action, actionName]];
               
                break;
            case AGPatternGroupModification:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupModification, Action: %@ %@", seq, action, actionName]];
            
                break;
            case AGPatternGroupSimulator:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupSimulator, Action: %@ %@", seq, action, actionName]];
              
                break;
            case AGPatternGroupHooking:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupHooking, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupNetwork:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupNetwork, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupLocationSpoofing:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupLocationSpoofing, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupScreenCapture:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupScreenCapture, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupScreenRecord:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupScreenRecord, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupMacroTool:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupMacroTool, Action: %@ %@", seq, action, actionName]];
                break;
            case AGPatternGroupVPN:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ AGPatternGroupVPN, Action: %@ %@", seq, action, actionName]];
                break;
            default:
                [self appendOutputView:[NSString stringWithFormat:@"Seq: %@ Unknown, Action: %@ %@", seq, action, actionName]];
                break;
        
        }
    }

    return ;
    
}
- (NSArray*)parsePolicyAndOutput:(NSString*)decodedPolicy {
    
    if([decodedPolicy characterAtIndex:0] != '{') {
        NSArray * policyArray = [decodedPolicy componentsSeparatedByString:@":"];
        for(int i = kJailbreakIdx; i < policyArray.count; i++) {
            [self appendOutputView:[NSString stringWithFormat:@"- %@ : %@(%@)", AGPolicyTypeNameList[i],AGPolicyResponseTypeNameList[[ policyArray[i] intValue]], policyArray[i]]];
        }
    } else {
        [self appendOutputView:[NSString stringWithFormat:@"%@", decodedPolicy]];
        [self parseJsonPolicy: decodedPolicy];
    }
    return nil;
}

- (IBAction)onPolicyDownloadBtn:(id)sender {
    [self requestPolicy];
}

- (IBAction)onClearOutputBtn:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.outputTextView.string = @"";
        [self.outputTextView scrollRangeToVisible: NSMakeRange(self.outputTextView.string.length - 1, 1)];
    });
}

- (void)checkConditionalPolicy {
    [self appendOutputView:[NSString stringWithFormat:@"[+] Request Conditional Policy"]];
    NSString *appKey = self.appkeyCombo.stringValue;
    NSString *userId = self.userIdTextField.stringValue;
    NSString *deviceId = self.deviceIdTextField.stringValue;
    NSString *ruleGroupSeq = [NSString stringWithFormat:@"%@", AGRuleGroupSeqDictionary[self.ruleGroupSeqCombo.stringValue]];
    
    if(appKey.length == 0 ||
       userId.length == 0 ||
       deviceId.length == 0 ||
       ruleGroupSeq.length == 0
       ) {
        [self appendOutputView:[NSString stringWithFormat:@"Error appkey/userid/deviceId rule group seq is invalid"]];
        return;
    }
    
    PacketEncryptor packetEncryptor;
    
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    [contentDictionary setValue:packetEncryptor.encryptAndEncode(appKey) forKey:@"A"];
    [contentDictionary setValue:packetEncryptor.encryptAndEncode(userId) forKey:@"U"];
    [contentDictionary setValue:packetEncryptor.encryptAndEncode(deviceId) forKey:@"D"];
    [contentDictionary setValue:packetEncryptor.encryptAndEncode(ruleGroupSeq) forKey:@"R"];
    [contentDictionary setValue:packetEncryptor.encryptAndEncode(@"iOS") forKey:@"O"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *encodeJsonStr = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    [self appendOutputView:[NSString stringWithFormat:@"Request body json\n%@",jsonStr]];
    
    NSString* url = [NSString stringWithFormat:@"%@", gConditionalPolicyURL];
    if([self.serverCombo.stringValue isEqual:@"alpha"]) {
        url = [NSString stringWithFormat:@"%@", gAlphaConditionalPolicyURL];
    } else if ([self.serverCombo.stringValue isEqual:@"beta"]) {
        url = [NSString stringWithFormat:@"%@", gBetaConditionalPolicyURL];
    }
    
    NSLog(@"url: %@", url);
    [self appendOutputView:[NSString stringWithFormat:@"Request URL:%@",url]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:encodeJsonStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Conditional Policy Error.(error=%ld)", (long)error.code]];
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(response == nil) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Conditional Policy Error.(response==nil)"]];
            return;
        }
        
        if([httpResponse statusCode] != 200) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Conditional Policy Error.(status code == %ld)", [httpResponse statusCode]]];
            return;
        }
        
        [self appendOutputView:[NSString stringWithFormat:@"response json:\n %s)", (char*)[data bytes] ]];
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if(parseError) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Conditional Policy Error.(response json invalid == %s)", (char*)[data bytes] ]];
            return;
        }
        
        [self appendOutputView:[NSString stringWithFormat:@"response parsed json:\n %@)", responseDictionary]];
        
        
        [self appendOutputView:[NSString stringWithFormat:@"response decoded json:"]];
      
        PacketEncryptor packetEncryptor;
        NSString* ST = packetEncryptor.decryptAndDecode(responseDictionary[@"data"][@"ST"]);
        if(ST == nil) {
            [self appendOutputView:[NSString stringWithFormat:@"Request Conditional Policy Error.(can't find ST)"]];
            return;
        }
        [self appendOutputView:[NSString stringWithFormat:@"ST = %@", ST]];
        
        if([ST isEqual:@"BLOCK"]) {
            [self appendOutputView:[NSString stringWithFormat:@"RN = %@", packetEncryptor.decryptAndDecode(responseDictionary[@"data"][@"RN"])]];
            [self appendOutputView:[NSString stringWithFormat:@"RG = %@", packetEncryptor.decryptAndDecode(responseDictionary[@"data"][@"RG"])]];
            [self appendOutputView:[NSString stringWithFormat:@"BS = %@", packetEncryptor.decryptAndDecode(responseDictionary[@"data"][@"BS"])]];
        }
        
    }];
    [dataTask resume];
}

- (IBAction)onCheckConditionalPolicyBtn:(id)sender {
    [self checkConditionalPolicy];
}

@end
