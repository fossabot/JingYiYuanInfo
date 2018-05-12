//
//  YYRewardView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYRewardView.h"
#import "NSArray+Sudoku.h"
#import "UIImage+Category.h"
#import "UIView+YYCategory.h"

#define defaultIndex @"defaultIndex"

@interface YYRewardView()

/** containerView*/
@property (nonatomic, strong) UIView *containerView;

/** containerTop 内容视图的顶部*/
@property (nonatomic, strong) UIView *containerTop;

/** containerMiddle 内容视图的中部*/
@property (nonatomic, strong) UIView *containerMiddle;

/** containerBottom 内容视图的底部*/
@property (nonatomic, strong) UIView *containerBottom;

@property (nonatomic, strong) UIButton *reward;

/** integerationArr积分数组*/
@property (nonatomic, strong) NSArray *integerationArr;

@end

@implementation YYRewardView
{
    UIButton *_selectButton;
    NSInteger _defaultIndex;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self configSubView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)configSubView {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
//    UIView *containerTop = [[UIView alloc] init];
//    containerTop.backgroundColor = [UIColor whiteColor];
//    [self.containerView addSubview:containerTop];
//    self.containerTop = containerTop;
    
    UIView *containerMiddle = [[UIView alloc] init];
    containerMiddle.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:containerMiddle];
    self.containerMiddle = containerMiddle;
    
    UIView *containerBottom = [[UIView alloc] init];
    containerBottom.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:containerBottom];
    self.containerBottom = containerBottom;

    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:imageNamed(@"searchdelete_44x44") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:close];
    [self.containerView bringSubviewToFront:close];
    
    UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
    [top setTitle:@"打赏数额" forState:UIControlStateNormal];
    [top setTitleColor:BlackColor forState:UIControlStateNormal];
    top.titleLabel.font = NavTitleFont;
    [top setImage:imageNamed(@"community_rewardalert_25x25_") forState:UIControlStateNormal];
    top.userInteractionEnabled = NO;
    [self.containerView addSubview:top];
    
    int i = 0;
    for (NSNumber *integeration in self.integerationArr) {
        
        NSInteger fen = [integeration integerValue];
        UIButton *integerationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        integerationBtn.tag = 100+i;
        integerationBtn.titleLabel.font = sysFont(15);
        integerationBtn.layer.borderColor = LightGraySeperatorColor.CGColor;
        integerationBtn.layer.borderWidth = .5;
        [integerationBtn setTitle:[NSString stringWithFormat:@"%ld积分",fen] forState:UIControlStateNormal];
        [integerationBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [integerationBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [integerationBtn setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
        [integerationBtn setBackgroundImage:[UIImage imageWithColor:ThemeColor] forState:UIControlStateSelected];
        [integerationBtn addTarget:self action:@selector(chooseIntegration:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerMiddle addSubview:integerationBtn];
        
//        _defaultIndex = [kUserDefaults integerForKey:defaultIndex];
        
//        if (_defaultIndex == i) {
//            integerationBtn.selected = YES;
//            _selectButton = integerationBtn;
//        }
        
        i++;
    }
    
    UIButton *reward = [UIButton buttonWithType:UIButtonTypeCustom];
    [reward setTitle:@"确认打赏" forState:UIControlStateNormal];
    [reward setTitleColor:WhiteColor forState:UIControlStateNormal];
    [reward setBackgroundImage:[UIImage imageWithColor:ThemeColor] forState:UIControlStateNormal];
    [reward addTarget:self action:@selector(reward:) forControlEvents:UIControlEventTouchUpInside];
    self.reward = reward;
    [self.containerBottom addSubview:reward];
    
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.centerY.equalTo(YYInfoCellCommonMargin*2);
        make.width.height.equalTo(afterScale(250));
    }];
    
    [top makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.containerView);
        make.height.equalTo(50);
    }];
    
    [close makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.top.equalTo(top);
        make.width.height.equalTo(40);
    }];
    
//    [self.containerTop makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.top.right.equalTo(self.containerView);
//        make.height.equalTo(50);
//    }];
    
    [self.containerBottom makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.containerView);
        make.height.equalTo(80);
    }];
    
    [self.containerMiddle makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(top.bottom);
//        make.width.equalTo(self.containerView);
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerBottom.top);
    }];
    
    
    
    //九宫格
    [self.containerMiddle.subviews mas_distributeSudokuViewsWithFixedItemWidth:0
                                                               fixedItemHeight:30
                                                              fixedLineSpacing:0
                                                         fixedInteritemSpacing:0
                                                                     warpCount:3
                                                                    topSpacing:0
                                                                 bottomSpacing:0
                                                                   leadSpacing:20
                                                                   tailSpacing:20];
    
    
    [self.reward makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.containerBottom);
        make.height.equalTo(40);
        make.width.equalTo(afterScale(150));
        
    }];
    
    [self layoutIfNeeded];
    [self.containerView cutRoundViewRadius:10];
    [self.reward cutRoundViewRadius:5];
}



/** 选中了相应的积分按钮*/
- (void)chooseIntegration:(UIButton *)sender {
    
    if (_selectButton == sender) {
        YYLog(@"打赏就打赏，别老是打我啊，又没用");
        return;
    }

    _selectButton.selected = NO;
    sender.selected = YES;
    _selectButton = sender;
//    [kUserDefaults setInteger:sender.tag-100 forKey:defaultIndex];
//    [kUserDefaults synchronize];
}

/** 打赏*/
- (void)reward:(UIButton *)sender {
    
    if (!_selectButton) {
        [SVProgressHUD showErrorWithStatus:@"请先选择打赏的积分"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
   
    NSNumber *num = self.integerationArr[_selectButton.tag-100];
    YYLog(@"打赏了%ld分",[num integerValue]);
    if (_rewardBlock) {
        _rewardBlock([NSString stringWithFormat:@"%ld",[num integerValue]]);
    }
    [self dismiss];
}

/* 显示打赏界面*/
- (void)show {
    
    [kKeyWindow addSubview:self];
}

/** remove打赏界面*/
- (void)dismiss {
    
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSArray *)integerationArr{
    
    if (!_integerationArr) {
        _integerationArr = [NSArray arrayWithObjects:@10,@25,@30,@50,@60,@66,@88,@100,@120, nil];
    }
    return _integerationArr;
}

@end
