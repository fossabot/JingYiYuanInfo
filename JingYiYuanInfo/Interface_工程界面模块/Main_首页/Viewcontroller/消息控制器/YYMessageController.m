//
//  YYMessageController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  首页左上角消息按钮进入的界面

#import "YYMessageController.h"
#import "YYMessageViewModel.h"
#import "YYMessageDetailController.h"
#import "YYMainMessageCell.h"

#import <MJRefresh/MJRefresh.h>

@interface YYMessageController ()

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYMessageViewModel *viewModel;

@end

@implementation YYMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    [self.view addSubview:self.tableView];
    [self loadNewData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  刷新数据
 */
- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    YYWeakSelf
    [self.viewModel loadNewDataCompletion:^(BOOL success) {
        
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
    [self.viewModel loadMoreDataCompletion:^(BOOL success) {
       
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [weakSelf.tableView reloadData];
        }
    }];
    
}

#pragma mark -------  无数据时的占位图片  -----------------------------

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return imageNamed(@"yyfw_push_empty_112x94_");
//}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    
//    [self loadNewData];
//}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[YYMainMessageCell class] forCellReuseIdentifier:YYMainMessageCellId];
        _tableView.tableFooterView = [[UIView alloc] init];
        YYWeakSelf
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
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

- (YYMessageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYMessageViewModel alloc] init];
        YYWeakSelf
        _viewModel.cellSelectBlock = ^(NSString *webUrl, NSString *title){
            
            YYStrongSelf
            YYMessageDetailController *detailVc = [[YYMessageDetailController alloc] init];
            detailVc.url = webUrl;
            detailVc.shareTitle = title;
            [strongSelf.navigationController pushViewController:detailVc animated:YES];
        };
    }
    return _viewModel;
}

@end
