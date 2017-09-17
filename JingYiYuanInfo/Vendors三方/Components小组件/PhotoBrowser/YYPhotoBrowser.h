//
//  YYPhotoBrowser.h
//  PhotoBrowser
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYHotPicsModel;

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

typedef void(^Dismiss)();

@interface YYPhotoBrowser : UIView

/** 返回*/
@property (nonatomic, copy) Dismiss dismissBlock;

/** picsModel*/
@property (nonatomic, strong) NSArray<YYHotPicsModel *> *picsModels;

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles;

- (instancetype)initWithModels:(NSArray<YYHotPicsModel *> *)models;

- (void)show;

@end
