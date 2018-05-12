//
//  YYChannelShowRecommendSubCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelShowRecommendSubCell.h"
#import "UIView+YYCategory.h"

@interface YYChannelShowRecommendSubCell()

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YYChannelShowRecommendSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        [self.imageView cutCornerRect:CGRectMake(0, 0, 120, 90) radius:10];
    }
    return self;
}


- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = imgUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:imageNamed(placeHolderMini)];
}




@end
