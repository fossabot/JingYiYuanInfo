//
//  YYAnswerCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAnswerCell.h"
#import "UIView+YYCategory.h"

@implementation YYAnswerCell

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
    
    UILabel *answer = [[UILabel alloc] init];
    answer.numberOfLines = 0;
    answer.font = SubTitleFont;
    answer.textColor = UnenableTitleColor;
    self.answer = answer;
    [self.contentView  addSubview:answer];
    
    UILabel *time = [[UILabel alloc] init];
    time.numberOfLines = 0;
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    self.time = time;
    [self.contentView  addSubview:time];
    
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(50);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(10);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon);
    }];
    
    [self.answer makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon.bottom).offset(5);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.answer.bottom).offset(10);
        make.height.equalTo(15);
    }];
    
}

@end
