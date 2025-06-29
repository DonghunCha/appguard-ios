//
//  TextData.h
//  AppGuardTools
//
//  Created by HyupM1 on 2023/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextData : NSObject



@property (strong, nonatomic) NSArray *ko;
@property (strong, nonatomic) NSArray *en;
@property (strong, nonatomic) NSArray *ja;

+ (instancetype)shared;

+ (NSString *)convert1ByteStringTable:(NSArray *)array;
+ (NSString *)convert3ByteStringTable:(NSArray *)array;

+ (NSArray *)arrayFromString:(NSString *)string;
+ (NSString *)printStringArrayWithArray:(NSArray *)array;

+ (NSString *)searchIndexWithArray:(NSArray *)array table:(NSArray *)table;

@end

NS_ASSUME_NONNULL_END
