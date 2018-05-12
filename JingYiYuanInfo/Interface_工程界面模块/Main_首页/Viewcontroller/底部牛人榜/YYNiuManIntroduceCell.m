//
//  YYNiuManIntroduceCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/5/7.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManIntroduceCell.h"

@implementation YYNiuManIntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    
    self.introduceLabel = [[UILabel alloc] init];
    self.introduceLabel.textColor = YYRGB(87, 87, 87);
    self.introduceLabel.font = sysFont(14);
    self.introduceLabel.numberOfLines = 0;
    [self.contentView addSubview:self.introduceLabel];
    
    [self.introduceLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(13, 10, 13, 10));
    }];
}


@end
