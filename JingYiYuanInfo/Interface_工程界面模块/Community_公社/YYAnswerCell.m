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
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.niuhead] placeholderImage:imageNamed(placeHolderMini)];
    self.time.text = model.atime;
    self.answer.text = model.answer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon cutRoundView];
}

- (void)configSubView {
    
    UIImageView *icon = [[UIImageView alloc] init];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
//    UILabel *name = [[UILabel alloc] init];
//    name.textColor = TitleColor;
//    name.font = TitleFont;
//    self.name = name;
//    [self.contentView addSubview:name];
    
    UILabel *time = [[UILabel alloc] init];
    time.numberOfLines = 0;
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    self.time = time;
    [self.contentView  addSubview:time];
    
    UILabel *answer = [[UILabel alloc] init];
    answer.numberOfLines = 0;
    answer.font = SubTitleFont;
    answer.textColor = UnenableTitleColor;
    self.answer = answer;
    [self.contentView  addSubview:answer];
    
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(15);
        make.width.height.equalTo(30);
    }];
    
//    [self.name makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.icon.right).offset(10);
//        make.right.equalTo(-15);
//        make.top.equalTo(self.icon);
//    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-15);
        make.centerY.equalTo(self.icon);
//        make.top.equalTo(self.icon).offset(20);
    }];
    
    [self.answer makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.time);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon.bottom).offset(5);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
}

@end
