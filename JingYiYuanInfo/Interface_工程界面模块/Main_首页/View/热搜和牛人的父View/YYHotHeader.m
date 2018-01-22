//
//  YYHotHeader.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotHeader.h"
#import "ButtonContainer.h"


@interface YYHotHeader()<ButtonContainerClickDelegate>

/** 猜你喜欢*/
@property (nonatomic, strong) UIView *caiView;

/** 换一批*/
@property (nonatomic, strong) UIButton *huanButton;

/** 标签区*/
@property (nonatomic, strong) ButtonContainer *tagZone;


@end

@implementation YYHotHeader

- (instancetype)initWithDatas:(NSArray *)datas {
    self = [[YYHotHeader alloc] initWithFrame:CGRectZero];
    if (self) {
        _datas = [datas copy];
        
        [self addSubview:self.caiView];
        
        [self addSubview:self.huanButton];
        
        [self addSubview:self.tagZone];
        
        [self renderUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas {
    _datas = [datas copy];
    
    [self.tagZone setTitles:datas];
    [self renderUI];
}


- (void)renderUI {
    
    self.bounds = CGRectMake(0, 0, kSCREENWIDTH, CGRectGetMaxY(self.tagZone.frame)+YYInfoCellCommonMargin);
}


- (void)change {
    
    if (self.changeBlock) {
        self.changeBlock();
    }
    
}


#pragma mark -- buttoncontainer 的代理方法
/** 选中哪个button*/
- (void)buttonContainerDidClickAtIndex:(NSInteger)index andTitle:(NSString *)title {
    
//    self.datas[index]
    if (self.changeTagBlock) {
        self.changeTagBlock(index);
    }
    YYLog(@"选中了button ： %@, index : %ld",title,(long)index);
    
}


- (UIView *)caiView {
    if (!_caiView) {
        _caiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _caiView.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 12, 3, 15)];
        redview.backgroundColor = ThemeColor;
        [_caiView addSubview:redview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 70, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"猜你喜欢";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = TitleFont;
        label.textColor = SubTitleColor;
        [_caiView addSubview:label];

    }
    return _caiView;
}

- (UIButton *)huanButton {
    if (!_huanButton) {
        _huanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _huanButton.frame = CGRectMake(kSCREENWIDTH-90, 10, 80, 20);
        [_huanButton setTitle:@"换一批" forState:UIControlStateNormal];
        _huanButton.titleLabel.font = SubTitleFont;
        [_huanButton setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [_huanButton setImage:imageNamed(@"refresh_20x20_") forState:UIControlStateNormal];
        [_huanButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    }
    return _huanButton;
}

- (ButtonContainer *)tagZone {
    if (!_tagZone) {
        _tagZone = [[ButtonContainer alloc] initWithTitles:_datas andFrame:CGRectMake(0, CGRectGetMaxY(self.caiView.frame), kSCREENWIDTH, 0) delegate:self];
        _tagZone.itemEdgeInset = UIEdgeInsetsMake(3, 5, 3, 5);
    }
    return _tagZone;
}


@end
