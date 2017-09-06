//
//  YYTabBarViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYTabBarSelectedDelegate <NSObject>

- (BOOL)changeTabbarItem;

@end

@interface YYTabBarViewController : UITabBarController

/** delegate*/
@property (nonatomic, weak) id<YYTabBarSelectedDelegate> tabbarDelegate;

@end
