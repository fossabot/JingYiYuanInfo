//
//  YYNiuView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuView.h"
#import "YYNiuModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "YYNiuViewVM.h"

#import "YYNiuManDetailViewController.h"
#import "YYNiuNewsDetailViewController.h"

#import "YYNiuManCell.h"
#import "YYNiuArticleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIView+YYParentController.h"

@interface YYNiuView()

/** viewModel*/
@property (nonatomic, strong) YYNiuViewVM *viewModel;

@end


@implementation YYNiuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configTableView];
        [kNotificationCenter addObserver:self selector:@selector(refreshNotice:) name:YYMainRefreshNotification object:nil];
        //网络请求新数据
        [self loadNewData];
        
    }
    return self;
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:YYMainRefreshNotification object:nil];
}


/** 首页通知刷新操作，如果存在lastid说明已经初始化过了，可以刷新，否则不用刷新，viewDidLoad中有刷新*/
- (void)refreshNotice:(NSNotification *)notice {
    if (self.viewModel.lastid) {
        [self loadNewData];
    }
}

/** 网络请求新数据*/
- (void)loadNewData {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        YYStrongSelf
        [weakSelf.tableView.mj_header endRefreshing];
        if (success) {
            [strongSelf.tableView reloadData];
        }
    }];
    
//    [PPNetworkHelper GET:niunewsdefaultUrl parameters:nil responseCache:^(id responseCache) {
//        
//        if (!self.niuManDataSource.count && !self.niuArtDataSource.count) {
//            YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseCache];
//            self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
//            self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
//            self.lastid = niuModel.lastid;
//            [self.tableView reloadData];
//        }
//        
//    } success:^(id responseObject) {
//        [self.tableView.mj_header endRefreshing];
//        
//        YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseObject];
//        if (niuModel.niu_arr.count || niuModel.niuart_arr.count) {
//            [self.niuManDataSource removeAllObjects];
//            [self.niuArtDataSource removeAllObjects];
//        }
//        self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
//        self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
//        self.lastid = niuModel.lastid;
//        
//        [self.tableView reloadData];
//        
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//    }];
    
    
}


/** 网络加载更多数据*/
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


#pragma mark -------  canscroll setter

- (void)setCanScroll:(BOOL)canScroll {
    
    self.viewModel.canScroll = canScroll;
}


#pragma mark -- lazyMethods 懒加载区域


- (YYNiuViewVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYNiuViewVM alloc] init];
        YYWeakSelf
        _viewModel.selectedBlock = ^(NSString *url, NSIndexPath *indexPath) {
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf
#warning 牛人榜点击跳转相应界面
            if (indexPath.section == 0) {
                
                YYNiuManDetailViewController *niuManDetail = [[YYNiuManDetailViewController alloc] init];
                [strongSelf.parentNavigationController pushViewController:niuManDetail animated:YES];
                
            }else {
                
                YYNiuNewsDetailViewController *niuNewsDetail = [[YYNiuNewsDetailViewController alloc] init];
                niuNewsDetail.url = url;
                [strongSelf.parentNavigationController pushViewController:niuNewsDetail animated:YES];
            }
        };
    }
    return _viewModel;
}

- (void)configTableView {

    MJWeakSelf;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        YYStrongSelf
        [strongSelf loadMoreData];
    }];
    /** 普通闲置状态  壹元君正努力为您加载数据*/
   
    [footer setTitle:@"普通闲置状态" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开就可以进行刷新的状态" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新中的状态" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"即将刷新的状态" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];
    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    self.tableView.mj_footer = footer;
    [self.tableView registerClass:[YYNiuManCell class] forCellReuseIdentifier:YYNiuManCellID];
    [self.tableView registerClass:[YYNiuArticleCell class] forCellReuseIdentifier:YYNiuArticleCellID];
    
}

@end
