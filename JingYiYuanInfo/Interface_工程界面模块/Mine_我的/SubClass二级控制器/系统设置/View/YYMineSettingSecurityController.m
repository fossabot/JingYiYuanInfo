//
//  YYMineSttingSecurityController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineSettingSecurityController.h"
#import "YYChangePwdController.h"
#import "YYChangePhoneNumViewController.h"
#import "WRCellView.h"

@interface YYMineSettingSecurityController ()

@end

@implementation YYMineSettingSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WRCellView *changeTel = [[WRCellView alloc] initWithFrame:CGRectMake(0, 10, kSCREENWIDTH, 44) lineStyle:WRCellStyleLabel_Indicator];
    [self.baseScrollView addSubview:changeTel];
    YYWeakSelf
    changeTel.tapBlock = ^{//改变手机号
        YYStrongSelf
        YYChangePhoneNumViewController *changeTelVc = [[YYChangePhoneNumViewController alloc] init];
//        [strongSelf.rt_navigationController pushViewController:changeTelVc animated:YES complete:nil];
        [strongSelf.navigationController pushViewController:changeTelVc animated:YES];
    };
    
    WRCellView *changePwd = [[WRCellView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(changeTel.frame), kSCREENWIDTH, 44) lineStyle:WRCellStyleLabel_Indicator];
    [self.baseScrollView addSubview:changePwd];
    changePwd.tapBlock = ^{//改变密码
        YYStrongSelf
        YYChangePwdController *changePwdVc = [[YYChangePwdController alloc] init];
//        [strongSelf.rt_navigationController pushViewController:changePwdVc animated:YES complete:nil];
        [strongSelf.navigationController pushViewController:changePwdVc animated:YES];
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
