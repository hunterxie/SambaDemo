//
//  LMHTTPServer.h
//  flamegrace@hotmail.com
//
//  Created by Flame Grace on 17/1/4.
//  Copyright © 2017年 flamegrace@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasySambaHTTPServer : NSObject


+ (instancetype)shareServer;
/**
 开启本地视频服务器服务

 @param error 开始失败时的错误反馈
 @return 成功与否
 */
- (BOOL)startServer:(NSError **)error;

/**
 停止web服务器
 */
- (void)stop;

/**
 本地服务器所在端口

 @return 端口
 */
- (UInt16)listeningPort;

/**
 返回服务器是否在运行的状态

 @return 运行状态
 */
- (BOOL)isRunning;


/**
 返回samba路径转换后的http路径，对于视频，可以直接播放

 @param filePath samba路径
 @return http url
 */
- (NSString *)httpUrlForSambaFile:(NSString *)filePath;

@end
