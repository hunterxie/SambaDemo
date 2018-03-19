//
//  XLSambaUploadHandler.m
//  PhiNas
//
//  Created by xll on 2018/1/16.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "XLSambaUploadHandler.h"
#import "SambaPathFormatter.h"
@implementation XLSambaUploadHandler
DEF_SINGLETON(XLSambaUploadHandler)

-(instancetype)init
{
    self = [super init];
    if (self) {
        _taskQueue = dispatch_queue_create("com.xll.sambauploadtask_queue", DISPATCH_QUEUE_SERIAL);
        _taskArray = [NSMutableArray arrayWithCapacity:0];
        _maxUploadTask = 3;
        
    }
    return self;
}

/**
 判断任务是否存在
 
 @param SambaPath SambaPath
 @return 返回是否存在
 */
-(BOOL)taskIsExist:(NSString *)SambaPath
{
    BOOL isExist = NO;
    for (XLSambaUploadTask *task in self.taskArray) {
        if ([task.identifier isEqualToString:[self GetTaskIdentifierFrom:SambaPath]]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

/**
 获取identifier
 @return NSString
 */
-(NSString *)GetTaskIdentifierFrom:(NSString *)sambaPath
{
    if ([sambaPath hasPrefix:@"smb://"]) {
        return [SambaPathFormatter GetSambaPath:sambaPath];
    }
    return [sambaPath lastPathComponent];
}

/**
 添加上传任务
 
 @param sambaPath sambaPath
 */
-(BOOL)addTaskFrom:(NSString *)sambaPath toUploadPath:(NSString *)uploadPath
{
    
    NSString *newFilePath;
    if ([sambaPath hasSuffix:@"/"]) {
        newFilePath = [NSString stringWithFormat:@"%@%@",sambaPath,[uploadPath lastPathComponent]];
    }
    else
    {
        newFilePath = [NSString stringWithFormat:@"%@/%@",sambaPath,[uploadPath lastPathComponent]];
    }
    
    if ([self taskIsExist:newFilePath]) {
        NSLog(@"任务已经存在了");
        return NO;
    }
    dispatch_async(_taskQueue, ^{
        XLSambaUploadTask *task = [[XLSambaUploadTask alloc]init];
        task.sambaPath = sambaPath;
        task.uploadPath = uploadPath;
        
        task.identifier = [self GetTaskIdentifierFrom:newFilePath];
        task.isFinish = NO;
        task.isPause = NO;
        [_taskArray addObject:task];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.didAddTask) {
                self.didAddTask(task);
            }
        });
        if ([self checkRunningTaskCount]) {
            [self handleTask:task];
        }
        else
        {
            NSLog(@"队列已满，先存放下来");
        }
    });
    return YES;
}

/**
 判断当前任务是否超过最大上传任务数
 
 @return bool
 */
-(BOOL)checkRunningTaskCount
{
    BOOL canRun = NO;
    int i = 0;
    for (XLSambaUploadTask *task in self.taskArray) {
        if (!task.isFinish && !task.isPause && !task.isRunning) {
            i ++;
        }
    }
    if (i <= self.maxUploadTask) {
        canRun = YES;
    }
    return canRun;
}

/**
 执行任务
 
 @param task task
 */
-(void)handleTask:(XLSambaUploadTask *)task
{
    __weak typeof(self)weakSelf = self;
    task.taskEndForHandlerBlock = ^(BOOL isSuccess, XLSambaTask *task, NSString *message) {
        task.isFinish = YES;
        task.isRunning = NO;
        [weakSelf checkIfMoreTask];
    };
    
    [task start];
    task.isRunning = YES;
}

/**
 判断是否还有任务需要执行
 */
-(void)checkIfMoreTask
{
    if ([self checkRunningTaskCount]) {
        XLSambaUploadTask *nextTask ;
        for (XLSambaUploadTask *task in self.taskArray) {
            if (!task.isFinish && !task.isPause && !task.isRunning) {
                nextTask = task;
                break;
            }
        }
        if (!nextTask) {
            if (self.allTaskFinish) {
                self.allTaskFinish();
            }
        }
        else
        {
            [self handleTask:nextTask];
        }
    }
}
@end
