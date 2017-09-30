//
//  YYHotTableViewCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  资讯热搜榜的cell

#import <UIKit/UIKit.h>

@class YYBaseHotModel;
@class YYHotHotModel;

static NSString * const YYHotTableViewCellId = @"YYHotTableViewCell";

@interface YYHotTableViewCell : UITableViewCell

/** model*/
@property (nonatomic, strong) YYHotHotModel *hotModel;

/** model*/
@property (nonatomic, strong) YYBaseHotModel *baseModel;

/** 设置这个有排序按钮并且有金银铜牌*/
- (void)setHotModel:(YYHotHotModel *)hotModel andIndex:(NSInteger)index;

/** 设置这个有排序按钮 无金银铜牌*/
- (void)setBaseModel:(YYBaseHotModel *)hotModel andIndex:(NSInteger)index;

@end
