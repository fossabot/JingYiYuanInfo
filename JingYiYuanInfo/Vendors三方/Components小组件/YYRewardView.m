//
//  YYRewardView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYRewardView.h"
#import "NSArray+Sudoku.h"

@interface YYRewardView()

/** containerView*/
@property (nonatomic, strong) UIView *containerView;

/** containerTop 内容视图的顶部*/
@property (nonatomic, strong) UIView *containerTop;

/** containerMiddle 内容视图的中部*/
@property (nonatomic, strong) UIView *containerMiddle;

/** containerBottom 内容视图的底部*/
@property (nonatomic, strong) UIView *containerBottom;



/** integerationArr积分数组*/
@property (nonatomic, strong) NSArray *integerationArr;

@end

@implementation YYRewardView
{
    NSInteger _index;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self configSubView];
        
        [kKeyWindow addSubview:self];
        
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
    
    UIView *containerTop = [[UIView alloc] init];
    containerTop.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:containerTop];
    self.containerTop = containerTop;
    
    UIView *containerMiddle = [[UIView alloc] init];
    containerMiddle.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:containerMiddle];
    self.containerMiddle = containerMiddle;
    
    UIView *containerBottom = [[UIView alloc] init];
    containerBottom.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:containerBottom];
    self.containerBottom = containerBottom;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:close];
    
    UIButton *top = [UIButton buttonWithType:UIButtonTypeCustom];
    [top setTitle:@"打赏数额" forState:UIControlStateNormal];
    [top setImage:imageNamed(@"community_rewardalert_25x25_") forState:UIControlStateNormal];
    top.userInteractionEnabled = NO;
    [self.containerTop addSubview:top];
    
    int i = 0;
    for (NSNumber *integeration in self.integerationArr) {
        
        NSInteger fen = [integeration integerValue];
        UIButton *integerationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        integerationBtn.tag = i;
        [integerationBtn setTitle:[NSString stringWithFormat:@"%ld分",fen] forState:UIControlStateNormal];
        [integerationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [integerationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [integerationBtn addTarget:self action:@selector(chooseIntegration:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerMiddle addSubview:integerationBtn];
        
        i++;
    }
    
    UIButton *reward = [UIButton buttonWithType:UIButtonTypeCustom];
    [reward setTitle:@"确认打赏" forState:UIControlStateNormal];
    [reward addTarget:self action:@selector(reward:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerBottom addSubview:reward];
    
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self);
        make.centerY.equalTo(YYInfoCellCommonMargin*2);
        make.width.height.equalTo(afterScale(self.bounds.size.width));
    }];
    
    [self.containerTop makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.containerView);
        make.height.equalTo(50);
        make.top.equalTo(self.containerView);
    }];
    
    [self.containerBottom makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.containerView);
        make.height.equalTo(100);
        make.bottom.equalTo(self.containerView);
    }];
    
    [self.containerMiddle makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.containerTop.bottom);
        make.width.equalTo(self.containerView);
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerBottom.top);
    }];
    
    [top makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.containerTop);
    }];
    
    //九宫格
    [self.containerMiddle.subviews mas_distributeSudokuViewsWithFixedItemWidth:0    fixedItemHeight:0
                                                              fixedLineSpacing:0 fixedInteritemSpacing:0
                                                                     warpCount:3
                                                                    topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
    
    
    [reward makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.containerBottom);
        make.height.equalTo(self.containerBottom.height).multipliedBy(0.5);
        make.width.equalTo(self.containerBottom.width).multipliedBy(0.5);
    }];
    
}


/** 选中了相应的积分按钮*/
- (void)chooseIntegration:(UIButton *)sender {
    
    if (_index == sender.tag) {
        YYLog(@"打赏就打赏，别老是打我啊，又没用");
        return;
    }
    if (_index != NSNotFound) {
        
        UIButton *selectedBtn = [self.containerMiddle viewWithTag:_index];
        selectedBtn.selected = NO;
        selectedBtn.backgroundColor = [UIColor whiteColor];
    }
    sender.selected = YES;
    sender.backgroundColor = ThemeColor;
    _index = sender.tag;
}

/** 打赏*/
- (void)reward:(UIButton *)sender {
    if (_index == NSNotFound) {
        [SVProgressHUD showErrorWithStatus:@"请先选择打赏的积分"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    NSNumber *num = self.integerationArr[_index];
    YYLog(@"打赏了%ld分",[num integerValue]);
    if (_rewardBlock) {
        _rewardBlock([num integerValue]);
    }
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
