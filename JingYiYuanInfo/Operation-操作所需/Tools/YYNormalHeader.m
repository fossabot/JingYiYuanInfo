//
//  YYNormalHeader.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/3.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNormalHeader.h"

@implementation YYNormalHeader

- (void)prepare {
    
    [super prepare];
    
    [self setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置颜色
    self.stateLabel.textColor = YYRGB(193, 193, 193);;
    self.lastUpdatedTimeLabel.textColor = YYRGB(193, 193, 193);;
    self.automaticallyChangeAlpha = YES;
    
}

@end
