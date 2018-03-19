//
//  HTTPSMBFileResponse.m
//  KxSMBSample
//
//  Created by Flame Grace on 16/11/30.
//  Copyright © 2016年 Konstantin Bukreev. All rights reserved.
//

#import "EasySambaFileHTTPResponse.h"
#import "HTTPConnection.h"
#import "HTTPLogging.h"
#import "KxSMBProvider.h"

#import <unistd.h>
#import <fcntl.h>

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels : off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;

#define NULL_FD  -1


@interface EasySambaFileHTTPResponse()

@property (strong, nonatomic) KxSMBItemFile *fileItem;

@end;

@implementation EasySambaFileHTTPResponse
- (id)initWithSMBFilePath:(NSString *)fpath forConnection:(HTTPConnection *)parent;
{
    if((self = [super init]))
    {
        HTTPLogTrace();
        
        connection = parent; // Parents retain children, children do NOT retain parents
        
        KxSMBProvider *provider = [KxSMBProvider sharedSmbProvider];
        KxSMBItemFile *file = [provider fetchAtPath:fpath];
        if(!file || ![file isKindOfClass:[KxSMBItemFile class]])
        {
            HTTPLogWarn(@"%@: Init failed - Nil filePath", THIS_FILE);
            
            return nil;
        }
        self.fileItem = file;
        fileFD = NULL_FD;
        filePath = fpath;
        
        fileLength = (UInt64)self.fileItem.stat.size;
        fileOffset = 0;
        
        aborted = NO;
        
        // We don't bother opening the file here.
        // If this is a HEAD request we only need to know the fileLength.
    }
    return self;
}

- (void)abort
{
    HTTPLogTrace();
    
    [connection responseDidAbort:self];
    aborted = YES;
}


- (UInt64)contentLength
{
    HTTPLogTrace();
    
    return fileLength;
}

- (UInt64)offset
{
    HTTPLogTrace();
    
    return fileOffset;
}

- (void)setOffset:(UInt64)offset
{
    HTTPLogTrace2(@"%@[%p]: setOffset:%llu", THIS_FILE, self, offset);
    
    if (!self.fileItem)
    {
        // File opening failed,
        // or response has been aborted due to another error.
        return;
    }
    
    fileOffset = offset;
    
    NSNumber *off = [self.fileItem seekToFileOffset:offset whence:0];
    
    if([off isKindOfClass:[NSError class]])
    {
        NSLog(@"定位文件流出错：%@", off);
        return;
    }
    
    off_t result = (off_t)[off longValue];
    if (result == -1)
    {
        HTTPLogError(@"%@[%p]: lseek failed - errno(%i) filePath(%@)", THIS_FILE, self, errno, filePath);
        
        [self abort];
    }
}

- (NSData *)readDataOfLength:(NSUInteger)length
{
    HTTPLogTrace2(@"%@[%p]: readDataOfLength:%lu", THIS_FILE, self, (unsigned long)length);
    
    if (!self.fileItem)
    {
        // File opening failed,
        // or response has been aborted due to another error.
        return nil;
    }
    
    // Determine how much data we should read.
    //
    // It is OK if we ask to read more bytes than exist in the file.
    // It is NOT OK to over-allocate the buffer.
    
    UInt64 bytesLeftInFile = fileLength - fileOffset;
    
    NSUInteger bytesToRead = (NSUInteger)MIN(length, bytesLeftInFile);
    
    NSData *buffers = [self.fileItem readDataOfLength:bytesToRead];
    if([buffers isKindOfClass:[NSError class]])
    {
        NSLog(@"读取文件流出错：%@", buffers);
        return nil;
    }
    
    NSInteger result = buffers.length;
    
    // Check the results
    
    if (result < 0)
    {
        HTTPLogError(@"%@: Error(%i) reading file(%@)", THIS_FILE, errno, filePath);
        
        [self abort];
        return nil;
    }
    else if (result == 0)
    {
        HTTPLogError(@"%@: Read EOF on file(%@)", THIS_FILE, filePath);
        
        [self abort];
        return nil;
    }
    else // (result > 0)
    {
        HTTPLogVerbose(@"%@[%p]: Read %ld bytes from file", THIS_FILE, self, (long)result);
        
        fileOffset += result;
        
        return buffers;
    }
}

- (BOOL)isDone
{
    BOOL result = (fileOffset == fileLength);
    
    HTTPLogTrace2(@"%@[%p]: isDone - %@", THIS_FILE, self, (result ? @"YES" : @"NO"));
    
    return result;
}

- (NSString *)filePath
{
    return filePath;
}

- (void)dealloc
{
    HTTPLogTrace();
    
    if (fileFD != NULL_FD)
    {
        HTTPLogVerbose(@"%@[%p]: Close fd[%i]", THIS_FILE, self, fileFD);
        
        close(fileFD);
    }
    
    if (buffer)
        free(buffer);
    
}

@end
