//
//  YYGoodsCollectionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYGoodsCollectionCell.h"
//#import "UIView+YYCategory.h"

@implementation YYGoodsCollectionCell
//{
//    CGFloat cellWidth;
//    CGFloat cellHeight;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        cellWidth = (kSCREENWIDTH-38)/2.f;
//        cellHeight = (132.f/169.f)*cellWidth+73;
        self.backgroundColor = WhiteColor;
        [self configSubView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.contentView cutRoundViewRadius:5];
//    [self.contentView cutCornerRect:CGRectMake(0, 0, cellWidth, cellHeight) radius:5];
}

- (void)configSubView {
    
//    UIView *borderView = [[UIView alloc] init];
//    borderView.layer.borderColor = YYRGB(244, 244, 244).CGColor;
//    borderView.backgroundColor = WhiteColor;
//    borderView.layer.borderWidth = 1;
//    self.borderView = borderView;
//    [self.contentView addSubview:borderView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
    YYEdgeLabel *tagLabel = [[YYEdgeLabel alloc] init];
    tagLabel.layer.borderColor = ThemeColor.CGColor;
    tagLabel.textColor = ThemeColor;
    tagLabel.font = TagLabelFont;
    [tagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [tagLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.tagLabel = tagLabel;
    [self.contentView addSubview:tagLabel];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = TitleColor;
    title.font = SubTitleFont;
//    title.numberOfLines = 2;
//    [title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.title = title;
    [self.contentView addSubview:title];
    
//    UIImageView *money = [[UIImageView alloc] initWithImage:imageNamed(@"yyfw_mine_integration_20x20")];
//    [self.contentView addSubview:money];
    
    UILabel *integration = [[UILabel alloc] init];
    integration.textColor = ThemeColor;
    integration.font = SubTitleFont;
    self.integration = integration;
    [self.contentView addSubview:integration];
    
//    [self.borderView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
//    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.height.equalTo((kSCREENWIDTH-40)/2);
        CGFloat cellWidth = (kSCREENWIDTH-38)/2;
        make.height.equalTo((132.f/169.f)*cellWidth);
    }];
    
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(5);
        make.top.equalTo(self.imageView.bottom).offset(10);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.tagLabel);
        make.left.equalTo(self.tagLabel.right).offset(6);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
    [self.integration makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.title.bottom).offset(10);
    }];
    
//    [money makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.integration.left).offset(-3);
//        make.centerY.equalTo(self.integration);
//    }];
}

@end
