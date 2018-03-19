//
//  LMMovieHTTPConnection.m
//  KxSMBSample
//
//  Created by Flame Grace on 16/11/30.
//  Copyright © 2016年 Konstantin Bukreev. All rights reserved.
//

#import "EasySambaHTTPConnection.h"
#import "EasySambaFileHTTPResponse.h"
#import "KxSMBProvider.h"

@implementation EasySambaHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    NSRange position = [path rangeOfString:@"/smb/"];
    if(position.location != NSNotFound)
    {
        
        NSString *videoPath = [path substringFromIndex:position.location + position.length];
        videoPath = [@"smb://" stringByAppendingString:videoPath];
        
        EasySambaFileHTTPResponse *response = [[EasySambaFileHTTPResponse alloc]initWithSMBFilePath:videoPath forConnection:self];
        return response;
    }
    
    return [super httpResponseForMethod:method URI:path];
    
}

@end
