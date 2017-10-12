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
#import "YYNiuManModel.h"
#import "YYNiuArticleModel.h"

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
        [strongSelf.tableView.mj_header endRefreshing];
    }];

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
        [strongSelf.tableView.mj_footer endRefreshing];
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
        _viewModel.selectedBlock = ^(id data, NSIndexPath *indexPath) {
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf
#warning 牛人榜点击跳转相应界面
            if (indexPath.section == 0) {
                
                YYNiuManModel *model = (YYNiuManModel *)data;
                YYNiuManDetailViewController *niuManDetail = [[YYNiuManDetailViewController alloc] init];
                niuManDetail.jz_wantsNavigationBarVisible = YES;
#warning 没有牛人的详情页  没有更多牛人的列表页
                [strongSelf.parentNavigationController pushViewController:niuManDetail animated:YES];
                
            }else {
                
                YYNiuArticleModel *model = (YYNiuArticleModel *)data;
                YYNiuNewsDetailViewController *niuNewsDetail = [[YYNiuNewsDetailViewController alloc] init];
                niuNewsDetail.url = model.webUrl;
                niuNewsDetail.shareImgUrl = model.picurl;
                niuNewsDetail.niuNewsId = model.art_id;
                niuNewsDetail.jz_wantsNavigationBarVisible = YES;
                [strongSelf.parentNavigationController pushViewController:niuNewsDetail animated:YES];
            }
        };
    }
    return _viewModel;
}

- (void)configTableView {

    self.tableView.dataSource = self.viewModel;
    self.tableView.delegate = self.viewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTabBarH, 0);
    [self.tableView registerClass:[YYNiuManCell class] forCellReuseIdentifier:YYNiuManCellID];
    [self.tableView registerClass:[YYNiuArticleCell class] forCellReuseIdentifier:YYNiuArticleCellID];
    
    YYWeakSelf
    
    MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        YYStrongSelf
        [strongSelf loadMoreData];
    }];
    
    stateFooter.stateLabel.text = @"壹元君正努力为您加载中...";
    self.tableView.mj_footer = stateFooter;
    
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

@end
