//
//  YYBaseInfoViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  频道普通资讯的控制器

#import "YYBaseInfoViewController.h"
#import "YYBaseRankListController.h"
#import "YYBaseRankDetailController.h"
#import "YYBaseInfoDetailController.h"
#import "YYVideoDetailController.h"
#import "YYShowLikeDetailController.h"
#import "YYPicsDetailController.h"

#import "YYPhotoBrowser.h"
#import "YYChannelShowBannerView.h"
#import "YYMusicPlayerView.h"

#import "YYHotTableViewCell.h"

#import "YYNewsLeftPicCell.h"
#import "YYNewsBigPicCell.h"
#import "YYNewsThreePicCell.h"
#import "YYNewsPicturesCell.h"

#import "YYChannelVideoCell.h"
#import "YYChannelMusicCell.h"
#import "YYChannelShowRecommendCell.h"
#import "YYChannelShowLikeCell.h"

#import "YYBaseInfoVM.h"

#import "MJRefresh.h"

#import "PresentAnimation.h"

@interface YYBaseInfoViewController ()<UIViewControllerTransitioningDelegate>

/** tableview*/
@property (nonatomic,strong)  UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYBaseInfoVM *viewModel;

@end

@implementation YYBaseInfoViewController
{
    PresentAnimation *_presentAnimation;
}


#pragma mark -- lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _presentAnimation = [[PresentAnimation alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    if ([_classid isEqualToString:@"22"]) {
        self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        self.tableView.mj_header = nil;
    }
    //加载最新数据
    [self loadNewData];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

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
            if ([strongSelf.classid isEqualToString:@"23"]) {
                
                YYChannelShowBannerView *view = [[YYChannelShowBannerView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENWIDTH*0.6)];
                view.dataSource = strongSelf.viewModel.bannerDataSource;
                strongSelf.tableView.tableHeaderView = nil;
                strongSelf.tableView.tableHeaderView = view;
            }
            [strongSelf.tableView reloadData];
        }
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
    }];
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        
        [_tableView registerClass:[YYHotTableViewCell class] forCellReuseIdentifier:YYHotTableViewCellId];
        
        [_tableView registerClass:[YYNewsLeftPicCell class] forCellReuseIdentifier:YYNewsLeftPicCellId];
        [_tableView registerClass:[YYNewsBigPicCell class] forCellReuseIdentifier:YYNewsBigPicCellId];
        [_tableView registerClass:[YYNewsThreePicCell class] forCellReuseIdentifier:YYNewsThreePicCellId];
        [_tableView registerClass:[YYNewsPicturesCell class] forCellReuseIdentifier:YYNewsPicturesCellId];
        
        [_tableView registerClass:[YYChannelVideoCell class] forCellReuseIdentifier:YYChannelVideoCellId];
        [_tableView registerClass:[YYChannelMusicCell class] forCellReuseIdentifier:YYChannelMusicCellId];
        [_tableView registerClass:[YYChannelShowRecommendCell class] forCellReuseIdentifier:YYChannelShowRecommendCellId];
        [_tableView registerClass:[YYChannelShowLikeCell class] forCellReuseIdentifier:YYChannelShowLikeCellId];
        
        
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


- (YYBaseInfoVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYBaseInfoVM alloc] init];
        _viewModel.classid = self.classid;
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(YYBaseInfoType cellType, NSIndexPath *indexPath, id data){
            YYStrongSelf
            switch (cellType) {// 根据celltype不同跳转相应的控制器
                case YYBaseInfoTypeRank:{
                    
                    YYBaseRankDetailController *detail = [[YYBaseRankDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                    
                case YYBaseInfoTypeNews:{
                    
                    YYBaseInfoDetailController *detail = [[YYBaseInfoDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                
                case YYBaseInfoTypeNewsPics:{
                    
                    YYPicsDetailController *detail = [[YYPicsDetailController alloc] init];
                    detail.picsModels = (NSArray *)data;
                    detail.modalPresentationStyle = UIModalPresentationCustom;
                    detail.transitioningDelegate = strongSelf;
                    [strongSelf presentViewController:detail animated:YES completion:nil];

                }
                    break;
                    
                case YYBaseInfoTypeShow:{
                    
                    YYShowLikeDetailController *detail = [[YYShowLikeDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                
                case YYBaseInfoTypeVideo:{
                    
                    YYVideoDetailController *detail = [[YYVideoDetailController alloc] init];
                    detail.videoUrl = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                    
                case YYBaseInfoTypeMusic:{
                    
                    YYShowLikeDetailController *detail = [[YYShowLikeDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                
                default:
                    break;
            }
        };
        
        
        _viewModel.moreBlock = ^{ //跳转更多排行的界面
            YYStrongSelf
            YYBaseRankListController *list = [[YYBaseRankListController alloc] init];
            [strongSelf.navigationController pushViewController:list animated:YES];
        };
    }
    return _viewModel;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _presentAnimation;
}

@end
