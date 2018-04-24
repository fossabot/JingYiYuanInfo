//
//  YYTagView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/23.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYTagView.h"
#import "YYEdgeLabel.h"

@interface YYTagView ()

/** taglable*/
@property (nonatomic, strong) YYEdgeLabel *tagLable;

@end

@implementation YYTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topMargin = 0.f;
        self.bottomMargin = 0.f;
        self.leftMargin = 0.f;
        self.rightMargin = YYInfoCellCommonMargin;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.tagLable = [[YYEdgeLabel alloc] init];
    self.tagLable.font = TagLabelFont;
    self.tagLable.textColor = ThemeColor;
    self.tagLable.layer.borderColor = ThemeColor.CGColor;
    [self addSubview:self.tagLable]; 
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.tagLable.text = self.title;
    if (![self.title isEqualToString:@""]) {
        
        [self.tagLable remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(-self.rightMargin);
        }];
    }else {
    
        [self.tagLable remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
}


@end
