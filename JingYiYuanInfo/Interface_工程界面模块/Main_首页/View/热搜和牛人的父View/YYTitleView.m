//
//  YYTitleView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYTitleView.h"
#import "UILabel+ContentSize.h"

@interface YYTitleView()

/** selectedButton*/
@property (nonatomic, strong) UIButton *selectedButton;

/** liner*/
@property (nonatomic, strong) UIView *liner;

@end

@implementation YYTitleView

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, TabHeaderH+0.2)];

    if (self) {
        self.backgroundColor = WhiteColor;
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(10, TabHeaderH, kSCREENWIDTH-20, 0.2)];
        grayLine.backgroundColor = LightGraySeperatorColor;
        [self addSubview:grayLine];
        [self bringSubviewToFront:grayLine];

        CGFloat buttonW = kSCREENWIDTH/titles.count;
        CGFloat buttonH = 40;

        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(buttonW, 5, 0.7, buttonH-10)];
        verticalLine.backgroundColor = LightGraySeperatorColor;
        [self addSubview:verticalLine];
        [self bringSubviewToFront:verticalLine];
        
        int i = 0;
        for (NSString *title in titles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(i*buttonW, 0, buttonW, buttonH);
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = sysFont(18.0);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:ThemeColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (i == 0) {
                UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(10, buttonH-2, buttonW-10, 2)];
                liner.backgroundColor = ThemeColor;
//                liner.width = [button.titleLabel contentSize].width*3;
//                liner.centerX = button.centerX;
                [self addSubview:liner];
                self.liner = liner;
                self.selectedButton = button;
                button.selected = YES;
//                [self selectedItem:button];
            }
            i++;
        }
        
    }
    return self;
}


- (void)selectedItem:(UIButton *)button {
    YYLog(@"button frame : %@",NSStringFromCGRect(button.frame));
    _selectedButton.selected = NO;
    button.selected = !button.selected;
//    CGFloat distanceX = button.x == 0 ? -button.width+10 : button.width-10;
    CGFloat x = button.x == 0 ? 10 : button.x;
//    self.liner.frame.origin.x = button.centerX;
    [UIView animateWithDuration:0.2 animations:^{
//        self.liner.transform = CGAffineTransformMakeTranslation(distanceX, 0);
        self.liner.x = x;
        
    } completion:^(BOOL finished) {
        if (_selectedBlock) {
            _selectedBlock(button.tag);
        }        
    }];
    _selectedButton = button;
}



@end
