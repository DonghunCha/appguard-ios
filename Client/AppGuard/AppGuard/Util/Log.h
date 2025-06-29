//
//  Log.h
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 4..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef Log_h
#define Log_h

#ifdef DEBUG
//#define AGLog( s, ... ) NSLog( @"[%@ %s(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define AGLog( s, ... ) NSLog( @"[AppGuard] [%@->%s] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __func__ , [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define AGLog( s, ... )
#endif

#ifdef TEST
//#define AGLog( s, ... ) NSLog( @"[%@ %s(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define TLog( s, ... ) NSLog( @"[TEST] [%@->%s] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __func__ , [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define TLog( s, ... )
#endif

#endif /* Log_h */
