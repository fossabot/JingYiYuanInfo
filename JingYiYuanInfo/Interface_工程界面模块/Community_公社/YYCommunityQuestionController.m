//
//  YYCommunityQuestionController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityQuestionController.h"
#import "YYQuestionCell.h"
#import "YYCommunityQuestionModel.h"
#import "YYCommunityQuestionVM.h"

#import <MJRefresh/MJRefresh.h>

@interface YYCommunityQuestionController ()
/** tab*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYCommunityQuestionVM *viewModel;

@end

@implementation YYCommunityQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self loadNewData];
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


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYCommunityQuestionVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYCommunityQuestionVM alloc] init];
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            //
            YYStrongSelf
            
        };
        
    }
    return _viewModel;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-64) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[YYQuestionCell class] forCellReuseIdentifier:YYQuestionCellId];
        
        YYWeakSelf
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        /** 普通闲置状态  壹元君正努力为您加载数据*/
        footer.stateLabel.text = @"壹元君正努力为您加载中...";
        _tableView.mj_footer = footer;
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        header.stateLabel.text = @"壹元君正努力为您加载中...";
        _tableView.mj_header = header;
    
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无问答数据";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.tableView emptyViewConfiger:configer];

    }
    return _tableView;
}


@end
