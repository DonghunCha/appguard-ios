//
//  ViewController.h
//  StringEncoder
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 NHNENT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *plainTextField;
@property (weak) IBOutlet NSTextField *encodedTextField;
@property (weak) IBOutlet NSTextField *hexCodeField;
@property (weak) IBOutlet NSTextField *decodeTextField;
@property (weak) IBOutlet NSTextField *keyTextField;

@end

