//
//  YYEmptyDataCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/17.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYEmptyDataCell.h"

@implementation YYEmptyDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
