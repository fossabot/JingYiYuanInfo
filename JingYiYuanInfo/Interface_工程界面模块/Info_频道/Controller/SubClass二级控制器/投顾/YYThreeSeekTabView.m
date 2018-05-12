//
//  YYThreeSeekTabView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekTabView.h"
#import "UIImage+Category.h"

@interface YYThreeSeekTabView()

/** titles*/
@property (nonatomic, strong) NSArray *titles;

/** selectIndex*/
@property (nonatomic, assign) NSInteger selectIndex;

/** selectedBtn*/
@property (nonatomic, strong) UIButton *selectedBtn;

/** bottomView*/
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YYThreeSeekTabView
{
    CGFloat buttonW;
    CGFloat buttonH;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectIndex = 200;
    }
    return self;
}

- (void)setDefaultSelectIndex:(NSInteger)defaultSelectIndex {
    
    _selectIndex = defaultSelectIndex+200;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([self.delegate respondsToSelector:@selector(titlesOfTabs)]) {
        self.titles = [[self.delegate titlesOfTabs] copy];
        int index = 200;
        buttonW = self.bounds.size.width/_titles.count;
        buttonH = self.bounds.size.height;
        for (NSString *title in self.titles) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((index-200)*buttonW, 0, buttonW, buttonH);
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:YYRGB(37, 37, 37) forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            [button setBackgroundImage:[UIImage imageWithColor:ThemeColor] forState:UIControlStateSelected];
//            [button setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
            button.tag = index;
            if (index == 200) {
                button.selected = YES;
                self.selectedBtn = button;
            }
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            index++;
        }
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, buttonH-2, buttonW, 2);
        bottomView.backgroundColor = ThemeColor;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
    }
    
}

/** 平移底部分隔View*/
- (void)trainsitBottomView:(NSInteger)index {
    
    CGRect frame = self.bottomView.frame;
    frame.origin.x = index * buttonW;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = frame;
    }];
}

/** 选中了某个item*/
- (void)click:(UIButton *)sender {
    
//    UIButton *selectedBtn = (UIButton *)[self viewWithTag:_selectIndex];
    self.selectedBtn.selected = NO;
    sender.selected = YES;
//    _selectIndex = sender.tag;
    self.selectedBtn = sender;
    
    [self trainsitBottomView:sender.tag-200];
    
    if ([self.delegate respondsToSelector:@selector(threeSeekTabViewSelectIndex:)]) {
        [self.delegate threeSeekTabViewSelectIndex:sender.tag-200];
    }
}



#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 外界调用了滑动的接口，被动选中对应的item*/
- (void)letMeSelectIndex:(NSInteger)index {
    
//    if (_selectIndex == index) {
//        return;
//    }
    UIButton *willSelectbtn = (UIButton *)[self viewWithTag:index+200];
    if (self.selectedBtn == willSelectbtn) {
        return;
    }
//    UIButton *selectedBtn = (UIButton *)[self viewWithTag:_selectIndex];

    willSelectbtn.selected = YES;
    self.selectedBtn.selected = NO;
    _selectedBtn = willSelectbtn;
    _selectIndex = index+200;
    
    [self trainsitBottomView:index];
}

- (void)setSelected:(BOOL)selected {
    
    YYLogFunc
}

@end
