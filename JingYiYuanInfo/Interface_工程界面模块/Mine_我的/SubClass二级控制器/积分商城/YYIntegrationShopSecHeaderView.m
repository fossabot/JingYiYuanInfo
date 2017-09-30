//
//  YYIntegrationShopSecHeaderView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIntegrationShopSecHeaderView.h"

@implementation YYIntegrationShopSecHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LightGraySeperatorColor;
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = ThemeColor;
    [self addSubview:redView];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textColor = SubTitleColor;
    tip.font = SubTitleFont;
    [self addSubview:tip];
    self.tip = tip;
    
    [redView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(YYInfoCellCommonMargin);
        make.centerY.equalTo(self);
        make.height.equalTo(15);
        make.width.equalTo(2);
    }];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(redView.right).offset(5);
        make.centerY.equalTo(self);
    }];
    
}


@end
