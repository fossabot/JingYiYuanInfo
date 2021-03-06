//
//  YYIOTableViewCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIOTableViewCell.h"

@implementation YYIOTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
    }
    return self;
}


- (void)configSubView {

    self.title = [[UILabel alloc] init];
    self.title.textColor = TitleColor;
    self.title.font = TitleFont;
    [self.contentView addSubview:self.title];
    
    self.desc = [[UILabel alloc] init];
    self.desc.textColor = UnenableTitleColor;
    self.desc.font = UnenableTitleFont;
    [self.contentView addSubview:self.desc];
    
    self.integration = [[UILabel alloc] init];
    self.integration.textColor = ThemeColor;
    self.integration.font = SubTitleFont;
    [self.integration setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.integration setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.integration];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.right.equalTo(self.integration.left).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.desc makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.title);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.integration makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    
}


@end
