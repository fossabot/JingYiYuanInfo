//
//  YYVideoHeaderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYVideoHeaderView.h"




@implementation YYVideoHeaderView

+ (instancetype)headerView {
    
    YYVideoHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return headerView;
}

@end
