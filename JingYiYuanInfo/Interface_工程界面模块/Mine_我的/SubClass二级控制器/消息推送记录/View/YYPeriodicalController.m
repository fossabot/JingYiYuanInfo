//
//  YYPeriodicalController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPeriodicalController.h"
#import "YYPeriodDetailController.h"
#import "YYPeriodVM.h"
#import "YYPeriodModel.h"
#import "YYPeriodCell.h"
#import <MJRefresh/MJRefresh.h>

@interface YYPeriodicalController ()

/** viewModel*/
@property (nonatomic, strong) YYPeriodVM *viewModel;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YYPeriodicalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (success) {
            [weakSelf.tableView reloadData];
        }
        
    }];
    
}

- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    YYWeakSelf
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [weakSelf.tableView reloadData];
        }
    }];
    
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYPeriodVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYPeriodVM alloc] init];
        _viewModel.classid = self.classid;
        YYWeakSelf
        _viewModel.cellSelectBlock = ^(NSIndexPath *indexPath, id data) {//选中相应的cell
            YYPeriodModel *periofModel = (YYPeriodModel *)data;
            YYStrongSelf
            YYPeriodDetailController *periodDetailVc = [[YYPeriodDetailController alloc] init];
            periodDetailVc.url = periofModel.webUrl;
            [strongSelf.navigationController pushViewController:periodDetailVc animated:YES];
        };
        
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 5);
        [_tableView registerClass:[YYPeriodCell class] forCellReuseIdentifier:YYPeriodCellId];
        YYWeakSelf
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
        stateFooter.stateLabel.text = @"壹元君正努力为您加载中...";
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


@end
