//
//  YYMineOrderCell.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderModel;
@class YYMineOrderCell;

typedef void(^MoreBlock)(NSString *orderId);
typedef void(^CancelOrderBlock)(NSString *orderId,NSString *orderName,YYMineOrderCell *cell);

static NSString * const YYMineOrderCellId = @"YYMineOrderCell";

@interface YYMineOrderCell : UITableViewCell

@property (nonatomic, strong) YYOrderModel *model;

/** 研报block*/
@property (nonatomic, copy) MoreBlock moreBlock;

/** 退单block*/
@property (nonatomic, copy) CancelOrderBlock cancelOrderBlcok;


/** 退单按钮*/
@property (nonatomic, strong) UIButton *cancelOrderBtn;
@end
