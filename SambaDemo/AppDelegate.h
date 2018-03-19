//
//  AppDelegate.h
//  SambaDemo
//
//  Created by xll on 2018/3/19.
//  Copyright © 2018年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  DefaultKXSMBAuth [KxSMBAuth smbAuthWorkgroup:@"WORKGROUP" username:@"root" password:@"admin"]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

