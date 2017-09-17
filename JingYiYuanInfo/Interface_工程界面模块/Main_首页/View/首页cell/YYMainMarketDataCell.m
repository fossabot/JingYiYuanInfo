//
//  YYMainMarketDataCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainMarketDataCell.h"

@interface YYMainMarketDataCell()

/** label*/
@property (nonatomic, strong) UILabel *label;

@end
@implementation YYMainMarketDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.label];
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(50);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.label.frame = self.contentView.bounds;
}


- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"这里是行情数据，暂无数据";
        _label.numberOfLines = 0;
        _label.font = sysFont(17);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

/**
 *  创建子控件
 */
- (void)createSubview {
    
}

@end
