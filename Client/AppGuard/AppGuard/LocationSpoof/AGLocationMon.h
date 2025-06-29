//
//  AGLocationMon.h
//  AppGuard
//
//  Created by NHN on 4/22/24.
//

#ifndef AGLocationMon_h
#define AGLocationMon_h

#import <Foundation/Foundation.h>


@interface AGLocationMon : NSObject
+ (instancetype)shared;
+ (Coordinate)returnCoordinateInvokeWithTarget:(id)target selector:(SEL)selector;
+ (double)returnDoubleInvokeWithTarget:(id)target selector:(SEL)selector;
+ (BOOL)returnBoolInvokeWithTarget:(id)target selector:(SEL)selector;
+ (int)returnIntInvokeWithTarget:(id)target selector:(SEL)selector;
@end
#endif /* AGLocationMon_h */
