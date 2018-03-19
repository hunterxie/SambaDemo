//
//  XLUploadTask.h
//  PhiNas
//
//  Created by xll on 2018/1/18.
//  Copyright © 2018年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface XLUploadTask : NSObject

@property(nonatomic,copy)NSString *assetID;

@property(nonatomic,copy)PHAsset *asset;



@end
