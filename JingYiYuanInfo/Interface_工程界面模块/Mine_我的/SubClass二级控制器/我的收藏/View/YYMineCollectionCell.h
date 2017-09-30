//
//  YYMineCollectionCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMineCollectionModel;

static NSString * const YYMineCollectionCellId = @"YYMineCollectionCell";

@interface YYMineCollectionCell : UITableViewCell

/** model*/
@property (nonatomic, strong) YYMineCollectionModel *model;

@end
