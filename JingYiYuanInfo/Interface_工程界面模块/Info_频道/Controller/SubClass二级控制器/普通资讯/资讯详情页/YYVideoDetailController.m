//
//  YYVideoViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYVideoDetailController.h"
#import "YYVideoPlayerView.h"
#import "YYVideoDetailCell.h"
#import "YYBaseVideoModel.h"
#import <MJExtension/MJExtension.h>
#import "ShareView.h"
#import "THBaseTableView.h"

@interface YYVideoDetailController ()<UITableViewDelegate,UITableViewDataSource>

/** videoPlayerView*/
@property (nonatomic, strong) YYVideoPlayerView *playerView;

@property (nonatomic, strong) THBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYVideoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSubView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerView playWhenPop];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView pauseWhenPushOrPresent];
}


#pragma mark  网络请求区域   -------------------------------------------

- (void)loadData {

    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"randomvideo",@"act",self.videoId,@"vid", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:channelNewsUrl parameters:para success:^(id response) {
        
        if (response) {
            
            self.dataSource = [YYBaseVideoModel mj_objectArrayWithKeyValuesArray:response[@"v_arr"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}



- (void)configSubView {
    
    UIView *statusView = [[UIView alloc] init];
//                          WithFrame:CGRectMake(0, 0, kSCREENWIDTH, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusView];
    
    self.playerView = [[YYVideoPlayerView alloc] init];
//                       WithFrame:CGRectMake(0, 20, kSCREENWIDTH, kSCREENWIDTH*9/16+55)];
    self.playerView.videoURL = self.videoURL;
    self.playerView.videoTitle = self.videoTitle;
    self.playerView.seekTime = self.seekTime;
    self.playerView.placeHolderImageUrl = self.placeHolderImageUrl;
    YYWeakSelf
    self.playerView.backBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.playerView.shareBlock = ^{
      
        [weakSelf shareVideo];
    };
    
    [self.view addSubview:self.playerView];
    
    [self.view addSubview:self.tableView];
    
    [statusView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(20);
    }];
    
    [self.playerView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(statusView.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(kSCREENWIDTH*9/16+55);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.playerView.bottom).offset(YYInfoCellCommonMargin);
        make.left.right.bottom.equalTo(self.view);
    }];

    
}

/* 分享视频*/
- (void)shareVideo {
    
    [ShareView shareWithTitle:self.videoTitle subTitle:@"" webUrl:[NSString stringWithFormat:@"%@%@",shareVideoJointUrl,self.videoId] imageUrl:self.placeHolderImageUrl isCollected:NO shareViewContain:nil shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}

#pragma mark tableview 代理方法  ---------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYBaseVideoModel *model = self.dataSource[indexPath.row];
    self.playerView.videoURL = [NSURL URLWithString:model.v_url];
    self.playerView.videoTitle = model.v_name;
    self.playerView.seekTime = 0;
    self.playerView.placeHolderImageUrl = model.v_picture;
    self.videoURL = [NSURL URLWithString:model.v_url];
    self.videoId = model.videoId;
    self.videoTitle = model.v_name;
    self.placeHolderImageUrl = model.v_picture;
    [self.playerView changePlayItem];
}

#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:YYVideoDetailCellId];
    YYBaseVideoModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}


#pragma mark  懒加载方法区域   -------------------------------------------

- (THBaseTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YYVideoDetailCell class] forCellReuseIdentifier:YYVideoDetailCellId];
        
        YYWeakSelf
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf loadData];
        };
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
