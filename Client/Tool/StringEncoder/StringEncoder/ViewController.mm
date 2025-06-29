//
//  ViewController.m
//  StringEncoder
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 NHNENT. All rights reserved.
//

#import "ViewController.h"
#include "StringEncode.hpp"

@implementation ViewController

- (IBAction)EncodeButton:(NSButton *)sender {
    NSLog(_plainTextField.stringValue);
    
    {
        NSLog(_keyTextField.stringValue);
        const char* key = [_keyTextField.stringValue UTF8String];
        const char* data = [_plainTextField.stringValue UTF8String];
        
        StringEncode strEnc;
        const char* encodedText = strEnc.textXOR(data, key);
        const char* hexText = strEnc.getHexCode();
        NSString *encText = [NSString stringWithUTF8String:encodedText];
        NSLog(encText);
        NSString *hexCode = [NSString stringWithUTF8String:hexText];
        NSLog(hexCode);
        _encodedTextField.stringValue = encText;
        _hexCodeField.stringValue = hexCode;
        
        NSString *nss = [NSString stringWithUTF8String:key];
        NSLog(nss);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
