//
//  SambaPathFormatter.h
//  PhiNas
//
//  Created by xll on 2018/1/15.
//  Copyright © 2018年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SambaPathFormatter : NSObject

+(NSArray *)formateWithPath:(NSString *)path;

+(NSString *)GetSambaPath:(NSString *)path;

@end
