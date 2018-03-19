//
//  XLSambaUploadTask.m
//  PhiNas
//
//  Created by xll on 2018/1/11.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "XLSambaUploadTask.h"

@interface XLSambaUploadTask()

@property (strong, nonatomic) NSFileHandle *fileHandle;

@property (readwrite, assign, nonatomic) long long uploadBytes;

@property (strong, nonatomic) KxSMBItemFile *smbFile;

@end
@implementation XLSambaUploadTask

- (long long)fileSize
{
    return [self.fileHandle seekToEndOfFile];
}

- (NSFileHandle *)fileHandle
{
    if(!_fileHandle)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:self.uploadPath])
        {
            [fm createFileAtPath:self.uploadPath contents:nil attributes:nil];
        }
        _fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.uploadPath];
    }
    
    return _fileHandle;
}
-(void)setUploadPath:(NSString *)uploadPath
{
    _uploadPath = uploadPath;
    
    NSString *aimPath;
    if ([self.sambaPath hasSuffix:@"/"]) {
        aimPath = [NSString stringWithFormat:@"%@%@",self.sambaPath,[uploadPath lastPathComponent]];
    }
    else
    {
        aimPath = [NSString stringWithFormat:@"%@/%@",self.sambaPath,[uploadPath lastPathComponent]];
    }
//    NSString *aimPath = [NSString stringWithFormat:@"%@/%@",self.sambaPath,[uploadPath lastPathComponent]];
    id object =  [[KxSMBProvider sharedSmbProvider]fetchAtPath:aimPath];
    if(object && [object isKindOfClass:[KxSMBItemFile class]])
    {
        [[KxSMBProvider sharedSmbProvider]removeAtPath:aimPath];
        id result = [[KxSMBProvider sharedSmbProvider]createFileAtPath:aimPath overwrite:YES];
        if (result && [result isKindOfClass:[KxSMBItemFile class]]) {
            _smbFile = result;
        }
    }
    else
    {
      id result = [[KxSMBProvider sharedSmbProvider]createFileAtPath:aimPath overwrite:YES];
        if (result && [result isKindOfClass:[KxSMBItemFile class]]) {
            _smbFile = result;
        }
    }
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
    self.uploadBytes = self.smbFile.stat.size;
    
    id result = [self.smbFile seekToFileOffset:self.uploadBytes whence:SEEK_END];
    
    if([result isKindOfClass:[NSNumber class]])
    {
        [self upload];
        return ;
    }
    [self taskIsSuccess:NO withMessage:@"seekToFileOffset失败"];
}
- (void)upload
{
    if (self.isPause) {
        return;
    }
    [self.fileHandle seekToFileOffset:self.uploadBytes];
    NSData *data = [self.fileHandle readDataOfLength:1024*1024];
    if (data) {
        [self updateUploadStatus:data];
    }
    else
    {
        [self taskIsSuccess:NO withMessage:@"读取本地文件失败"];
    }
}
- (void)updateUploadStatus:(NSData *)data
{
    self.uploadBytes += data.length;
    self.percent = (float)self.uploadBytes / (float)self.fileSize;
    
    if (self.smbFile) {
        __weak typeof(self)weakSelf = self;
        [self.smbFile writeData:data block:^(id  _Nullable result) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if ([result isKindOfClass:[NSError class]])
            {
                [strongSelf closeFiles];
                NSError *error = result;
                [strongSelf taskIsSuccess:NO withMessage:error.description];
                return;
            }
            else if ([result isKindOfClass:[NSNumber class]])
            {
                if(strongSelf.progress)
                {
                    strongSelf.progress(strongSelf, strongSelf.percent);
                }
                if (self.uploadBytes >= strongSelf.fileSize || strongSelf.percent >= 1) {
                    [strongSelf closeFiles];
                     [strongSelf taskIsSuccess:YES withMessage:@"任务上传完成"];
                }
                else
                {
                    [strongSelf upload];
                }
            }
            else
            {
                [strongSelf closeFiles];
                [strongSelf taskIsSuccess:NO withMessage:@"something wrong"];
            }
        }];
    }
}
-(void)pause
{
    self.isPause = YES;
}
- (void)cancel
{
    [self closeFiles];
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
