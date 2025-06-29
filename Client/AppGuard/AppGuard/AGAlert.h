//
//  AGAlert.hpp
//  AppGuard
//
//  Created by HyupM1 on 2023/12/04.
//

#ifndef AGAlert_hpp
#define AGAlert_hpp

#include <stdio.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EncodedDatum.h"
#import "AGAlert.h"
#import "Pattern/Pattern.h"

#define AG_PLAIN_E_STRING(x) [[NSString alloc] initWithBytesNoCopy:(void *)&EncodedDatum::ePlain_[4][x] length:1 encoding:NSUTF8StringEncoding freeWhenDone:false]
#define AG_PLAIN_K_STRING(x) [[NSString alloc] initWithBytesNoCopy:(void *)EncodedDatum::kPlain_[x].string length:3 encoding:NSUTF8StringEncoding freeWhenDone:false]
#define AG_PLAIN_J_STRING(x) [[NSString alloc] initWithBytesNoCopy:(void *)EncodedDatum::jPlain_[x].string length:3 encoding:NSUTF8StringEncoding freeWhenDone:false]
#define AG_PLAIN_STRING(x) getMultilingualString(x)

NS_ASSUME_NONNULL_BEGIN

typedef void (^AGAlertAction)(void (^ __nullable)(void));

typedef NS_ENUM(int, AGAlertLanguage) {
    AGAlertLanguageKo = 0,
    AGAlertLanguageEn = 1,
    AGAlertLanguageJa = 2,
};

typedef NS_ENUM(int, AGStringType) {
    AGStringTypeMultilingual = 0,
    AGStringTypeKo = 1,
    AGStringTypeEn = 2,
    AGStringTypeJa = 3,
    AGStringTypePlain = 9,
};

class __attribute__((visibility("hidden"))) AGAlert {
public:
    AGAlert();
    ~AGAlert();
    
    void setup(UIViewController *vc);
    void setData(AGPatternGroup group, AGPatternName pattern);
private:
    AGPatternGroup group_;
    AGPatternName pattern_;
    AGAlertLanguage multilingual_;
    NSMutableArray *count_;
    
    int getGroupIndex();
    NSArray* title();
    NSArray* group();
    NSArray* detected();
    NSArray* codePrefix();
    NSArray* code();
    NSArray* description();
    NSArray* bottom();
    NSArray* confirm();
    
    NSString* getMultilingualString(int index);
    AGAlertLanguage getMultilingual();
    NSString* string(NSString *string, AGStringType type);
    
    void addArrangedSplitTextLabel(UIStackView *stackView, NSArray *array, UIFont *font, UIColor *color, AGStringType stringType);
    UIView* view(UIColor *color, double cornerRadius);
    UIStackView* stackView(UILayoutConstraintAxis axis);
    UILabel* label(UIFont *font, UIColor *color, NSString *message);   
};

NS_ASSUME_NONNULL_END


#endif /* AGAlert_hpp */
