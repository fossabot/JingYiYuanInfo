//
//  YYEmptyView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYEmptyView.h"

@interface YYEmptyView()

@property (nonatomic, copy) void(^clickBlock)();
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, copy) NSString *title;

@end

@implementation YYEmptyView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img title:(NSString *)title viewClick:(void (^)())clickBlock {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clickBlock = clickBlock;
        self.img = img;
        [self setupSubViews];
    }
    return self;
    
}


- (void)setupSubViews
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.img];
    
    [self addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *tip = [[UILabel alloc] init];
    tip.text = self.title;
    tip.textColor = [UIColor lightGrayColor];
    tip.font = [UIFont systemFontOfSize:14];
    [tip sizeToFit];
    [self addSubview:tip];
    self.tip = tip;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView:)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.center = CGPointMake(self.center.x, self.center.y - 64);
    self.tip.center = CGPointMake(self.center.x, self.center.y-20);
    
}

- (void)clickImgView:(UITapGestureRecognizer *)recognizer
{
    self.clickBlock();
}


@end
