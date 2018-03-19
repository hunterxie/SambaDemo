//
//  FastCodeHeader.h
//  LoveWatchProject
//
//  Created by xll on 2017/10/18.
//  Copyright © 2017年 xll. All rights reserved.
//

#ifndef FastCodeHeader_h
#define FastCodeHeader_h


//-----------------------------------------------------------------------------//
//WEAK STRONG SELF
#define WEAK_SELF                   __weak   typeof(self) weakSelf  = self ;
#define STRONG_SELF                 __strong typeof(weakSelf) self  = weakSelf ;
//-----------------------------------------------------------------------------//
//SINGLETON
//.HEADER
#undef AS_SINGLETON
#define AS_SINGLETON(__class)                                       \
+ (__class *)sharedInstance ;
//.IMPLEMENTATION
#undef DEF_SINGLETON
#define DEF_SINGLETON(__class)                                      \
+ (__class *)sharedInstance                                         \
{                                                                   \
static dispatch_once_t once ;                                       \
static __class *__singleton__ ;                                     \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init];});  \
return __singleton__ ;                                              \
}
//-----------------------------------------------------------------------------//
//STRING FORMAT
#define STR_FORMAT(format, ...)     [NSString stringWithFormat:(format), ##__VA_ARGS__]
//-----------------------------------------------------------------------------//



#endif /* FastCodeHeader_h */
