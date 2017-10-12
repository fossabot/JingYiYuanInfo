//
//  YYSearchResultCell.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSearchResultCell.h"

@implementation YYSearchResultCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.title];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}


- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = SubTitleFont;
        _title.textColor = SubTitleColor;
        _title.numberOfLines = 0;
    }
    return _title;
}

@end
