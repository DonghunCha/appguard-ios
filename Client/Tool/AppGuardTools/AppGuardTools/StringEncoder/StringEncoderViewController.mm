//
//  StringEncoderViewController.m
//  AppGuardTools
//
//  Created by NHN on 2023/01/31.
//

#import "StringEncoderViewController.hpp"
#import "StringEncode.hpp"
#import "ASString.h"

@interface StringEncoderViewController ()

@property (weak) IBOutlet NSTextField *plainTextField;
@property (weak) IBOutlet NSTextField *encodedTextField;
@property (weak) IBOutlet NSTextField *hexCodeField;
@property (weak) IBOutlet NSTextField *decodeTextField;
@property (weak) IBOutlet NSTextField *keyTextField;

@end

@implementation StringEncoderViewController

- (void) viewWillAppear
{
    [super viewWillAppear];
    self.preferredContentSize = CGSizeMake(600, 300);
}
- (IBAction)EncodeButton:(NSButton *)sender {
    NSLog(@"%@", _plainTextField.stringValue);
    {
        NSLog(@"%@", _keyTextField.stringValue);
        const char* key = [_keyTextField.stringValue UTF8String];
        const char* data = [_plainTextField.stringValue UTF8String];
        
        StringEncode strEnc;
        const char* encodedText = strEnc.textXOR(data, key);
        if(encodedText == nullptr) {
            [self doOkAlert:@"Key is invalid."];
            return;
        }
        const char* hexText = strEnc.getHexCode();
        NSString *encText = [NSString stringWithUTF8String:encodedText];
        NSLog(@"%@", encText);
        NSString *hexCode = [NSString stringWithUTF8String:hexText];
        NSLog(@"%@", hexCode);
        _encodedTextField.stringValue = encText;
        _hexCodeField.stringValue = hexCode;
        
        NSString *nss = [NSString stringWithUTF8String:key];
        NSLog(@"%@", nss);
        
        [self SetDecodeText];
        
        if([_plainTextField.stringValue isEqual:_decodeTextField.stringValue] == NO) {
            [self doOkAlert:@"Plain Text and Decoded Text is not same."];
            return;
        }
        
    }
}

- (IBAction)KeyValidationButton:(id)sender {
    const char* key = [_keyTextField.stringValue UTF8String];
    const char* data = [_plainTextField.stringValue UTF8String];
    StringEncode strEnc;
    
    if(strEnc.isKeyValid(data, key)) {
        [self doOkAlert:@"Key is valid."];
    } else {
        [self doOkAlert:@"Key is invalid."];
    }
}

- (void)doOkAlert:(NSString*)messageText {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:messageText];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
}

- (void)SetDecodeText {
    const char* key = [_keyTextField.stringValue UTF8String];
    const char* encText = [_encodedTextField.stringValue UTF8String];
        
    ASString asStr(key, encText);
    
    _decodeTextField.stringValue =  [NSString stringWithUTF8String:asStr.getString()];

}

@end
