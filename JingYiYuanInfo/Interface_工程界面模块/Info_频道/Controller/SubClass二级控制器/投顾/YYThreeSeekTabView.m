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

@end

@implementation YYThreeSeekTabView

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
        CGFloat buttonW = self.bounds.size.width/_titles.count;
        CGFloat buttonH = self.bounds.size.height;
        for (NSString *title in self.titles) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((index-200)*buttonW, 0, buttonW, buttonH);
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:ThemeColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
            button.tag = index;
            if (index == 200) {
                button.selected = YES;
                self.selectedBtn = button;
            }
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            index++;
        }
    }
    
}

- (void)click:(UIButton *)sender {
    
//    UIButton *selectedBtn = (UIButton *)[self viewWithTag:_selectIndex];
    self.selectedBtn.selected = NO;
    sender.selected = YES;
//    _selectIndex = sender.tag;
    self.selectedBtn = sender;
    if ([self.delegate respondsToSelector:@selector(threeSeekTabViewSelectIndex:)]) {
        [self.delegate threeSeekTabViewSelectIndex:sender.tag-200];
    }
}



#pragma mark -- inner Methods 自定义方法  -------------------------------

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
}

- (void)setSelected:(BOOL)selected {
    
    YYLogFunc
}

@end
