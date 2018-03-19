//
//  XLSambaDownloadHandler.h
//  PhiNas
//
//  Created by xll on 2018/1/11.
//  Copyright © 2018年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSambaDownloadTask.h"

@interface XLSambaDownloadHandler : NSObject

AS_SINGLETON(XLSambaDownloadHandler)

@property (strong, nonatomic) dispatch_queue_t taskQueue;

/**
 任务数组
 */
@property(nonatomic,strong)NSMutableArray *taskArray;

/**
 最大下载任务数  最大并发3个
 */
@property(nonatomic,assign,readonly)int maxDownloadTask;

/**
 添加新任务后回调
 */
@property(nonatomic,copy)void(^didAddTask)(XLSambaDownloadTask *task);

/**
 所有任务完成回调  这个所有任务完成是指没有继续下载的请求了  但有可能有暂停的任务
 */
@property(nonatomic,copy)void(^allTaskFinish)(void);//所有任务下载完成

/**
 添加下载任务

 @param path samba 路径
 @param downloadPath 本地存放路径
 */
-(BOOL)addTaskFrom:(NSString *)path toDownloadPath:(NSString *)downloadPath;



@end
