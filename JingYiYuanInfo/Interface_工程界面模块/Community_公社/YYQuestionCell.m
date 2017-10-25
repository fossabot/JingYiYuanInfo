//
//  YYQuestionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYQuestionCell.h"
#import "UIView+YYCategory.h"

@implementation YYQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon cutRoundView];
}

- (void)configSubView {
    
    UIImageView *icon = [[UIImageView alloc] init];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = TitleFont;
    self.name = name;
    [self.contentView addSubview:name];
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.textColor = TitleColor;
    title.font = TitleFont;
    self.title = title;
    [self.contentView addSubview:title];
    
    UILabel *question = [[UILabel alloc] init];
    question.numberOfLines = 0;
    question.font = SubTitleFont;
    question.textColor = UnenableTitleColor;
    self.question = question;
    [self.contentView  addSubview:question];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = LightGraySeperatorColor;
    [self.contentView addSubview:bottomView];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(50);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(10);
        make.right.equalTo(-15);
        make.centerY.equalTo(self.icon);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.left);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon.bottom).offset(10);
    }];
    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.title);
        make.right.equalTo(-15);
        make.top.equalTo(self.title.bottom).offset(10);
    }];

    [bottomView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.question.bottom).offset(15);
        make.height.equalTo(5);
    }];
    
}

@end
