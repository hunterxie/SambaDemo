//
//  XLSambaDownloadTask.m
//  PhiNas
//
//  Created by xll on 2018/1/10.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "XLSambaDownloadTask.h"

@interface XLSambaDownloadTask()

@property (strong, nonatomic) NSFileHandle *fileHandle;

@property (readwrite, assign, nonatomic) long downloadBytes;

@property (strong, nonatomic) KxSMBItemFile *smbFile;

@end


@implementation XLSambaDownloadTask

- (NSString *)downloadByteDescription
{
    CGFloat value;
    NSString *unit;
    
    if (self.downloadBytes < 1024) {
        
        value = self.downloadBytes;
        unit = @"B";
        
    } else if (self.downloadBytes < 1048576) {
        
        value = self.downloadBytes / 1024.f;
        unit = @"KB";
        
    } else {
        
        value = self.downloadBytes / 1048576.f;
        unit = @"MB";
    }
    NSString *description = [NSString stringWithFormat:@"downloaded %.1f%@ (%.1f%%)",value, unit,self.percent * 100.f];
    return description;
}

- (long)fileSize
{
    return self.smbFile.stat.size;
}

- (NSFileHandle *)fileHandle
{
    if(!_fileHandle)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:self.savePath])
        {
            [fm createFileAtPath:self.savePath contents:nil attributes:nil];
        }
        _fileHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:self.savePath]
                                                        error:nil];
        [_fileHandle seekToEndOfFile];
    }
    
    return _fileHandle;
}
-(KxSMBItemFile *)smbFile
{
    if (!_smbFile) {
        id object = [[KxSMBProvider sharedSmbProvider]fetchAtPath:self.sambaPath];
        if(object && [object isKindOfClass:[KxSMBItemFile class]])
        {
            _smbFile = object;
        }
    }
    return _smbFile;
}
-(long)downloadBytes
{
    return self.fileHandle.offsetInFile;
}
- (void)start
{
    if (self.isPause) {
        return;
    }

    if(!self.fileHandle || !self.smbFile)
    {
        [self taskIsSuccess:NO withMessage:@"文件句柄未打开或smbFile不存在"];
        return;
    }
    self.downloadBytes = self.fileHandle.offsetInFile;
    
    id result = [self.smbFile seekToFileOffset:self.downloadBytes whence:SEEK_SET];
    
    if([result isKindOfClass:[NSNumber class]])
    {
        [self download];
        return ;
    }
    [self taskIsSuccess:NO withMessage:@"seekToFileOffset失败"];
}
- (void)download
{
    if (self.isPause) {
        return;
    }
    
    __weak typeof(self) weakSelf = self; ;
    [self.smbFile readDataOfLength:1024*1024
                             block:^(id result)
     {
         __strong typeof(weakSelf) self = weakSelf;
         [self updateDownloadStatus:result];
     }];
}

- (void)cancel
{
    [self closeFiles];
}
- (void)updateDownloadStatus:(id)result
{
    if ([result isKindOfClass:[NSError class]])
    {
        [self closeFiles];
        NSError *error = result;
        [self taskIsSuccess:NO withMessage:error.description];
        return;
    }
    else if ([result isKindOfClass:[NSData class]])
    {
        
        NSData *data = result;
        self.downloadBytes += data.length;
        self.percent = (float)self.downloadBytes / (float)self.smbFile.stat.size;
        
        if (self.fileHandle)
        {
            [self.fileHandle writeData:data];
            if(self.progress)
            {
                self.progress(self, self.percent);
            }
            if(self.downloadBytes >= self.smbFile.stat.size || self.percent >= 1)
            {
                [self closeFiles];
                [self taskIsSuccess:YES withMessage:@"任务下载完成"];
            }
            else
            {
                [self download];
            }
        }
    }
}
-(void)pause
{
    self.isPause = YES;
}
- (void)closeFiles
{
    if (self.fileHandle)
    {
        [self.fileHandle closeFile];
        self.fileHandle = nil;
    }
    if(self.smbFile)
    {
        [self.smbFile close];
    }
}
-(void)taskIsSuccess:(BOOL)isSuccess withMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.taskFinishBlock) {
            self.taskFinishBlock(isSuccess,self,message);
        }
        if (self.taskEndForHandlerBlock) {
            self.taskEndForHandlerBlock(isSuccess,self,message);
        }
    });
    
}
@end
