//
//  ViewController.m
//  SambaDemo
//
//  Created by xll on 2018/3/19.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "ViewController.h"
#import "KxSMBProvider.h"
#import "XLSambaDownloadHandler.h"
#import "XLSambaUploadHandler.h"
#import "EasySambaHTTPServer.h"
#import "AFHTTPSessionManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *items = [[KxSMBProvider sharedSmbProvider] fetchAtPath:@"smb://172.18.180.242/"];
    NSLog(@"%@",items);
//        [[KxSMBProvider sharedSmbProvider]createFileAtPath:@"smb://172.18.180.242/xiaohong.txt" overwrite:YES];
   
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)download:(NSString *)serverPath toLocalPath:(NSString *)localPath
{
    [[NSFileManager defaultManager]removeItemAtPath:localPath error:nil];

    __weak typeof(self)weakSelf = self;
    [XLSambaDownloadHandler sharedInstance].didAddTask = ^(XLSambaDownloadTask *task) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleTask:task];
    };
    [XLSambaDownloadHandler sharedInstance].allTaskFinish = ^{
      
    };
    [[XLSambaDownloadHandler sharedInstance]addTaskFrom:serverPath toDownloadPath:localPath];
}
-(void)handleTask:(XLSambaDownloadTask *)task
{
    task.progress = ^(XLSambaTask *task, CGFloat percent) {
        NSLog(@"task:%@--%.2f",task.identifier,percent);
    };
    task.taskFinishBlock = ^(BOOL isSuccess, XLSambaTask *task, NSString *message) {
        NSLog(@"任务：%@%@",task.identifier,message);
    };
}
-(void)uploadFile:(NSString *)serverPath toLocalPath:(NSString *)uploadFile
{
    [XLSambaUploadHandler sharedInstance].didAddTask = ^(XLSambaUploadTask *task) {
    };
    [XLSambaUploadHandler sharedInstance].allTaskFinish = ^{

    };
    [[XLSambaUploadHandler sharedInstance]addTaskFrom:@"smb://172.17.100.157/test/xll" toUploadPath:uploadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
