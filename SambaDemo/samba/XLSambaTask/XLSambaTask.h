//
//  XLSambaTask.h
//  PhiNas
//
//  Created by xll on 2018/1/10.
//  Copyright © 2018年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KxSMBProvider.h"

@class XLSambaTask;

typedef void(^SambaTaskProgress)(XLSambaTask *task, CGFloat percent);

typedef void(^SambaTaskBlock)(BOOL isSuccess,XLSambaTask *task ,NSString *message);


@interface XLSambaTask : NSObject

@property (copy, nonatomic) NSString *sambaPath;//samba 服务器文件地址

@property (copy, nonatomic) NSString *identifier; //任务标志符

@property (assign, nonatomic) NSInteger retryTime; //任务已执行次数

@property(nonatomic,copy)SambaTaskBlock taskFinishBlock;//任务下载结束回调

@property(nonatomic,copy)SambaTaskBlock taskEndForHandlerBlock;//下载结束

@property(nonatomic,assign)BOOL isPause;//是否暂停

@property(nonatomic,assign)BOOL isRunning;//是否正在下载

@property(nonatomic,assign)BOOL isFinish;//是否已经下载完成

//开始某个任务
- (void)start;
//取消任务，取消后不能恢复
- (void)cancel;
//暂停
- (void)pause;

@end
