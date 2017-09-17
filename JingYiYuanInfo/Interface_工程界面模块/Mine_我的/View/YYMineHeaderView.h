//
//  YYMineHeaderView.h
//  壹元服务
//
//  Created by VINCENT on 2017/4/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSignBgView;
@class YYUser;

@protocol YYHeaderViewDestinationDelegate <NSObject>

- (void)destinationController:(UIViewController *)viewController;

@end

@interface YYMineHeaderView : UIView

/** delegate*/
@property (nonatomic, weak) id<YYHeaderViewDestinationDelegate> delegate;


/** 个人信息模型*/
@property (nonatomic, strong) YYUser *user;

+ (instancetype)headerView;

@end
