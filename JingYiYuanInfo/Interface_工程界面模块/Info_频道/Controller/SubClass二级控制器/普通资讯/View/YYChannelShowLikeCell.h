//
//  YYChannelShowLikeCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowLikeModel;

static NSString * const YYChannelShowLikeCellId = @"YYChannelShowLikeCell";

@interface YYChannelShowLikeCell : UITableViewCell

/** 猜你喜欢的模型*/
@property (nonatomic, strong) YYShowLikeModel *likeModel;

@end
