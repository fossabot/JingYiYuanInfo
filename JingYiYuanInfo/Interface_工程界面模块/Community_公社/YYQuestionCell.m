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
        [self.icon cutCornerRect:CGRectMake(0, 0, 40, 40) radius:20];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.icon cutRoundView];
}

- (void)configSubView {
    
    UIImageView *icon = [[UIImageView alloc] init];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = [UIFont boldSystemFontOfSize:16];
    self.name = name;
    [self.contentView addSubview:name];
    
    UILabel *time = [[UILabel alloc] init];
    time.textColor = LightSubTitleColor;
    time.font = sysFont(12);
    self.time = time;
    [self.contentView addSubview:time];
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.textColor = TitleColor;
    title.font = sysFont(14);
    self.title = title;
    [self.contentView addSubview:title];
    
    UILabel *question = [[UILabel alloc] init];
    question.numberOfLines = 3;
    question.font = sysFont(13);
    question.textColor = UnenableTitleColor;
    self.question = question;
    [self.contentView  addSubview:question];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = LightGraySeperatorColor;
    self.bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(15);
        make.left.equalTo(14);
        make.width.height.equalTo(40);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(17);
        make.left.equalTo(self.icon.right).offset(17);
        make.right.equalTo(-17);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.bottom).offset(10);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.right.equalTo(-15);
        make.top.equalTo(self.time.bottom).offset(15);
    }];
    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom).offset(11);
        make.left.equalTo(self.name);
        make.right.equalTo(-15);
//        make.height.equalTo(40);
    }];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.question.bottom).offset(15);
        make.height.equalTo(8);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
}

@end
