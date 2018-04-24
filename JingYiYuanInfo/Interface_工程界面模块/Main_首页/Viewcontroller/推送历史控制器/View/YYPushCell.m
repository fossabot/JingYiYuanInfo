//
//  YYPushCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushCell.h"
#import "YYPushListCellModel.h"

@interface YYPushCell()


/** redDot*/
@property (nonatomic, strong) UIImageView *redDot;

/** time*/
@property (nonatomic, strong) UILabel *time;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** content*/
@property (nonatomic, strong) UILabel *content;

/** extendBtn*/
@property (nonatomic, strong) UIButton *extendBtn;

@end

@implementation YYPushCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubView];
    }
    return self;
}

- (void)setPushModel:(YYPushListCellModel *)pushModel {
    
    _pushModel = pushModel;
    self.content.attributedText = [pushModel pushAttributedString];
    self.time.text = pushModel.checktime;
    self.title.text = pushModel.keyword1;
    self.extendBtn.hidden = !pushModel.isHaveExtendBtn;
    self.extendBtn.selected = pushModel.extendState;
}

/** 展开cell或者闭合*/
- (void)extened {
    
    [self extendOrNot:self.extendBtn];
}

- (void)extendOrNot:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
    _pushModel.extendState = !sender.selected;
    if (_extendBlock) {
        _extendBlock(self, !sender.selected);
    }
}

- (void)configSubView {
    
    UILabel *time = [[UILabel alloc] init];
    time.textColor = ThemeColor;
    time.font = UnenableTitleFont;
    time.textAlignment = NSTextAlignmentRight;
    self.time = time;
    [self.contentView addSubview:time];
    
    UIView *topRedLine = [[UIView alloc] init];
    topRedLine.backgroundColor = ThemeColor;
    self.topRedLine = topRedLine;
    [self.contentView addSubview:topRedLine];
    
    UIImageView *redDot = [[UIImageView alloc] initWithImage:imageNamed(@"yyfw_push_timepoint_selected_14x14_")];
    self.redDot = redDot;
    [self.contentView addSubview:redDot];
    
    UIView *bottomRedLine = [[UIView alloc] init];
    bottomRedLine.backgroundColor = ThemeColor;
    self.bottomRedLine = bottomRedLine;
    [self.contentView addSubview:bottomRedLine];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = sysFont(18);
    title.textColor = TitleColor;
    self.title = title;
    [self.contentView addSubview:title];
    
    UILabel *content = [[UILabel alloc] init];
    content.font = TitleFont;
    content.textColor = SubTitleColor;
    content.numberOfLines = 0;
    self.content = content;
    [self.contentView addSubview:content];
    
    UIButton *extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [extendBtn setTitle:@"展开" forState:UIControlStateNormal];
    [extendBtn setTitle:@"收起" forState:UIControlStateSelected];
    extendBtn.titleLabel.font = UnenableTitleFont;
    [extendBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    [extendBtn setImage:imageNamed(@"yyfw_push_open_16x16_") forState:UIControlStateNormal];
    [extendBtn setImage:imageNamed(@"yyfw_push_close_16x16_") forState:UIControlStateSelected];
    [extendBtn addTarget:self action:@selector(extendOrNot:) forControlEvents:UIControlEventTouchUpInside];
    self.extendBtn = extendBtn;
    [self.contentView addSubview:extendBtn];
    
}

- (void)masonrySubView {
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(5);
        make.width.equalTo(40);
    }];
    
    [self.topRedLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.time.right).offset(5);
        make.height.equalTo(20);
        make.width.equalTo(1);
    }];
    
    [self.redDot makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.topRedLine);
        make.top.equalTo(self.topRedLine.bottom);
        make.centerY.equalTo(self.time);
    }];
    
    [self.bottomRedLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.redDot.bottom);
        make.left.equalTo(self.topRedLine);
        make.width.equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.redDot.right).offset(5);
        make.centerY.equalTo(self.redDot);
    }];

    [self.content makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];

    [self.extendBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.content.bottom);
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.width.equalTo(60);
        make.height.equalTo(20);
        make.bottom.equalTo(-5);
    }];

}

@end
