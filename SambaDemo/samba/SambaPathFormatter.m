//
//  SambaPathFormatter.m
//  PhiNas
//
//  Created by xll on 2018/1/15.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "SambaPathFormatter.h"

@implementation SambaPathFormatter

//smb://172.17.100.172/test/
+(NSArray *)formateWithPath:(NSString *)path
{
    if (!path) {
        return nil;
    }
    if (path.length == 0) {
        return nil;
    }
//    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
//    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet]];
//    NSString *host = url.host;
//    if (!host) {
//        host = @"";
//    }
//    NSString *tempStr = [path substringFromIndex:[path rangeOfString:host].location + host.length + 1];
    NSString *tempStr = [self GetSambaPath:path];
    
    NSArray *array = [tempStr componentsSeparatedByString:@"/"];
    return array;
}
+(NSString *)GetSambaPath:(NSString *)path
{
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet]];
//    NSString *host = url.host;
//    if (!host) {
//        host = @"";
//    }
//    NSString *tempStr = [path substringFromIndex:[path rangeOfString:host].location + host.length + 1];
    NSString *p = url.path;
    if ([p hasPrefix:@"/"]) {
        p = [p substringFromIndex:1];
    }
    if ([p hasSuffix:@"/"]) {
        p = [p substringToIndex:p.length - 1];
    }
    return p;
}
@end
