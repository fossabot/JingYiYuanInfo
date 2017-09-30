//
//  YYIOTableViewCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYIOTableViewCellId = @"YYIOTableViewCell";

@interface YYIOTableViewCell : UITableViewCell

/** title*/
@property (nonatomic, strong) UILabel *title;

/** desc*/
@property (nonatomic, strong) UILabel *desc;

/** integration*/
@property (nonatomic, strong) UILabel *integration;

@end
