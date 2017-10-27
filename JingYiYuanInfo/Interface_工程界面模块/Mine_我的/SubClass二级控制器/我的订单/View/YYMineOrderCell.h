//
//  YYMineOrderCell.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderModel;

static NSString * const YYMineOrderCellId = @"YYMineOrderCell";

@interface YYMineOrderCell : UITableViewCell

@property (nonatomic, strong) YYOrderModel *model;

@end
