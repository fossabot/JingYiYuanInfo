//
//  YYMainDetailViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  

#import "YYMainDetailViewController.h"

#import "ShareView.h"

@interface YYMainDetailViewController ()

@end

@implementation YYMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStyleDone target:self action:@selector(click)];
    
//    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)click {
    
    [ShareView shareWithTitle:@"壹元服务" subTitle:@"壹元服务为您服务" webUrl:@"www.baidu.com" imageUrl:nil isCollected:YES shareViewContain:ShareViewTypeQQ | ShareViewTypeFavor | ShareViewTypeWechat shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
