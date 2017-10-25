//
//  YYAnswerCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAnswerCell.h"
#import "UIView+YYCategory.h"
#import "YYAnswerModel.h"

@implementation YYAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
    }
    return self;
}

- (void)setModel:(YYAnswerModel *)model {
    
    _model = model;
    self.question.text = model.qucotent;
    self.answer.text = model.content;
    self.time.text = model.posttime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon cutRoundView];
}

- (void)configSubView {
    
//    UIImageView *icon = [[UIImageView alloc] init];
//    self.icon = icon;
//    [self.contentView addSubview:icon];
//    
    UILabel *question = [[UILabel alloc] init];
    question.textColor = TitleColor;
    question.font = TitleFont;
    self.question = question;
    [self.contentView addSubview:question];
    
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

    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    [self.answer makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.question);
        make.right.equalTo(-15);
        make.top.equalTo(self.question.bottom).offset(YYInfoCellCommonMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.answer.bottom).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-15);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
}

@end
