//
//  YYEightBtn.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/5/8.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYEightBtn.h"


@interface YYEightBtn ()

/** image*/
@property (nonatomic, strong) UIImageView *topImage;

/** title*/
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YYEightBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    if (self.imageRect.size.width) {
        
        self.topImage.frame = self.imageRect;
    }else {
        self.topImage.frame = CGRectMake(0, 0, width, width);
    }
    
    if (self.titleRect.size.width) {
        
        self.titleLabel.frame = self.titleRect;
    }else {
        
        self.titleLabel.frame = CGRectMake(0, width+self.titleMargin, width, height-width-self.titleMargin);
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [self.topImage setImage:[UIImage imageNamed:imageName]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

/** 初始化*/
- (void)initConfig {
    
    self.titleColor = TitleColor;
    self.buttonFont = 14;
    self.titleMargin = 5;
    
    UIImageView *topImageView = [[UIImageView alloc] init];
//    topImageView.contentMode = UIViewContentModeCenter;
    self.topImage = topImageView;
    [self addSubview:topImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = sysFont(self.buttonFont);
    titleLabel.textColor = self.titleColor;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setButtonFont:(CGFloat)buttonFont {
    _buttonFont = buttonFont;
    self.titleLabel.font = sysFont(buttonFont);
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    self.topImage.contentMode = contentMode;
}

@end
