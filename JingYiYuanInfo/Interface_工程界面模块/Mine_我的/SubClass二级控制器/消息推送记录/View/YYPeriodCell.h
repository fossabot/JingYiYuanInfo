//
//  YYPeriodCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPeriodModel;

static NSString * const YYPeriodCellId = @"YYPeriodCell";

@interface YYPeriodCell : UITableViewCell

/** model*/
@property (nonatomic, strong) YYPeriodModel *model;

@end
