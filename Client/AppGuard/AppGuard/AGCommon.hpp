//
//  AGCommon.h
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#ifndef AGCommon_h
#define AGCommon_h
#ifndef DEBUG
#define AG_PRIVATE_API __attribute__((visibility("hidden")))
#else
#define AG_PRIVATE_API
#endif

#endif /* AGCommon_h */
