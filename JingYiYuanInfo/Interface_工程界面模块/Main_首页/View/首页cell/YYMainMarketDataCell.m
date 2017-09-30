//
//  YYMainMarketDataCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainMarketDataCell.h"

@implementation YYMainMarketDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.dataImageView];
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self.dataImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(kSCREENWIDTH*0.25);
    }];
}


- (UIImageView *)dataImageView{
    if (!_dataImageView) {
        _dataImageView = [[UIImageView alloc] init];
    }
    return _dataImageView;
}

@end
