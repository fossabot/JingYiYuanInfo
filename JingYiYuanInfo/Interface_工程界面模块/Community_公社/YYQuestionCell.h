//
//  YYQuestionCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYQuestionCellId = @"YYQuestionCell";

@interface YYQuestionCell : UITableViewCell

/** 牛人头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 牛人名字*/
@property (nonatomic, strong) UILabel *name;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** 我的问题*/
@property (nonatomic, strong) UILabel *question;

/** bottomView*/
@property (nonatomic, strong) UIView *bottomView;

@end
