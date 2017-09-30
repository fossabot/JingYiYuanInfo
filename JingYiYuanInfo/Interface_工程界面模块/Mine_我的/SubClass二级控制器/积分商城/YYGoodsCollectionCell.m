//
//  YYGoodsCollectionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYGoodsCollectionCell.h"

@implementation YYGoodsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WhiteColor;
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
    YYEdgeLabel *tagLabel = [[YYEdgeLabel alloc] init];
    tagLabel.layer.borderColor = ThemeColor.CGColor;
    tagLabel.textColor = ThemeColor;
    tagLabel.font = UnenableTitleFont;
    [tagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.tagLabel = tagLabel;
    [self.contentView addSubview:tagLabel];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = UnenableTitleColor;
    title.font = UnenableTitleFont;
    title.numberOfLines = 2;
    self.title = title;
    [self.contentView addSubview:title];
    
    UIImageView *money = [[UIImageView alloc] initWithImage:imageNamed(@"yyfw_mine_integration_20x20")];
    [self.contentView addSubview:money];
    
    UILabel *integration = [[UILabel alloc] init];
    integration.textColor = ThemeColor;
    integration.font = UnenableTitleFont;
    self.integration = integration;
    [self.contentView addSubview:integration];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo((kSCREENWIDTH-30)/2);
    }];
    
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.lessThanOrEqualTo(self.contentView).offset(10);
        make.top.equalTo(self.imageView.bottom).offset(5);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.tagLabel);
        make.left.equalTo(self.tagLabel.right).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
    [self.integration makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.title.bottom).offset(5);
    }];
    
    [money makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.integration.left).offset(-3);
        make.centerY.equalTo(self.integration);
    }];
}

@end
