//
//  Rednilb.h
//  AppGuard
//
//  Created by NHN on 9/13/24.
//

#ifndef Rednilb_h
#define Rednilb_h
#import <AppGuard/SymbolObfuscate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppGuardCoreBlinder : NSObject
+ (void)protectContent:(BOOL)active;
+ (void)protectSnapshot:(BOOL)active;
@end
#endif /* Rednilb_h */
