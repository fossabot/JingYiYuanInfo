//
//  YYRewardView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RewardIntegerationBlock)(NSInteger integeration);

@interface YYRewardView : UIView

/** 打赏界面的回调*/
@property (nonatomic, copy) RewardIntegerationBlock rewardBlock;

@end
