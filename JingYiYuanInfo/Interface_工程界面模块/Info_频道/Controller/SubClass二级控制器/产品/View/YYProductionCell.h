//
//  YYProductionCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYProductionVIPModel;
@class YYProductionCommonModel;

static NSString * const YYProductionCellId = @"YYProductionCell";

@interface YYProductionCell : UITableViewCell

/** YYProductionCommonModel*/
@property (nonatomic, strong) YYProductionCommonModel *commonModel;

/** vipModel*/
@property (nonatomic, strong) YYProductionVIPModel *vipModel;

@end
