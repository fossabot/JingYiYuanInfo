//
//  YYCommunityPersonController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  自媒体界面

#import "YYCommunityPersonController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "YYRefresh.h"

#import "THBaseTableView.h"
#import "YYNiuManCell.h"
#import "YYNiuArticleCell.h"
#import "YYCommunityPersonVM.h"
#import "YYNiuArticleModel.h"
#import "YYNiuManModel.h"
#import "YYPersonBannerModel.h"

#import "YYNiuMoreController.h"
#import "YYNiuManDetailViewController.h"
//#import "YYNiuManController.h"
#import "YYNiuNewsDetailViewController.h"
#import "YYCommunityBannerDetailController.h"

@interface YYCommunityPersonController ()<SDCycleScrollViewDelegate>

/** banner*/
@property (nonatomic, strong) SDCycleScrollView *banner;

/** tab*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYCommunityPersonVM *viewModel;

@end

@implementation YYCommunityPersonController


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
            NSMutableArray *tempArr = [NSMutableArray array];
            for (YYPersonBannerModel *model in strongSelf.viewModel.niuBannerDataSource) {
                
                [tempArr addObject:model.picurl];
            }
            [strongSelf.banner setImageURLStringsGroup:tempArr];
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

- (YYCommunityPersonVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYCommunityPersonVM alloc] init];
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf

            if (indexPath.section == 0) {
                YYNiuManModel *model = (YYNiuManModel *)data;
                YYNiuManDetailViewController *niuManDetail = [[YYNiuManDetailViewController alloc] init];
                niuManDetail.niuid = model.niu_id;
                niuManDetail.aid = model.aid;
                niuManDetail.imgUrl = model.niu_img1;
                niuManDetail.niuName = model.niu_name;
                niuManDetail.hotValue = model.niu_pop;
                niuManDetail.followValue = model.niu_follow;
                niuManDetail.introduce = model.niu_introduce;
  
                __weak typeof(model) weakModel = model;
                niuManDetail.focusChangedBlock = ^(NSString *focusCount){
                    
                    weakModel.niu_follow = focusCount;
                };
//                YYNiuManController *niuManVc = [[YYNiuManController alloc] init];
//                niuManVc.niuManModel = model;
                [strongSelf.navigationController pushViewController:niuManDetail animated:YES];
                
            }else {
                
                YYNiuArticleModel *model = (YYNiuArticleModel *)data;
                YYNiuNewsDetailViewController *niuNewsDetail = [[YYNiuNewsDetailViewController alloc] init];
                niuNewsDetail.niuNewsId = model.art_id;
                niuNewsDetail.url = model.webUrl;
                niuNewsDetail.newsTitle = model.title;
                niuNewsDetail.shareImgUrl = model.picurl;
                [strongSelf.navigationController pushViewController:niuNewsDetail animated:YES];
            }
        };
        
        _viewModel.niuManListBlock = ^{
            //查看更多牛人列表
            YYNiuMoreController *niuMoreDetail = [[YYNiuMoreController alloc] init];
            [weakSelf.navigationController pushViewController:niuMoreDetail animated:YES];
        };
        
        _viewModel.bannerSelectedBlock = ^(NSString *imgUrl, NSString *link) {
          
            YYStrongSelf
            YYCommunityBannerDetailController *detail = [[YYCommunityBannerDetailController alloc] init];
            detail.url = link;
            detail.shareImgUrl = imgUrl;
            [strongSelf.navigationController pushViewController:detail animated:YES];
        };
    }
    return _viewModel;
}



- (THBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-YYTopNaviHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerClass:[YYNiuManCell class] forCellReuseIdentifier:YYNiuManCellID];
        [self.tableView registerClass:[YYNiuArticleCell class] forCellReuseIdentifier:YYNiuArticleCellID];
        
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
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}



- (SDCycleScrollView *)banner{
    if (!_banner) {
        _banner = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENWIDTH*0.4)];
        _banner.delegate = self.viewModel;
        _banner.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _banner.infiniteLoop = YES;
        _banner.placeholderImage = imageNamed(placeHolderLarge);
        _banner.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    }
    return _banner;
}




@end
