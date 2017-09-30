//
//  YYThreeSeekTabView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYThreeSeekTabViewDelegate <NSObject>

@required
/** 按钮数组*/
- (NSArray *)titlesOfTabs;

@optional
/** 选中了相应的tabItem*/
- (void)threeSeekTabViewSelectIndex:(NSInteger)index;


@end

@interface YYThreeSeekTabView : UIView

/** defaultSelectIndex*/
@property (nonatomic, assign) NSInteger defaultSelectIndex;

/** 外界调用切换选中的按钮*/
- (void)letMeSelectIndex:(NSInteger)index;

/** delegate*/
@property (nonatomic, weak) id<YYThreeSeekTabViewDelegate> delegate;

@end
