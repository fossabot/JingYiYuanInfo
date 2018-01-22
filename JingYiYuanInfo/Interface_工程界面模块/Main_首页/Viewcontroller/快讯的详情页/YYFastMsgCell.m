//
//  YYFastMsgCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYFastMsgCell.h"

@implementation YYFastMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubview];
    }
    return self;
}


- (void)configSubview {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(YYCommonCellLeftMargin, 15, kSCREENWIDTH-YYInfoCellCommonMargin*2, 20)];
    title.font = TitleFont;
    title.textColor = SubTitleColor;
    self.title = title;
    [self.contentView addSubview:title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
