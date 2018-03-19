//
//  LMHTTPServer.m
//  flamegrace@hotmail.com
//
//  Created by Flame Grace on 17/1/4.
//  Copyright © 2017年 flamegrace@hotmail.com. All rights reserved.
//

#import "EasySambaHTTPServer.h"
#import "HTTPServer.h"
#import "EasySambaHTTPConnection.h"
#import "KxSMBProvider.h"

@interface EasySambaHTTPServer()

@property (strong, nonatomic) HTTPServer *httpServer;

@end

@implementation EasySambaHTTPServer

static EasySambaHTTPServer *server = nil;

+ (instancetype)shareServer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[EasySambaHTTPServer alloc]init];
    });
    
    return server;
}


- (id)init
{
    if(self = [super init])
    {
        self.httpServer = [[HTTPServer alloc]init];
        [self.httpServer setType:@"_http._tcp."];
        // Normally there's no need to run our server on any specific port.
        // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
        // However, for easy testing you may want force a certain port so you can just hit the refresh button.
        // [httpServer setPort:12345];
        
        // Serve files from our embedded Web folder
        NSString *webPath = [[NSBundle mainBundle] bundlePath];
        [self.httpServer setDocumentRoot:webPath];
        [self.httpServer setConnectionClass:[EasySambaHTTPConnection class]];
    }
    
    return self;
}

- (BOOL)startServer:(NSError **)error
{
    if([self isRunning])
    {
        return YES;
    }
    if([self.httpServer start:error])
    {
        NSLog(@"监听端口：%hu",[self listeningPort]);
        return YES;
    }
    return NO;
}

- (void)stop
{
    [self.httpServer stop];
}

- (UInt16)listeningPort
{
    return [self.httpServer listeningPort];
}

- (BOOL)isRunning
{
    return [self.httpServer isRunning];
}


- (NSString *)httpUrlForSambaFile:(NSString *)filePath
{
    KxSMBItemFile *file = [[KxSMBProvider sharedSmbProvider] fetchAtPath:filePath];
    if(!file || ![file isKindOfClass:[KxSMBItemFile class]])
    {
        return nil;
    }
    NSString *smbPath = [filePath copy];
    NSString *videoSmbPath = [smbPath substringFromIndex:6];
    NSString *httpUrl = [NSString stringWithFormat:@"http://127.0.0.1:%hu/smb/%@",self.listeningPort,videoSmbPath];
    //将url转换为utf8字符
    httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return httpUrl;
}

@end
