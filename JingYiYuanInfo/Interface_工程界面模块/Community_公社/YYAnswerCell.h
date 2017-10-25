//
//  YYAnswerCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYAnswerCellId = @"YYAnswerCell";

@class YYAnswerModel;

@interface YYAnswerCell : UITableViewCell

/** 牛人头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 牛人名字*/
@property (nonatomic, strong) UILabel *question;

/** 回答*/
@property (nonatomic, strong) UILabel *answer;

/** time*/
@property (nonatomic, strong) UILabel *time;


@property (nonatomic, strong) YYAnswerModel *model;

@end
