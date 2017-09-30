//
//  YYCompanyListController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/15.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  按公司分类的界面

#import "YYCompanyListController.h"
#import "YYProductionVM.h"
#import <MJRefresh/MJRefresh.h>

@interface YYCompanyListController ()

/** viewmodel*/
@property (nonatomic, strong) YYProductionVM *viewModel;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YYCompanyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 加载最新数据*/
- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        
        if (success) {
            [self.tableView reloadData];
        }
    }];
}

/** 加载更多数据*/
- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        if (success) {
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        YYWeakSelf
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        _tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
    }
    return _tableView;
}

- (YYProductionVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYProductionVM alloc] init];
    }
    return _viewModel;
}

@end
