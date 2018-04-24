//
//  YYBackOrderSucceedController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/2/5.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBackOrderSucceedController.h"
#import "UIViewController+BackButtonHandler.h"

@interface YYBackOrderSucceedController ()

@end

@implementation YYBackOrderSucceedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pop:(id)sender {
    
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController:self.navigationController.viewControllers[index-2] animated:YES];
}


- (BOOL)navigationShouldPopOnBackButton {
    
    [self pop:nil];
    return NO;
}




@end
