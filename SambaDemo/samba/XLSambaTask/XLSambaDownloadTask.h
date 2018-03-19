//
//  XLSambaDownloadTask.h
//  PhiNas
//
//  Created by xll on 2018/1/10.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "XLSambaTask.h"

@interface XLSambaDownloadTask : XLSambaTask

@property (readonly, nonatomic) long downloadBytes; //设置了savePath后便可以得到

@property (copy, nonatomic) NSString *savePath;

@property (assign, nonatomic) CGFloat percent;

@property (copy, nonatomic) SambaTaskProgress progress;

@property (readonly, nonatomic) long fileSize;

- (NSString *)downloadByteDescription;

@end
