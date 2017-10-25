//
//  YYProjectListController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProjectListController.h"

#import "YYProjectVM.h"
#import "MJRefresh.h"
#import "YYProjectModel.h"
#import "YYProjectCell.h"
#import "YYProjectDetailController.h"

@interface YYProjectListController ()

/** tableview*/
@property (nonatomic,strong)  UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYProjectVM *viewModel;

@end

@implementation YYProjectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -- network   数据请求方法  ---------------------------

/** 加载最新数据*/
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
        [strongSelf.tableView.mj_header endRefreshing];
    }];
    
    
}

/** 加载更多数据*/
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
        [strongSelf.tableView.mj_footer endRefreshing];
    }];

}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-64) style:UITableViewStylePlain];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 5);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        
        [_tableView registerClass:[YYProjectCell class] forCellReuseIdentifier:YYProjectCellId];
        
        YYWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
        [stateFooter setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = stateFooter;
        
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
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

- (YYProjectVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYProjectVM alloc] init];
        _viewModel.classid = self.classid;
        
        YYWeakSelf
        _viewModel.cellSelectBlock = ^(NSIndexPath *indexPath, id data) {
          
            YYProjectModel *model = (YYProjectModel *)data;
            YYProjectDetailController *detail = [[YYProjectDetailController alloc] init];
            detail.url = model.webUrl;
            detail.shareImgUrl = model.picurl;
            detail.projectId = model.projectId;
            [weakSelf.navigationController pushViewController:detail animated:YES];
        };
    }
    return _viewModel;
}


@end
