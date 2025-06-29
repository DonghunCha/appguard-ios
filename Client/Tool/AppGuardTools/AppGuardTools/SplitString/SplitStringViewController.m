//
//  SplitStringViewController.m
//  AppGuardTools
//
//  Created by HyupM1 on 2023/12/18.
//

#import "SplitStringViewController.h"
#import "TextData.h"

@interface SplitStringViewController () <NSTextViewDelegate>
@property (weak) IBOutlet NSComboBox *languageCombobox;
@property (unsafe_unretained) IBOutlet NSTextView *originTextView;
@property (unsafe_unretained) IBOutlet NSTextView *byteTextView;
@property (unsafe_unretained) IBOutlet NSTextView *inputTextView;
@property (unsafe_unretained) IBOutlet NSTextView *splitTextView;
@property (unsafe_unretained) IBOutlet NSTextView *convertTextView;

@property (strong, nonatomic) NSArray *currentLanguage;

@end

@implementation SplitStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    self.preferredContentSize = CGSizeMake(800, 960);
    
    self.originTextView.delegate = self;
    self.byteTextView.delegate = self;
    self.inputTextView.delegate = self;
    self.splitTextView.delegate = self;
    self.convertTextView.delegate = self;
    
    self.inputTextView.editable = NO;
    self.inputTextView.string = @"언어선택 후 입력이 가능합니다.";
}

- (IBAction)comboBoxAction:(id)sender {
    NSLog(@"comboBox %@", self.languageCombobox.selectedCell.title);
    
    NSString *selected = self.languageCombobox.selectedCell.title;
    
    if ([selected isEqualToString:@"Korean"]) {
        self.currentLanguage = [TextData shared].ko;
        
        self.originTextView.string = [self stringWithOriginArray:self.currentLanguage];
        self.byteTextView.string = [TextData convert3ByteStringTable:self.currentLanguage];
        
        self.inputTextView.editable = YES;
        
        self.inputTextView.string = @"";
        self.splitTextView.string = @"";
        self.convertTextView.string = @"";
        
    } else if ([selected isEqualToString:@"English"]) {
        self.currentLanguage = [TextData shared].en;
        
        self.originTextView.string = [self stringWithOriginArray:self.currentLanguage];
        self.byteTextView.string = [TextData convert1ByteStringTable:self.currentLanguage];
        
        self.inputTextView.editable = YES;
        
        self.inputTextView.string = @"";
        self.splitTextView.string = @"";
        self.convertTextView.string = @"";
        
    } else if ([selected isEqualToString:@"Japanese"]) {
        self.currentLanguage = [TextData shared].ja;
        
        self.originTextView.string = [self stringWithOriginArray:self.currentLanguage];
        self.byteTextView.string = [TextData convert3ByteStringTable:self.currentLanguage];
        
        self.inputTextView.editable = YES;
        
        self.inputTextView.string = @"";
        self.splitTextView.string = @"";
        self.convertTextView.string = @"";
    } else {
        NSLog(@"Not Found Language");
    }
}


- (NSString *)stringWithOriginArray:(NSArray *)array {
    NSMutableString *string = [NSMutableString string];
    
    for (NSString *str in array) {
        [string appendFormat:@"[%@], ", str];
    }
    return string;
}


- (void)textDidChange:(NSNotification *)notification {
    
    NSString *identifier = [((NSTextView *)notification.object) identifier];
    NSLog(@"%@", identifier);
    
    if ([identifier isEqualToString:@"originTextView"]) {
        
    } else if ([identifier isEqualToString:@"byteTextView"]) {
        
    } else if ([identifier isEqualToString:@"inputTextView"]) {
        
        NSArray *stringArray = [TextData arrayFromString:self.inputTextView.string];
        NSString *printSplitArray =[TextData printStringArrayWithArray:stringArray];
        NSString *convertString = [TextData searchIndexWithArray:stringArray table:self.currentLanguage];
        
        self.splitTextView.string = printSplitArray;
        self.convertTextView.string = convertString;
        
        
    } else if ([identifier isEqualToString:@"splitTextView"]) {
        
    } else if ([identifier isEqualToString:@"convertTextView"]) {
        
    } else {
        NSLog(@"Not Found Text View");
    }
}

- (void)textDidEndEditing:(NSNotification *)notification {
    NSString *identifier = [((NSTextView *)notification.object) identifier];
    NSLog(@"end %@", identifier);
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    NSString *identifier = [((NSTextView *)notification.object) identifier];
    NSLog(@"begin %@", identifier);
    
    if ([identifier isEqualToString:@"originTextView"]) {
        
    } else if ([identifier isEqualToString:@"byteTextView"]) {
        
    } else if ([identifier isEqualToString:@"inputTextView"]) {
               
    } else if ([identifier isEqualToString:@"splitTextView"]) {
        
    } else if ([identifier isEqualToString:@"convertTextView"]) {
        
    } else {
        NSLog(@"Not Found Text View");
    }
}

@end
