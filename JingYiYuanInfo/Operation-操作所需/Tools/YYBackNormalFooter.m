//
//  YYBackNormalFooter.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/3.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBackNormalFooter.h"

@implementation YYBackNormalFooter

- (void)prepare {
    
    [super prepare];
    
    //所有的自定义东西都放在这里
//    [self setTitle:@"普通闲置状态" forState:MJRefreshStateIdle];
//    [self setTitle:@"松开就可以进行刷新的状态" forState:MJRefreshStatePulling];
    [self setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
//    [self setTitle:@"即将刷新的状态" forState:MJRefreshStateWillRefresh];
//    [self setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
    
    
    // 设置颜色
    self.stateLabel.textColor = YYRGB(193, 193, 193);
//    self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    self.arrowView.image = imageNamed(@"arrow");
    
    //一些其他属性设置
    /*
     // 设置字体
     self.stateLabel.font = [UIFont systemFontOfSize:15];
     self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
     
     // 隐藏时间
     self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏状态
     self.stateLabel.hidden = YES;
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.automaticallyChangeAlpha = YES;
     */
}







@end
