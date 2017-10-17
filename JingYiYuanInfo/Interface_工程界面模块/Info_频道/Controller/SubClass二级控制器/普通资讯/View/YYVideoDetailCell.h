//
//  YYVideoDetailCell.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBaseVideoModel;

static NSString * const YYVideoDetailCellId = @"YYVideoDetailCell";

@interface YYVideoDetailCell : UITableViewCell

@property (nonatomic, strong) YYBaseVideoModel *model;

@end
