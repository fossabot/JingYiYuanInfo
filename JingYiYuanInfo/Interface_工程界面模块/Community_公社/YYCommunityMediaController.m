//
//  YYCommunityMediaController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  公社视频

#import "YYCommunityMediaController.h"

#import "THBaseTableView.h"
#import "YYCommunityMediaModel.h"
#import "YYCommunityMediaVM.h"
#import "YYCommunityMediaCell.h"

#import <MJRefresh/MJRefresh.h>

@interface YYCommunityMediaController ()

/** tab*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYCommunityMediaVM *viewModel;

@end

@implementation YYCommunityMediaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self loadNewData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resetVideoPlayer];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  加载最新数据
 */
- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        if (success) {
            [strongSelf.tableView reloadData];
        }
    }];
    
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [strongSelf.tableView reloadData];
        }
    }];
}



/** 重置视频播放器，暂停播放*/
- (void)resetVideoPlayer {
    
    [self.viewModel resetPlayer];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYCommunityMediaVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYCommunityMediaVM alloc] init];
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            
        };
        
    }
    return _viewModel;
}



- (THBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTabBarH, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerClass:[YYCommunityMediaCell class] forCellReuseIdentifier:YYCommunityMediaCellId];
        
        YYWeakSelf
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
        [footer setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = footer;
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        [header setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.mj_footer.hidden = YES;
        };
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}




@end
