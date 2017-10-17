//
//  YYBuyIntegralController.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBuyIntegralController.h"
#import "UIImage+Category.h"
#import "YYIAPTool.h"

#define integralBuyUrl @"http://yyapp.1yuaninfo.com/app/application/applepay/integral_1.php"

@interface YYBuyIntegralController ()

@end

@implementation YYBuyIntegralController
{
    UIButton *_selectedBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买积分";
    
    [self configSubView];
}


- (void)configSubView {
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, kSCREENWIDTH, 20)];
    tip.text = @"* 具体积分细则解释权归壹元服务所有(积分套餐如下)";
    tip.font = UnenableTitleFont;
    tip.textColor = UnenableTitleColor;
    tip.numberOfLines = 0;
    [self.view addSubview:tip];
    
    
    CGFloat leadingMargin = 20;
    CGFloat trailingMargin = 20;
    CGFloat rowMargin = 10;//横向间距
    CGFloat lineMargin = 20;//竖向间距
    CGFloat buttonW = (kSCREENWIDTH-leadingMargin-trailingMargin-2*rowMargin)/3;
    CGFloat buttonH = 60;
    
    UIButton *_lastBtn;
    for (int i=0; i<6; i++) {
        
        UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
        buy.tag = i;
        [buy setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
        [buy setBackgroundImage:[UIImage imageWithColor:ThemeColor] forState:UIControlStateSelected];
//        [buy setTitleColor:ThemeColor forState:UIControlStateNormal];
//        [buy setTitleColor:WhiteColor forState:UIControlStateSelected];
        buy.layer.borderColor = ThemeColor.CGColor;
        buy.layer.borderWidth = 2.f;
        [buy setAttributedTitle:[self AttributeTitles:i color:ThemeColor] forState:UIControlStateNormal];
        [buy setAttributedTitle:[self AttributeTitles:i color:WhiteColor] forState:UIControlStateSelected];
        [buy addTarget:self action:@selector(chooseIntegral:) forControlEvents:UIControlEventTouchUpInside];
        
        buy.frame = CGRectMake(leadingMargin+(buttonW+rowMargin)*(i%3), 100 + (lineMargin + buttonH)*(i/3), buttonW, buttonH);
        
        [self.view addSubview:buy];
        _lastBtn = buy;
    }
    
    UIButton *buyIntegral = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyIntegral setTitle:@"购买积分" forState:UIControlStateNormal];
    buyIntegral.backgroundColor = ThemeColor;
    [buyIntegral setTitleColor:WhiteColor forState:UIControlStateNormal];
    [buyIntegral addTarget:self action:@selector(buyIntegral:) forControlEvents:UIControlEventTouchUpInside];
    buyIntegral.frame = CGRectMake(20, CGRectGetMaxY(_lastBtn.frame)+30, kSCREENWIDTH-40, 50);
    [self.view addSubview:buyIntegral];
}


//选择积分
- (void)chooseIntegral:(UIButton *)sender {
    
    sender.selected = !sender.selected;
//    [sender setAttributedTitle:[self AttributeTitles:sender.tag color:WhiteColor] forState:UIControlStateNormal];
    if (_selectedBtn) {
        _selectedBtn.selected = NO;
//        [_selectedBtn setAttributedTitle:[self AttributeTitles:_selectedBtn.tag color:ThemeColor] forState:UIControlStateNormal];
    }
    _selectedBtn = sender;
 
}

//购买积分
- (void)buyIntegral:(UIButton *)sender {
    if (!_selectedBtn) {
        [SVProgressHUD showImage:nil status:@"请选择相应积分"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    NSString *productId = [[self productionIdentifiers] objectAtIndex:_selectedBtn.tag];
    [YYIAPTool buyProductByProductionId:productId type:@"4"];
}


- (NSAttributedString *)AttributeTitles:(NSInteger)index color:(UIColor *)color{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    NSString *integral = [[self integrals] objectAtIndex:index];
    NSAttributedString *attr0 = [[NSAttributedString alloc] initWithString:integral attributes:@{NSFontAttributeName:sysFont(afterScale(18)),NSForegroundColorAttributeName:color}];
    NSString *money = [[self money] objectAtIndex:index];
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:money attributes:@{NSFontAttributeName:sysFont(14),NSForegroundColorAttributeName:color}];
    [attributeStr appendAttributedString:attr0];
    [attributeStr appendAttributedString:attr1];
    
    return attributeStr;
}

- (NSArray *)integrals {
    
    NSMutableArray *arr = [NSMutableArray array];
    [YYHttpNetworkTool GETRequestWithUrlstring:integralBuyUrl parameters:nil success:^(id response) {
        
        if (response) {
            for (NSString *key in [self money]) {
                NSString *value = [NSString stringWithFormat:@"%@/",response[key]];
                [arr addObject:value];
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
    if (arr.count) {
        
        return arr;
    }else {
        
        return @[@"360/",@"1500/",@"1800/",@"3000/",@"3600/",@"5280/"];
    }
}

- (NSArray *)money {
    
    return @[@"￥6",@"￥25",@"￥30",@"￥50",@"￥60",@"￥88"];
}

- (NSArray *)productionIdentifiers {
    
    return @[@"com.yyapp_vip_6",@"com.yyapp_vip_25",@"com.yyapp_vip_30",@"com.yyapp_vip_50",@"com.yyapp_vip_60",@"com.yyapp_vip_88"];
}

@end
