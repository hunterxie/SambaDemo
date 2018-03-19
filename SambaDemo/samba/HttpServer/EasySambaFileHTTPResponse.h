//
//  HTTPSMBFileResponse.h
//  KxSMBSample
//
//  Created by Flame Grace on 16/11/30.
//  Copyright © 2016年 Konstantin Bukreev. All rights reserved.
//

#import "HTTPResponse.h"
#import "HTTPConnection.h"

@interface EasySambaFileHTTPResponse : NSObject <HTTPResponse>
{
    HTTPConnection *connection;
    
    NSString *filePath;
    UInt64 fileLength;
    UInt64 fileOffset;
    
    BOOL aborted;
    
    int fileFD;
    void *buffer;
    NSUInteger bufferSize;
}

- (id)initWithSMBFilePath:(NSString *)fpath forConnection:(HTTPConnection *)parent;

@end
