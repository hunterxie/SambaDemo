//
//  FrameHeader.h
//  LoveWatchProject
//
//  Created by xll on 2017/10/18.
//  Copyright © 2017年 xll. All rights reserved.
//

#ifndef FrameHeader_h
#define FrameHeader_h


//高随屏幕宽适配 --- 基于6/6s
#define SCALE_HEIGHT(X)    X*([UIScreen mainScreen].bounds.size.width/375.0)

#define APPFRAME                        [UIScreen mainScreen].bounds
#define APP_WIDTH                       CGRectGetWidth(APPFRAME)
#define APP_HEIGHT                      CGRectGetHeight(APPFRAME)
#define APP_STATUSBAR_HEIGHT            [[UIApplication sharedApplication] statusBarFrame].size.height
#define APP_NAV_HEIGHT     (APP_STATUSBAR_HEIGHT + self.navigationController.navigationBar.frame.size.height)

#define APP_TAB_HEIGHT  ((APP_HEIGHT >= 812.0 && APP_WIDTH <= 414.0)?34.0:0.0)

#define NO_NAV_TAB_HEIGHT  (APP_HEIGHT - APP_NAV_HEIGHT - APP_TAB_HEIGHT)


#define GetHeight(a) CGRectGetHeight(a.frame)
#define GetWidth(a) CGRectGetWidth(a.frame)

#define GetOriginX(a) a.frame.origin.x
#define GetOriginY(a) a.frame.origin.y

#define GetMaxX(a) CGRectGetMaxX(a.frame)
#define GetMaxY(a) CGRectGetMaxY(a.frame)

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


#define makeL(a)            make.left.mas_equalTo(a)
#define makeR(a)            make.right.mas_equalTo(a)
#define makeT(a)            make.top.mas_equalTo(a)
#define makeB(a)            make.bottom.mas_equalTo(a)
#define makeW(a)            make.width.mas_equalTo(a)
#define makeH(a)            make.height.mas_equalTo(a)


#define makeL_R(a,b)        makeL(a); \
makeR(b);
#define makeT_B(a,b)        makeT(a); \
makeB(b);


#define makeSize(a,b)       make.size.mas_equalTo(CGSizeMake(a, b))
#define makeEdge(a,b,c,d)   make.edges.mas_equalTo(UIEdgeInsetsMake(a, b, c, d))

#define makeLeft(a,b)       make.left.equalTo(a).with.offset(b)
#define makeRight(a,b)      make.right.equalTo(a).with.offset(b)
#define makeTop(a,b)        make.top.equalTo(a).with.offset(b)
#define makeBottom(a,b)     make.bottom.equalTo(a).with.offset(b)
#define makeWidth(a,b)      make.width.equalTo(a).multipliedBy(b)
#define makeHeight(a,b)     make.height.equalTo(a).multipliedBy(b)

#define makeCX(a,b)    make.centerX.equalTo(a).with.offset(b)
#define makeCY(a,b)    make.centerY.equalTo(a).with.offset(b)


#endif /* FrameHeader_h */
