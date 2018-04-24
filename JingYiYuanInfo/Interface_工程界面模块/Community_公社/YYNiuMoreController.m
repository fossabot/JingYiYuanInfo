//
//  YYNiuMoreController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuMoreController.h"
#import "YYRefresh.h"

#import "THBaseTableView.h"
#import "YYNiuManCell.h"
#import "YYNiuManModel.h"
//#import "YYNiuManDetailViewController.h"
#import "YYNiuManController.h"

#import "YYNiuMoreVM.h"
@interface YYNiuMoreController ()

/** tab*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYNiuMoreVM *viewModel;

@end

@implementation YYNiuMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"牛人";
    [self.view addSubview:self.tableView];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (YYNiuMoreVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYNiuMoreVM alloc] init];
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf
            
            YYNiuManModel *niuManModel = (YYNiuManModel *)data;
            YYNiuManController *niuManVc = [[YYNiuManController alloc] init];
            niuManVc.niuManModel = niuManModel;
            [strongSelf.navigationController pushViewController:niuManVc animated:YES];
        };
        
    }
    return _viewModel;
}



- (THBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        [self.tableView registerClass:[YYNiuManCell class] forCellReuseIdentifier:YYNiuManCellID];
//        _tableView.separatorInset = UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin);
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }

        YYWeakSelf
        YYAutoFooter *footer = [YYAutoFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = footer;
        
        YYStateHeader *header = [YYStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
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
