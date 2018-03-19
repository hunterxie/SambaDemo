//
//  SystemDeviceHeader.h
//  LoveWatchProject
//
//  Created by xll on 2017/10/18.
//  Copyright © 2017年 xll. All rights reserved.
//

#ifndef SystemDeviceHeader_h
#define SystemDeviceHeader_h


#define IOS(a) ([[[UIDevice currentDevice] systemVersion] intValue] >= a)

/*****是否是3.5的尺寸*/
//宽320
#define is3_5Inch  ([UIScreen mainScreen].bounds.size.height == 480.0)
/**是否4寸屏*/
#define is4Inch  ([UIScreen mainScreen].bounds.size.height == 568.0)
/**是否是4.7寸屏*/
//宽375
#define is4_7Inch ([UIScreen mainScreen].bounds.size.height == 667.0)
/**是否是5.5寸屏幕*/
//宽414
#define is5_5Inch ([UIScreen mainScreen].bounds.size.height == 736.0)


#define Font(F)                         [UIFont systemFontOfSize:(F)]
#define boldFont(F)                     [UIFont boldSystemFontOfSize:(F)]


#define CurrentAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#endif /* SystemDeviceHeader_h */
