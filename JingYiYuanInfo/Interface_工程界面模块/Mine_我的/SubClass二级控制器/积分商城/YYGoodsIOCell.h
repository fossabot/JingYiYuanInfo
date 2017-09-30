//
//  YYGoodsIOCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYGoodsIOCellId = @"YYGoodsIOCell";

@interface YYGoodsIOCell : UITableViewCell

/** leftImageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** 积分*/
@property (nonatomic, strong) UILabel *integral;

/** 时间*/
@property (nonatomic, strong) UILabel *time;

@end
