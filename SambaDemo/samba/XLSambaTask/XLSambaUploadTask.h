//
//  XLSambaUploadTask.h
//  PhiNas
//
//  Created by xll on 2018/1/11.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "XLSambaTask.h"

@interface XLSambaUploadTask : XLSambaTask


@property (readonly, nonatomic) long long uploadBytes; //设置了uploadPath后便可以得到

@property (copy, nonatomic) NSString *uploadPath;

@property (assign, nonatomic) CGFloat percent;

@property (copy, nonatomic) SambaTaskProgress progress;

@property (readonly, nonatomic) long long fileSize;

@end
