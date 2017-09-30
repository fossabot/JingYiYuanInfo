//
//  YYGoodsIOCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYGoodsIOCell.h"

@implementation YYGoodsIOCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
    }
    return self;
}


- (void)configSubView {
    
    UIImageView *LeftImageView = [[UIImageView alloc] init];
    self.leftImageView = LeftImageView;
    [self.contentView addSubview:LeftImageView];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = TitleColor;
    title.font = TitleFont;
    self.title = title;
    [self.contentView addSubview:title];
    
    UILabel *integral = [[UILabel alloc] init];
    integral.textColor = UnenableTitleColor;
    integral.font = UnenableTitleFont;
    self.integral = integral;
    [self.contentView addSubview:integral];
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    self.time = time;
    [self.contentView  addSubview:time];
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.equalTo(100);
        make.height.equalTo(70);
        
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftImageView.right).offset(10);
        make.top.equalTo(self.leftImageView);
    }];
    
    [self.integral makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.title.left);
        make.top.equalTo(self.title.bottom).offset(2);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.leftImageView);
    }];
    
}

@end
