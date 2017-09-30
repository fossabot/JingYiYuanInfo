//
//  YYPeriodCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPeriodCell.h"
#import "YYPeriodModel.h"
#import "UIView+YYCategory.h"

@interface YYPeriodCell()

/** title*/
@property (nonatomic, strong) UILabel *title;

/** redDot*/
@property (nonatomic, strong) UIView *redDot;

/** redLine*/
@property (nonatomic, strong) UIView *redLine;

/** source来源*/
@property (nonatomic, strong) UILabel *brief;

/** time时间*/
@property (nonatomic, strong) UILabel *time;


@end


@implementation YYPeriodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubview];
    }
    return self;
}

- (void)setModel:(YYPeriodModel *)model {
    _model = model;
    
    self.title.text = model.title;
    self.brief.text = model.brief;
    self.time.text = model.time;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.redDot cutRoundView];
}

/**
 *  创建子控件
 */
- (void)configSubView {
    
    UIView *redDot = [[UIView alloc] init];
    redDot.backgroundColor = ThemeColor;
    self.redDot = redDot;
    [self.contentView addSubview:redDot];
    
    UIView *redLine = [[UIView alloc] init];
    redLine.backgroundColor = ThemeColor;
    self.redLine = redLine;
    [self.contentView addSubview:redLine];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
//    title.numberOfLines = 1;
    [self.contentView addSubview:title];
    self.title = title;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    [self.contentView addSubview:time];
    self.time = time;
 
    UILabel *brief = [[UILabel alloc] init];
    brief.font = SubTitleFont;
    brief.textColor = SubTitleColor;
    [self.contentView addSubview:brief];
    self.brief = brief;
}

/**
 配置子控件的约束
 */
- (void)masonrySubview {
    
    [self.redDot makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(15);
        make.width.height.equalTo(10);
    }];
    
    [self.redLine makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(2);
        make.top.equalTo(self.redDot.bottom);
        make.centerX.equalTo(self.redDot);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {//设置第一个cell的标题label约束
        
        make.top.equalTo(self.redDot);
        make.left.equalTo(self.redDot.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.brief makeConstraints:^(MASConstraintMaker *make) {//来源label的约束
        
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.contentView.bottom).offset(-YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {//时间label的约束
        
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.bottom).offset(5);
        make.bottom.equalTo(self.brief.top).offset(-YYInfoCellSubMargin);
        
    }];
    
}
@end
