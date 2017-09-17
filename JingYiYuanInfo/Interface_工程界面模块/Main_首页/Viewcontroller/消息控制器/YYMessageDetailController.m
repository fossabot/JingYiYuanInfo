//
//  YYMessageDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMessageDetailController.h"

@interface YYMessageDetailController ()

@end

@implementation YYMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)share {
    
    [ShareView shareWithTitle:self.shareTitle subTitle:@"" webUrl:self.url imageUrl:nil isCollected:NO shareViewContain:ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeMicroBlog shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
