//
//  YYMainMessageCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainMessageCell.h"

@implementation YYMainMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubview];
    }
    return self;
}


- (void)configSubview {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kSCREENWIDTH - 100, 20)];
    title.font = TitleFont;
    title.textColor = TitleColor;
    self.title = title;
    [self.contentView addSubview:title];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
