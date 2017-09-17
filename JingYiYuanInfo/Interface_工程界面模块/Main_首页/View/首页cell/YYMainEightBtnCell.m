//
//  YYMainEightBtnCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainEightBtnCell.h"
#import "UIView+YYParentController.h"

#import "YYAdviserViewController.h"  ///投顾
#import "YYBrokerViewController.h"   ///券商
#import "YYFundViewController.h"     ///基金
#import "YYProjectViewController.h"   ///项目
#import "YYProductionViewController.h" ///产品
#import "YYMarketViewController.h"     ///行情
#import "YYMineSubscriptionViewController.h" ///订阅
#import "YYMineIntegrationViewController.h"  ///积分商城


#define edgeMargin 20
#define buttonW 40
#define buttonH 60

@interface YYMainEightBtnCell()
{
    NSInteger _edgeMargin;
}
/** titles*/
@property (nonatomic, strong) NSArray *titles;

/** images*/
@property (nonatomic, strong) NSArray *images;

@end

@implementation YYMainEightBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubview];
    }
    return self;
}

/**
 *  创建子控件
 */
- (void)createSubview {
    
//    int row = 0;
//    int colum = 0;
//    CGFloat buttonSpace = (kSCREENWIDTH-edgeMargin*2-buttonW*4)/3;
//    for (int i=0; i<=7; i++) {
//        row = i % 4;
//        colum = i / 4;
//        CGFloat x = row*(buttonW+buttonSpace) + edgeMargin;
//        CGFloat y = colum*buttonH +edgeMargin;
//        BAButton *btn = [BAButton buttonWithType:UIButtonTypeCustom];
//        btn.buttonPositionStyle = BAButtonPositionStyleTop;
//        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
//        [btn setImage:imageNamed(self.images[i]) forState:UIControlStateNormal];
//        btn.titleLabel.font = sysFont(16);
//        btn.frame = CGRectMake(x, y, buttonW, buttonH);
//        btn.tag = 100+i;
//        [self.contentView addSubview:btn];
//        
//        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.buttonPositionStyle = BAButtonPositionStyleTop;
        [btn setImage:imageNamed(self.images[i]) forState:UIControlStateNormal];
        [btn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = TitleFont;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 20, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(35, -40, 0, 0)];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [arr addObject:btn];
        [self.contentView addSubview:btn];
    }
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:buttonW leadSpacing:afterScale(YYInfoCellCommonMargin*2) tailSpacing:afterScale(YYInfoCellCommonMargin*2)];
    [arr makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(YYInfoCellCommonMargin);
        make.height.equalTo(70);
    }];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i=4; i<8; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.buttonPositionStyle = BAButtonPositionStyleTop;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:SubTitleColor forState:UIControlStateNormal];
        [btn setImage:imageNamed(self.images[i]) forState:UIControlStateNormal];
        btn.titleLabel.font = TitleFont;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 20, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(35, -40, 0, 0)];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [arr1 addObject:btn];
        [self.contentView addSubview:btn];
    }
    
    UIButton *btn = arr[0];
    [arr1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:buttonW leadSpacing:afterScale(YYInfoCellCommonMargin*2) tailSpacing:afterScale(YYInfoCellCommonMargin*2)];
    [arr1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.bottom).offset(YYInfoCellCommonMargin);
        make.height.equalTo(70);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
}

/**
 *  八个icon点击事件
 */
- (void)click:(UIButton *)btn {
    
//    if (self.eightBtnBlock) {
//        
//        self.eightBtnBlock(btn.tag-100, self);
//    }

    [self enterEightController:btn.tag-100];
}


/**
 *  八个icon点击跳转相关控制器的方法
 */
- (void)enterEightController:(NSInteger)index {
    
    NSArray *controllers = @[@"YYAdviserViewController",@"YYBrokerViewController",@"YYFundViewController",@"YYProjectViewController",@"YYProductionViewController",@"YYMarketViewController",@"YYMineSubscriptionViewController",@"YYMineIntegrationViewController"];
    
    UIViewController *vc = (UIViewController *)[[NSClassFromString(controllers[index]) alloc] init];
    [[self parentNavigationController] pushViewController:vc animated:YES];
    YYLog(@"%s -- %ld - ",__func__,index);
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSArray *)titles{
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"投顾",@"券商",@"基金",@"项目",@"产品",@"行情",@"订阅",@"商城", nil];
    }
    return _titles;
}

- (NSArray *)images{
    if (!_images) {
        _images = [NSArray arrayWithObjects:
                   @"yyfw_main_adviser_40x40_",
                   @"yyfw_main_broker_40x40_",
                   @"yyfw_main_fund_40x40_",
                   @"yyfw_main_project_40x40_",
                   @"yyfw_main_prduction_40x40_",
                   @"yyfw_main_market_40x40_",
                   @"yyfw_main_subscribe_40x40_",
                   @"yyfw_main_shopping_40x40_", nil];
    }
    return _images;
}

    
@end
