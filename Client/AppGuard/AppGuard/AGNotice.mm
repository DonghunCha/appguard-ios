//
//  AGNotice.m
//  AppGuard
//
//  Created by HyupM1 on 2023/12/04.
//

#import "AGNotice.h"
#import "Singleton.hpp"
#import "ExitManager.hpp"

__attribute__((visibility("hidden")))@implementation AGNotice

- (instancetype)init {
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    STInstance(AGAlert)->setup(self);
}

- (void)atOnce {
    
    AGLog(@"Alert Event");
    
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

@end
