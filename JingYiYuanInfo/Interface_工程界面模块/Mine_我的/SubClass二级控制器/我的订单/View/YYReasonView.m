//
//  YYReasonView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYReasonView.h"

@interface YYReasonView  ()

/** selectedBtn*/
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation YYReasonView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubView];
    }
    return self;
}


- (void)createSubView {
    
    UILabel *title = [[UILabel alloc] init];
    
    title.font = TitleFont;
    title.textColor = SubTitleColor;
    self.title = title;
    [self addSubview:title];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [selectedBtn setImage:imageNamed(@"reason_normal") forState:UIControlStateNormal];
    [selectedBtn setImage:imageNamed(@"reason_selected") forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = selectedBtn;
    [self addSubview:selectedBtn];
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)select:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.selected = sender.selected;
    if (_reasonBlock) {
        _reasonBlock(sender.selected);
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.selectedBtn.frame = CGRectMake(self.bounds.size.width-30, 5, 20, 20);
    self.selectedBtn.selected = self.selected;
    self.title.frame = CGRectMake(0, 0, self.bounds.size.width-30, 30);
}

@end
