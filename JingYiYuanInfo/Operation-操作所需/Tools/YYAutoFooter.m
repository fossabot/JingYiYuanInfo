//
//  YYAutoFooter.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/3.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAutoFooter.h"

@implementation YYAutoFooter

- (void)prepare {
    
    [super prepare];
    
    //所有的自定义东西都放在这里
    [self setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置颜色
    self.stateLabel.textColor = YYRGB(193, 193, 193);
    
}


@end
