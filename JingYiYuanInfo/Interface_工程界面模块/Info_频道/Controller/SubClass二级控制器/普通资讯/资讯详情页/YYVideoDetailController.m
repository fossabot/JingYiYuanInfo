//
//  YYVideoViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYVideoDetailController.h"
#import "YYVideoPlayerView.h"

@interface YYVideoDetailController ()

/** videoPlayerView*/
@property (nonatomic, strong) YYVideoPlayerView *playerView;

@end

@implementation YYVideoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerView playWhenPop];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView pauseWhenPushOrPresent];
}

- (void)configSubView {
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusView];
    self.playerView = [[YYVideoPlayerView alloc] initWithFrame:CGRectMake(0, 20, kSCREENWIDTH, kSCREENWIDTH*9/16+55)];
    self.playerView.videoURL = self.videoURL;
    self.playerView.videoTitle = self.videoTitle;
    self.playerView.seekTime = self.seekTime;
    self.playerView.placeHolderImageUrl = self.placeHolderImageUrl;
    YYWeakSelf
    self.playerView.backBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.playerView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
