//
//  YYTabBar.m
//  壹元服务
//
//  Created by VINCENT on 2017/5/4.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYTabBar.h"

@interface YYTabBar()

@property (nonatomic, assign) NSUInteger previousClickedTag;

@end


@implementation YYTabBar



+ (void)initialize {
    
}


//在layoutSubvews布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //遍历子控件
    NSInteger i = 0;
    for (UIButton *tabbarButton in self.subviews) {
        //找到tabbaritem
        if ([tabbarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //绑定tag 标识
            tabbarButton.tag = i;
            i++;

            //监听tabbar的点击.
            [tabbarButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}


#pragma mark -- tabbar delegate按钮的点击
- (void)tabbarButtonClick:(UIControl *)tabbarBtn{
    //判断当前按钮是否为上一个按钮并且点击的是第一个
    if (self.previousClickedTag == tabbarBtn.tag && tabbarBtn.tag == 0) {
        //监听重复点击同一个tabbaritem
        [[NSNotificationCenter defaultCenter] postNotificationName:
         YYTabbarItemDidRepeatClickNotification object:nil];
        
    }
    self.previousClickedTag = tabbarBtn.tag;

}


@end
