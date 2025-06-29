//
//  AGAttacker.h
//  Appguard-Sample-OjbC
//
//  Created by NHN on 2023/04/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGAttacker : NSObject
+ (BOOL)binaryPatchAttack;
+ (int)findSubstrateIndex;
+ (BOOL)hookingAttack;
@end

NS_ASSUME_NONNULL_END
