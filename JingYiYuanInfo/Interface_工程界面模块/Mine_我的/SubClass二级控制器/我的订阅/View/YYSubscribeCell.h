//
//  YYSubscribeCell.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/16.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNiuSubscribeModel;

static NSString * const YYSubscribeCellId = @"YYSubscribeCell";

@interface YYSubscribeCell : UITableViewCell

@property (nonatomic, strong) YYNiuSubscribeModel *model;

- (void)clipRound;

@end
