//
//  YYCommunityViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/1.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityViewController.h"
#import "YYCommunityVM.h"
#import "YYCommunityBannerDetailController.h"
#import "YYNiuManListController.h"



#import <MJRefresh/MJRefresh.h>

@interface YYCommunityViewController ()
/** tab*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYCommunityVM *viewModel;

/** banner*/
@property (nonatomic, strong) SDCycleScrollView *banner;

@end

@implementation YYCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.banner;
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

- (UITableView *)tableView {
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

- (YYCommunityVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYCommunityVM alloc] init];
        YYWeakSelf
        _viewModel.bannerSelectedBlock = ^(NSString *imgUrl, NSString *link){
            
            YYStrongSelf
            YYCommunityBannerDetailController *detailVc = [[YYCommunityBannerDetailController alloc] init];
            detailVc.imgUrl = imgUrl;
            detailVc.url = link;
            [strongSelf.navigationController pushViewController:detailVc animated:YES];
        };
        
        _viewModel.niuManListBlock = ^{
        
            YYStrongSelf
            YYNiuManListController *niuManList = [[YYNiuManListController alloc] init];
            [strongSelf.navigationController pushViewController:niuManList animated:YES];
        };
        
        _viewModel.cellSelectedBlock = ^(id cell, NSIndexPath *indexPath){
            
            if (indexPath.section == 0) {
                
                
            }
        };
    }
    return _viewModel;
}

- (SDCycleScrollView *)banner{
    if (!_banner) {
        _banner = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENWIDTH*0.6)];
        _banner.delegate = self.viewModel;
        _banner.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _banner.infiniteLoop = YES;
        _banner.placeholderImage = imageNamed(@"placeholder");
        
    }
    return _banner;
}

@end
