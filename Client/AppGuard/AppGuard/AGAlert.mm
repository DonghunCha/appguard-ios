//
//  AGAlert.cpp
//  AppGuard
//
//  Created by HyupM1 on 2023/12/04.
//
#include "Pattern.h"
#include "AGAlert.h"
#import "ExitManager.hpp"

#define AG_ALERT_SIMPLE_MODE_SIGNATURE_MAX_LEN 256
typedef NS_ENUM(int, AGAlertMode) {
    AGAlertModeDetailed = 0,
    AGAlertModeSimple = 1
};
union AGAlertModeSignature {
    unsigned char rawData[AG_ALERT_SIMPLE_MODE_SIGNATURE_MAX_LEN];
    struct {
        char signature[68];
        AGAlertMode mode;
    };
};


__attribute__((visibility("hidden"))) static AGAlertMode checkDetectionAlertMode() {
    AGAlertModeSignature simpleModeSignature = {"8c0b3d90946ef07bb047f2cc35fb5ea7a4339d3353ae79173d35435fb38fdd8ce02879b4c5a8e4fdc7e1039700983441da8313b8566d588dd381d6a771e74992"};
    NSString* insertedSignature = [NSString stringWithUTF8String: simpleModeSignature.signature];
    if(insertedSignature)
    {
        if([insertedSignature isEqualToString: NS_SECURE_STRING(detection_alert_mode_replace_signature)])
        {
            if(simpleModeSignature.mode == AGAlertModeSimple)
            {
                AGLog(@"simple detection popup signature is updated.");
                return simpleModeSignature.mode;
            }
        }
    }
    return AGAlertModeDetailed;
}

__attribute__((visibility("hidden"))) static void ag_dispatch_async_repeated_internal(dispatch_time_t firstPopTime, double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop)) {
    __block BOOL shouldStop = NO;
    dispatch_time_t nextPopTime = dispatch_time(firstPopTime, (int64_t)(intervalInSeconds * NSEC_PER_SEC));
    dispatch_after(nextPopTime, queue, ^{
        work(&shouldStop);
        if(!shouldStop) {
            ag_dispatch_async_repeated_internal(nextPopTime, intervalInSeconds, queue, work);
        }
    });
}

__attribute__((visibility("hidden"))) void ag_dispatch_async_repeated(double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop)) {
    dispatch_time_t firstPopTime = dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC);
    ag_dispatch_async_repeated_internal(firstPopTime, intervalInSeconds, queue, work);
}

__attribute__((visibility("hidden")))AGAlert::AGAlert():group_(AGPatternGroupNone), pattern_(AGPatternNameNone) {
    
    //AGLog(@"%@", [[NSLocale preferredLanguages] firstObject]);
    
    if([[[[[NSLocale preferredLanguages] firstObject] componentsSeparatedByString:@"-"] firstObject] isEqualToString:@"ko"]) {
        multilingual_ = AGAlertLanguageKo;
        count_ = [NSMutableArray arrayWithObjects:@"2362", @"2361", @"2360", @"2359", @"2358", @"2357", @"2356", @"2355", @"2354", nil];
    } else if ([[[[[NSLocale preferredLanguages] firstObject] componentsSeparatedByString:@"-"] firstObject] isEqualToString:@"ja"]) {
        multilingual_ = AGAlertLanguageJa;
        count_ = [NSMutableArray arrayWithObjects:@"175", @"174", @"173", @"172", @"171", @"170", @"169", @"168", @"167", nil];
    } else {
        multilingual_ = AGAlertLanguageEn;
        count_ = [NSMutableArray arrayWithObjects:@"75", @"74", @"73", @"72", @"71", @"70", @"69", @"68", @"67", nil];
    }
}

__attribute__((visibility("hidden")))AGAlert::~AGAlert() {
    group_ = AGPatternGroupNone;
    pattern_ = AGPatternNameNone;
}

__attribute__((visibility("hidden")))NSString* AGAlert::getMultilingualString(int index) {
    if (multilingual_ == AGAlertLanguageKo) {
        return AG_PLAIN_K_STRING(index);
    } else if (multilingual_ == AGAlertLanguageJa) {
        return AG_PLAIN_J_STRING(index);
    } else {
        return AG_PLAIN_E_STRING(index);
    }
}

    __attribute__((visibility("hidden")))void AGAlert::setup(UIViewController *vc) {
    
    bool isSimpleAlert = checkDetectionAlertMode() == AGAlertModeSimple;

    vc.view.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.3];
    
    UIView *frameView = view([UIColor whiteColor], 28);
    [vc.view addSubview:frameView];
    
    frameView.translatesAutoresizingMaskIntoConstraints = NO;
    [frameView.widthAnchor constraintEqualToConstant:335].active = YES;
    
    if (getMultilingual() == AGAlertLanguageKo) {
        [frameView.heightAnchor constraintEqualToConstant:239 - (isSimpleAlert ? 24 : 0)].active = YES; // 239
    } else {
        [frameView.heightAnchor constraintEqualToConstant:261 - (isSimpleAlert ? 24 : 0)].active = YES; // 261
    }
    
    [frameView.centerXAnchor constraintEqualToAnchor:vc.view.centerXAnchor].active = YES;
    [frameView.centerYAnchor constraintEqualToAnchor:vc.view.centerYAnchor].active = YES;
    [frameView.leftAnchor constraintGreaterThanOrEqualToAnchor:vc.view.leftAnchor constant:20].active = YES;
    [frameView.rightAnchor constraintLessThanOrEqualToAnchor:vc.view.rightAnchor constant:-20].active = YES;
    
    
    UIStackView *titleStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:titleStackView];
    
    titleStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [titleStackView.heightAnchor constraintEqualToConstant: isSimpleAlert ? 0 : 24].active = YES;
    [titleStackView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [titleStackView.topAnchor constraintEqualToAnchor:frameView.topAnchor constant:24].active = YES;
    
    if(!isSimpleAlert) {
        addArrangedSplitTextLabel(titleStackView,
                                  title(),
                                  [UIFont systemFontOfSize:20 weight:UIFontWeightBold],
                                  [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1],
                                  AGStringTypeEn);
    }
    UIStackView *groupStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:groupStackView];
    
    groupStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [groupStackView.heightAnchor constraintEqualToConstant:22].active = YES;
    [groupStackView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [groupStackView.topAnchor constraintEqualToAnchor:titleStackView.bottomAnchor constant:8].active = YES;
    
    //TODO: 탐지 그룹은 영문으로만 출력할 수 있을 그 경우 수정 필요
    if(!isSimpleAlert) {
        addArrangedSplitTextLabel(groupStackView,
                                  [group() objectAtIndex:getGroupIndex()],
                                  [UIFont systemFontOfSize:14 weight:UIFontWeightBold],
                                  [UIColor colorWithRed:0.071 green:0.365 blue:0.902 alpha:1],
                                  AGStringTypeMultilingual);
        
        addArrangedSplitTextLabel(groupStackView,
                                  detected(),
                                  [UIFont systemFontOfSize:14 weight:UIFontWeightBold],
                                  [UIColor colorWithRed:0.079 green:0.275 blue:0.785 alpha:1],
                                  AGStringTypeMultilingual);
    }
 
   
    UIStackView *codeStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:codeStackView];
    codeStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [codeStackView.heightAnchor constraintEqualToConstant:26].active = YES;
    [codeStackView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [codeStackView.topAnchor constraintEqualToAnchor:groupStackView.bottomAnchor constant:0].active = YES;
    
    addArrangedSplitTextLabel(codeStackView,
                              codePrefix(),
                              [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                              [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1],
                              AGStringTypeMultilingual);
    
    addArrangedSplitTextLabel(codeStackView,
                              code(),
                              [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                              [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1],
                              AGStringTypePlain);
    
    UIStackView *descriptionStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:descriptionStackView];
    
    descriptionStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [descriptionStackView.heightAnchor constraintEqualToConstant: 22].active = YES;
    [descriptionStackView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [descriptionStackView.topAnchor constraintEqualToAnchor:codeStackView.bottomAnchor constant:8].active = YES;
    
    if (getMultilingual() == AGAlertLanguageKo) {
        addArrangedSplitTextLabel(descriptionStackView,
                                  description(),
                                  [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                  [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1],
                                  AGStringTypeMultilingual);
        
    } else {
        NSRange firstRange;
        NSRange secondRange;
        
        if (getMultilingual() == AGAlertLanguageEn) {
            firstRange = NSMakeRange(0, 35);
            secondRange = NSMakeRange(35, 32);
        } else if (getMultilingual() == AGAlertLanguageJa) {
            firstRange = NSMakeRange(0, 14);
            secondRange = NSMakeRange(14, 15);
        }
        
        addArrangedSplitTextLabel(descriptionStackView,
                                  [description() subarrayWithRange:firstRange],
                                  [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                  [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1],
                                  AGStringTypeMultilingual);
        
        [[[descriptionStackView subviews] firstObject] setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [[[descriptionStackView subviews] lastObject] setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        
        UIStackView *descriptionStackView_additionalLine = stackView(UILayoutConstraintAxisHorizontal);
        [frameView addSubview:descriptionStackView_additionalLine];
        
        descriptionStackView_additionalLine.translatesAutoresizingMaskIntoConstraints = NO;
        [descriptionStackView_additionalLine.heightAnchor constraintEqualToConstant: 22].active = YES;
        [descriptionStackView_additionalLine.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
        [descriptionStackView_additionalLine.topAnchor constraintEqualToAnchor:descriptionStackView.bottomAnchor constant:0].active = YES;
        
        addArrangedSplitTextLabel(descriptionStackView_additionalLine,
                                  [description() subarrayWithRange:secondRange],
                                  [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                  [UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1],
                                  AGStringTypeMultilingual);
        
        [[[descriptionStackView_additionalLine subviews] lastObject] setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    
    UIStackView *bottomStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:bottomStackView];
    
    bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomStackView.heightAnchor constraintEqualToConstant:19].active = YES;
    [bottomStackView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    if (getMultilingual() == AGAlertLanguageKo)  {
        [bottomStackView.topAnchor constraintEqualToAnchor:descriptionStackView.bottomAnchor constant:4].active = YES;
    } else {
        [bottomStackView.topAnchor constraintEqualToAnchor:descriptionStackView.bottomAnchor constant:4+22].active = YES;
    }
    
    if(!isSimpleAlert) {
        addArrangedSplitTextLabel(bottomStackView,
                                  bottom(),
                                  [UIFont systemFontOfSize:12 weight:UIFontWeightRegular],
                                  [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1],
                                  AGStringTypeEn);
    }
    UIView *buttonView = view([UIColor colorWithRed:0.071 green:0.365 blue:0.902 alpha:1], 21);
    [frameView addSubview:buttonView];
    
    buttonView.translatesAutoresizingMaskIntoConstraints = NO;
    [buttonView.widthAnchor constraintEqualToConstant:111].active = YES;
    [buttonView.heightAnchor constraintEqualToConstant:42].active = YES;
    [buttonView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [buttonView.topAnchor constraintEqualToAnchor:bottomStackView.bottomAnchor constant:16].active = YES;
    [buttonView.bottomAnchor constraintEqualToAnchor:frameView.bottomAnchor constant:-24].active = YES;
    
    UIStackView *buttonStackView = stackView(UILayoutConstraintAxisHorizontal);
    [frameView addSubview:buttonStackView];
    
    buttonStackView.translatesAutoresizingMaskIntoConstraints = NO;
    if (getMultilingual() == AGAlertLanguageKo || getMultilingual() == AGAlertLanguageJa) {
        [buttonStackView.leftAnchor constraintEqualToAnchor:buttonView.leftAnchor constant:36].active = YES;
        [buttonStackView.rightAnchor constraintEqualToAnchor:buttonView.rightAnchor constant:-36].active = YES;
    } else {
        [buttonStackView.leftAnchor constraintEqualToAnchor:buttonView.leftAnchor constant:18].active = YES;
        [buttonStackView.rightAnchor constraintEqualToAnchor:buttonView.rightAnchor constant:-18].active = YES;
    }
    
    [buttonStackView.topAnchor constraintEqualToAnchor:buttonView.topAnchor constant:6].active = YES;
    [buttonStackView.bottomAnchor constraintEqualToAnchor:buttonView.bottomAnchor constant:-6].active = YES;
    
    addArrangedSplitTextLabel(buttonStackView,
                              confirm(),
                              [UIFont systemFontOfSize:14 weight:UIFontWeightBold],
                              [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
                              AGStringTypeMultilingual);
    
    [[[buttonStackView subviews] lastObject] setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    ag_dispatch_async_repeated_internal(DISPATCH_TIME_NOW, 1, dispatch_get_main_queue(), ^(BOOL *stop) {
        if (count_.count > 0) {
            UILabel *countLabel = [[buttonStackView subviews] lastObject];
            
            countLabel.text = AG_PLAIN_STRING([[count_ firstObject] intValue]);
            [count_ removeObjectAtIndex:0];
        } else {
            *stop = YES;
#if defined __arm64__ || defined __arm64e__
            __asm __volatile("mov x0, #0");
            __asm __volatile("mul x0, x0, x0");
            __asm __volatile("mov w1, #0");
            __asm __volatile("mov w2, #1");
            __asm __volatile("add w3, w2, w1");
            __asm __volatile("mov w16, w3");
            __asm __volatile("svc #0x80");
#endif
            
            STInstance(ExitManager)->callExit(); // 종료
            makeCrash();
        }
    });
    
    UITapGestureRecognizer *alertGestureRecognizer = [[UITapGestureRecognizer alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // AlertViewController에 atOnce가 없을 경우 Not Found Selector Error 로 Crash 발생
    [alertGestureRecognizer addTarget:vc action:@selector(atOnce)];
#pragma clang diagnostic pop
            
    UIView *eventView = view([UIColor clearColor], 21);
    [frameView addSubview:eventView];
    eventView.translatesAutoresizingMaskIntoConstraints = NO;
    [eventView.widthAnchor constraintEqualToConstant:111].active = YES;
    [eventView.heightAnchor constraintEqualToConstant:42].active = YES;
    [eventView.centerXAnchor constraintEqualToAnchor:frameView.centerXAnchor].active = YES;
    [eventView.topAnchor constraintEqualToAnchor:bottomStackView.bottomAnchor constant:16].active = YES;
    
    [eventView setUserInteractionEnabled:YES];
    [eventView addGestureRecognizer:alertGestureRecognizer];
}

#pragma mark - UI Component

__attribute__((visibility("hidden")))UIView* AGAlert::view(UIColor *color, double cornerRadius) {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.layer.cornerRadius = cornerRadius;
    
    return view;
}
__attribute__((visibility("hidden")))UIStackView* AGAlert::stackView(UILayoutConstraintAxis axis) {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.backgroundColor = [UIColor clearColor];
    stackView.axis = axis;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    stackView.layoutMarginsRelativeArrangement = YES;
    stackView.spacing = 0;
    return stackView;
}

__attribute__((visibility("hidden")))UILabel* AGAlert::label(UIFont *font, UIColor *color, NSString *message) {
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    return label;
}


__attribute__((visibility("hidden")))void AGAlert::addArrangedSplitTextLabel(UIStackView *stackView, NSArray *array, UIFont *font, UIColor *color, AGStringType stringType) {
    for ( NSString *str in array ) {
        UILabel *splitLabel = label(font,
                                    color,
                                    string(str, stringType));
        [stackView addArrangedSubview:splitLabel];
    }
}


__attribute__((visibility("hidden")))NSString* AGAlert::string(NSString *string, AGStringType type) {
    if (type == AGStringTypeMultilingual){ // multi
        return AG_PLAIN_STRING([string intValue]);
    } else if (type == AGStringTypeKo) { // ko
        return AG_PLAIN_K_STRING([string intValue]);
    } else if (type == AGStringTypeEn) { // en
        return AG_PLAIN_E_STRING([string intValue]);
    } else if (type == AGStringTypeJa) { // ja
        return AG_PLAIN_J_STRING([string intValue]);
    } else { //plain
        return string;
    }
}


#pragma mark - Data

__attribute__((visibility("hidden")))void AGAlert::setData(AGPatternGroup group, AGPatternName pattern) {
    group_ = group;
    pattern_ = pattern;
    
}

__attribute__((visibility("hidden")))AGAlertLanguage AGAlert::getMultilingual() {
    return multilingual_;
}

__attribute__((visibility("hidden")))int AGAlert::getGroupIndex() {
    switch (group_) {
        case AGPatternGroupRegisterCallback:
            return 0;
        case AGPatternGroupBehavior:
            return 1;
        case AGPatternGroupCheatingTool:
            return 2;
        case AGPatternGroupSimulator:
            return 3;
        case AGPatternGroupModification:
            return 4;
        case AGPatternGroupDebugger:
            return 5;
        case AGPatternGroupNetwork:
            return 6;
        case AGPatternGroupJailbreak:
            return 7;
        case AGPatternGroupHooking:
            return 8;
        case AGPatternGroupBlackList:
            return 9;
        case AGPatternGroupLocationSpoofing:
            return 10;
        case AGPatternGroupScreenCapture:
            return 11;
        case AGPatternGroupScreenRecord:
            return 12;
        case AGPatternGroupMacroTool:
            return 13;
        case AGPatternGroupVPN:
            return 14;
        default:
            return 1;
    }
}
__attribute__((visibility("hidden")))NSArray* AGAlert::title() {
    // Security Warning
    return [NSArray arrayWithObjects:@"56", @"44", @"4", @"2", @"20", @"17", @"8", @"19", @"24", @"56", @"48", @"0", @"17", @"13", @"8", @"13", @"6", @"56", nil];
}

//TODO: 탐지 그룹은 영문으로만 출력할 수 있을 그 경우 수정 필요
__attribute__((visibility("hidden")))NSArray* AGAlert::group() {
    if (multilingual_ == AGAlertLanguageKo) {
        // [콜백등록]
        NSArray *registerCallback = [NSArray arrayWithObjects:@"2352", @"2365", @"1940", @"918", @"547", @"704", @"2366", @"2352", nil];
        // [이상행동]
        NSArray *behavior = [NSArray arrayWithObjects:@"2352", @"2365", @"1547", @"1116", @"2225", @"500", @"2366", @"2352", nil];
        // [치팅 툴]
        NSArray *cheatingTool = [NSArray arrayWithObjects:@"2352", @"2365", @"1880", @"2102", @"2352", @"2061", @"2366", @"2352", nil];
        // [에뮬레이터]
        NSArray *simulator = [NSArray arrayWithObjects:@"2352", @"2365", @"1410", @"881", @"682", @"1547", @"2018", @"2366", @"2352", nil];
        // [변조]
        NSArray *modification = [NSArray arrayWithObjects:@"2352", @"2365", @"954", @"1619", @"2366", @"2352", nil];
        // [디버거]
        NSArray *debugger = [NSArray arrayWithObjects:@"2352", @"2365", @"549", @"931", @"36", @"2366", @"2352", nil];
        // [비정상 네트워크] -> [MITM]
        NSArray *network = [NSArray arrayWithObjects:@"2352", @"2365", @"2413", @"2409", @"2420", @"2413", @"2366", @"2352", nil];
        // [탈옥]
        NSArray *jailbreak = [NSArray arrayWithObjects:@"2352", @"2365", @"2000", @"1442", @"2366", @"2352", nil];
        // [후킹]
        NSArray *hooking = [NSArray arrayWithObjects:@"2352", @"2365", @"2291", @"1996", @"2366", @"2352", nil];
        // [블랙리스트]
        NSArray *blackList = [NSArray arrayWithObjects:@"2352", @"2365", @"1016", @"659", @"765", @"1247", @"2081", @"2366", @"2352", nil];
        // [위치 조작]
        NSArray *locationSpoof = [NSArray arrayWithObjects:@"2352", @"2365", @"1510", @"1880", @"2352", @"1619", @"1562", @"2366", @"2352", nil];
        // [화면 캡처]
        NSArray *screenCapture = [NSArray arrayWithObjects:@"2365", @"2268", @"824", @"2352", @"1903", @"1804", @"2366", nil];
        // [화면 녹화]
        NSArray *screenRecord = [NSArray arrayWithObjects:@"2365", @"2268", @"824", @"2352", @"357", @"2268", @"2366", nil];
        // [매크로툴]
        NSArray *macroTool = [NSArray arrayWithObjects:@"2365", @"2352", @"788", @"1982", @"703", @"2061", @"2352", @"2366", nil];
        // [VPN]
        NSArray *vpn = [NSArray arrayWithObjects:@"2352", @"2365", @"2422", @"2416", @"2414", @"2366", @"2352", nil];
        return [NSArray arrayWithObjects:registerCallback, behavior, cheatingTool, simulator, modification, debugger, network, jailbreak, hooking, blackList, locationSpoof, screenCapture, screenRecord, macroTool, vpn, nil];
    } else if (multilingual_ == AGAlertLanguageJa) {
        // [Callback]
        NSArray *registerCallback = [NSArray arrayWithObjects:@"154", @"148", @"205", @"177", @"188", @"188", @"178", @"177", @"179", @"187", @"149", @"154", nil];
        // [Behavior]
        NSArray *behavior = [NSArray arrayWithObjects:@"154", @"148", @"204", @"181", @"184", @"177", @"198", @"185", @"191", @"194", @"149", @"154", nil];
        // [チートツール]
        NSArray *cheatingTool = [NSArray arrayWithObjects:@"154", @"148", @"90", @"153", @"93", @"91", @"153", @"116", @"149", @"154", nil];
        // [エミュレータ]
        NSArray *simulator = [NSArray arrayWithObjects:@"154", @"148", @"77", @"107", @"146", @"117", @"153", @"89", @"149", @"154", nil];
        // [改ざん]
        NSArray *modification = [NSArray arrayWithObjects:@"154", @"148", @"229", @"54", @"48", @"149", @"154", nil];
        // [Network] -> [MITM]
        NSArray *network = [NSArray arrayWithObjects:@"154", @"148", @"215", @"211", @"222", @"215", @"149", @"154", nil];
        // [デバッガ]
        NSArray *debugger = [NSArray arrayWithObjects:@"154", @"148", @"135", @"137", @"230", @"122", @"149", @"154", nil];
        // [脱獄]
        NSArray *jailbreak = [NSArray arrayWithObjects:@"154", @"148", @"231", @"232", @"149", @"154", nil];
        // [フッキング]
        NSArray *hooking = [NSArray arrayWithObjects:@"154", @"148", @"103", @"230", @"80", @"121", @"124", @"149", @"154", nil];
        // [ブラックリスト]
        NSArray *blackList = [NSArray arrayWithObjects:@"154", @"148", @"139", @"114", @"230", @"81", @"115", @"86", @"93", @"149", @"154", nil];
        // [位置操作]
        NSArray *locationSpoof = [NSArray arrayWithObjects:@"154", @"148", @"233", @"234", @"235", @"236", @"149", @"154", nil];
        
        // [画面キャプチャ]
        NSArray *screenCapture = [NSArray arrayWithObjects:@"148", @"237", @"238", @"80", @"99", @"144", @"90", @"99", @"149", nil];
        // [画面録画]
        NSArray *screenRecord = [NSArray arrayWithObjects:@"148", @"237", @"238", @"239", @"237", @"149", nil];
        // [マクロツール]
        NSArray* macroTool = [NSArray arrayWithObjects:@"154", @"148", @"106", @"81", @"118", @"91", @"153", @"116", @"149", @"154", nil];
        // [VPN]
        NSArray *vpn = [NSArray arrayWithObjects:@"148", @"237", @"238", @"239", @"237", @"149", nil];
        return [NSArray arrayWithObjects:registerCallback, behavior, cheatingTool, simulator, modification, debugger, network, jailbreak, hooking, blackList, locationSpoof, screenCapture, screenRecord, macroTool, vpn, nil];

    } else {
        // [Callback]
        NSArray *registerCallback = [NSArray arrayWithObjects:@"56", @"52", @"28", @"0", @"11", @"11", @"1", @"0", @"2", @"10", @"53", @"56", nil];
        // [Behavior]
        NSArray *behavior = [NSArray arrayWithObjects:@"56", @"52", @"27", @"4", @"7", @"0", @"21", @"8", @"14", @"17", @"53", @"56", nil];
        // [Cheating Tool]
        NSArray *cheatingTool = [NSArray arrayWithObjects:@"56", @"52", @"28", @"7", @"4", @"0", @"19", @"8", @"13", @"6", @"56", @"45", @"14", @"14", @"11", @"53", @"56", nil];
        // [Emulator]
        NSArray *simulator = [NSArray arrayWithObjects:@"56", @"52", @"30", @"12", @"20", @"11", @"0", @"19", @"14", @"17", @"53", @"56", nil];
        // [Tampering]
        NSArray *modification = [NSArray arrayWithObjects:@"56", @"52", @"45", @"0", @"12", @"15", @"4", @"17", @"8", @"13", @"6", @"53", @"56", nil];
        // [Debugger]
        NSArray *debugger = [NSArray arrayWithObjects:@"56", @"52", @"29", @"4", @"1", @"20", @"6", @"6", @"4", @"17", @"53", @"56", nil];
        // [Network] -> [MITM]
        NSArray *network = [NSArray arrayWithObjects:@"56", @"52", @"38", @"34", @"45", @"38", @"53", @"56", nil];
        // [Jailbreak]
        NSArray *jailbreak = [NSArray arrayWithObjects:@"56", @"52", @"35", @"0", @"8", @"11", @"1", @"17", @"4", @"0", @"10", @"53", @"56", nil];
        // [Hooking]
        NSArray *hooking = [NSArray arrayWithObjects:@"56", @"52", @"33", @"14", @"14", @"10", @"8", @"13", @"6", @"53", @"56", nil];
        // [Blacklist]
        NSArray *blackList = [NSArray arrayWithObjects:@"56", @"52", @"27", @"11", @"0", @"2", @"10", @"11", @"8", @"18", @"19", @"53", @"56", nil];
        // [Location Spoofing]
        NSArray *locationSpoof = [NSArray arrayWithObjects:@"56", @"52", @"37", @"14", @"2", @"0", @"19", @"8", @"14", @"13", @"56", @"44", @"15", @"14", @"14", @"5", @"8", @"13", @"6", @"53", @"56", nil];
        // [Screen Capture]
        NSArray *screenCapture = [NSArray arrayWithObjects:@"56",@"52", @"44", @"2", @"17", @"4", @"4", @"13", @"56", @"28", @"0", @"15", @"19", @"20", @"17", @"4", @"53", @"56", nil];
        // [Screen Record]
        NSArray *screenRecord = [NSArray arrayWithObjects:@"56", @"52", @"44", @"2", @"17", @"4", @"4", @"13", @"56", @"43", @"4", @"2", @"14", @"17", @"3", @"53", @"56", nil];
        // [MacroTool]
        NSArray *macroTool = [NSArray arrayWithObjects:@"56", @"52", @"38", @"0", @"2", @"17", @"14", @"45", @"14", @"14", @"11", @"53", @"56", nil];
        //[VPN]
        NSArray *vpn = [NSArray arrayWithObjects:@"56", @"52", @"47", @"41", @"39", @"53", @"56", nil];
        return [NSArray arrayWithObjects:registerCallback, behavior, cheatingTool, simulator, modification, debugger, network, jailbreak, hooking, blackList, locationSpoof, screenCapture, screenRecord, macroTool, vpn, nil];
    }
}

__attribute__((visibility("hidden")))NSArray* AGAlert::detected() {
    if (multilingual_ == AGAlertLanguageKo) {
        // 탐지
        return [NSArray arrayWithObjects:@"2002", @"1683", @"2352", nil];
    } else if (multilingual_ == AGAlertLanguageJa) {
        // 検出
        return [NSArray arrayWithObjects:@"154", @"164", @"165", @"154", nil];
    } else {
        // Detected
        return [NSArray arrayWithObjects:@"29", @"4", @"19", @"4", @"2", @"19", @"4", @"3", @"56", nil];
    }
}

__attribute__((visibility("hidden")))NSArray* AGAlert::codePrefix() {
    if (multilingual_ == AGAlertLanguageKo) {
        // 코드 :
        return [NSArray arrayWithObjects:@"2352", @"1937", @"538", @"2353", @"2352", nil];
    }else if (multilingual_ == AGAlertLanguageJa) {
        // コード:
        return [NSArray arrayWithObjects:@"154", @"83", @"153", @"136", @"151", @"154", nil];
    } else {
        // Code :
        return [NSArray arrayWithObjects:@"56", @"28", @"14", @"3", @"4", @"64", @"56", nil];
    }
}

__attribute__((visibility("hidden")))NSArray* AGAlert::code() {
    int code = group_ * 10000 + pattern_;
    BOOL negative = NO;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (code < 0) {
        code *= -1;
        negative = YES;
    }
    
    while(code > 0) {
        int split = code % 10;
        [array addObject:[NSString stringWithFormat:@"%d", split]];
        code /= 10;
    }
    
    if (negative) {
        [array addObject:[NSString stringWithFormat:@"-"]];
    }
    
    group_ = AGPatternGroupNone;
    pattern_ = AGPatternNameNone;
    code = 0;
    negative = NO;
    
    return [NSArray arrayWithArray:[[array reverseObjectEnumerator] allObjects]];
}

__attribute__((visibility("hidden")))NSArray* AGAlert::description() {
    if (multilingual_ == AGAlertLanguageKo) {
        // 애플리케이션이 보안 정책에 따라 종료됩니다.
        return [NSArray arrayWithObjects:@"2352", @"1369", @"2196", @"765", @"1920", @"1547", @"1166", @"1547", @"2352", @"963", @"1355", @"2352", @"1601", @"1790", @"1410", @"2352", @"560", @"646", @"2352", @"1627", @"722", @"512", @"422", @"432", @"2350", @"2352", nil];
    } else if (multilingual_ == AGAlertLanguageJa) {
        // セキュリティポリシーにより、アプリケーションが終了します。
        return [NSArray arrayWithObjects:@"87", @"80", @"146", @"115", @"92", @"147", @"155", @"115", @"85", @"153", @"24", @"40", @"42", @"152", @"74", @"144", @"115", @"82", @"153", @"85", @"100", @"121", @"49", @"160", @"166", @"14", @"33", @"15", @"150", nil];
    } else {
        // The application will be shut down according to the security policy.
        return [NSArray arrayWithObjects:@"56", @"45", @"7", @"4", @"56", @"0", @"15", @"15", @"11", @"8", @"2", @"0", @"19", @"8", @"14", @"13", @"56", @"22", @"8", @"11", @"11", @"56", @"1", @"4", @"56", @"18", @"7", @"20", @"19", @"56", @"3", @"14", @"22", @"13", @"56", @"0", @"2", @"2", @"14", @"17", @"3", @"8", @"13", @"6", @"56", @"19", @"14", @"56", @"19", @"7", @"4", @"56", @"18", @"2", @"20", @"17", @"8", @"19", @"24", @"56", @"15", @"14", @"11", @"8", @"2", @"24", @"54", @"56", nil];
    }
}

__attribute__((visibility("hidden")))NSArray* AGAlert::bottom() {
    // Secured by NHN AppGuard
    return [NSArray arrayWithObjects:@"56", @"44", @"4", @"2", @"20", @"17", @"4", @"3", @"56", @"1", @"24", @"56", @"39", @"33", @"39", @"56", @"26", @"15", @"15", @"32", @"20", @"0", @"17", @"3", @"56", nil];
    
}

__attribute__((visibility("hidden")))NSArray* AGAlert::confirm() {
 
    if (multilingual_ == AGAlertLanguageKo) {
        // 확인 9
        return [NSArray arrayWithObjects:@"2269", @"1549", @"2352", @"2363", nil];
    } else if (multilingual_ == AGAlertLanguageJa) {
        // 確認 9
        return [NSArray arrayWithObjects:@"156", @"157", @"154", @"176", nil];
    } else {
        // OK 9
        //return [NSArray arrayWithObjects:@"40", @"36", @"56", @"76", nil];
        // Confirm 9
        return [NSArray arrayWithObjects:@"28", @"14", @"13", @"5", @"8", @"17", @"12", @"56", @"76", nil];
    }
}

