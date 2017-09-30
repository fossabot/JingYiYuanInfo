//
//  YYSubscribleSettingCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSubscribleSettingCell.h"

@interface YYSubscribleSettingCell()

/** redDot*/
@property (nonatomic, strong) UIView *redDot;


@end


@implementation YYSubscribleSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    
    UIView *redDot = [[UIView alloc] init];
    redDot.backgroundColor = ThemeColor;
    [self.contentView addSubview:redDot];
    self.redDot = redDot;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = [UIColor blackColor];
    [self.contentView addSubview:title];
    self.title = title;
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.font = UnenableTitleFont;
    subTitle.textColor = UnenableTitleColor;
    [self.contentView addSubview:subTitle];
    self.subTitle = subTitle;
    
    UISwitch *switchBtn = [[UISwitch alloc] init];
    switchBtn.onTintColor = ThemeColor;
//    switchBtn.thumbTintColor = ThemeColor;
    [switchBtn addTarget:self action:@selector(switchSelect:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchBtn];
    self.switchBtn = switchBtn;
    
    
    [self.redDot makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(20);
        make.width.height.equalTo(4);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.redDot.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.contentView.centerY).offset(-5);
    }];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.title);
        make.top.equalTo(self.contentView.centerY).offset(5);
    }];
    
    [self.switchBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(-20);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(40);
        make.height.equalTo(20);
    }];
    
    
}


- (void)switchSelect:(UISwitch *)switchBtn {
    
    YYWeakSelf
    if (_switchBlock) {
        _switchBlock(weakSelf, switchBtn.isOn);
    }
}


@end
