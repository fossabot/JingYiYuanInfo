//
//  YYHotView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotView.h"

#import "MJExtension.h"

#import "YYHotViewVM.h"
#import "YYHotTagModel.h"
#import "YYHotHotModel.h"
#import "YYHotInfoModel.h"

#import "YYHotTableViewCell.h"
#import "YYNewsLeftPicCell.h"
#import "YYNewsBigPicCell.h"
#import "YYNewsPicturesCell.h"
#import "YYNewsThreePicCell.h"

#import "YYHotHeader.h"
#import "UIView+YYViewInWindow.h"
#import "UIView+YYParentController.h"

#import "YYBaseInfoDetailController.h"
#import "YYBaseRankDetailController.h"
#import "YYPicsDetailController.h"

static NSString * cellId = @"cellid";

@interface YYHotView()


/** hotViewModel*/
@property (nonatomic, strong) YYHotViewVM *viewModel;

/** header*/
@property (nonatomic, strong) YYHotHeader *header;

@end

@implementation YYHotView
{
    NSInteger _selectedTag;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:YYMainRefreshNotification object:nil];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)config {
    self.viewModel.urlKey = 0;
    [self configTableView];
    [self refreshData];
    [kNotificationCenter addObserver:self selector:@selector(refreshNotice:) name:YYMainRefreshNotification object:nil];
    
}



/** 首页通知刷新操作，如果存在lastid说明已经初始化过了，可以刷新，否则不用刷新，viewDidLoad中有刷新*/
- (void)refreshNotice:(NSNotification *)notice {
    if (self.viewModel.lastid) {
        CGPoint point = self.tableView.contentOffset;
        if (![NSStringFromCGPoint(point) isEqualToString:NSStringFromCGPoint(CGPointMake(0, 0))] ) {
            
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        [self refreshData];
        
    }
}

/** 换一批刷新整个控制器的数据*/
- (void)refreshData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        YYStrongSelf
        if (success) {
            [strongSelf.tableView reloadData];
            [strongSelf renderHeader];
        }
    }];
    
    
}


/** 切换标签 刷新tableview数据源*/
- (void)selectTag:(NSInteger)tag {
    if (_selectedTag == tag) {
        return;
    }
    _selectedTag = tag;
    self.viewModel.classid = [NSString stringWithFormat:@"%ld",tag];
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel selectedTag:tag completion:^(BOOL success) {
        
        YYStrongSelf
        if (success) {
            
            [strongSelf.tableView reloadData];
        }
    }];
    
}

/** 网络请求更多数据*/
- (void)loadMoreData {
    
    YYWeakSelf
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        if (success) {
            
            [strongSelf.tableView reloadData];
        }
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}



/** 渲染头部*/
- (void)renderHeader {
    
    NSMutableArray *titles = [NSMutableArray array];
    for (YYHotTagModel *tagModel in self.viewModel.headerDataSource) {//从头部的标签数组中取出对应的标签名称
        [titles addObject:tagModel.classname];
    }
    
    if (!self.header) {
        self.header = [[YYHotHeader alloc] initWithDatas:titles];
        YYWeakSelf
        self.header.changeTagBlock = ^(NSInteger index){
            YYStrongSelf
            //选中标签的回调
            YYHotTagModel *tagMoel = strongSelf.viewModel.headerDataSource[index];
            [strongSelf selectTag:[tagMoel.tagid integerValue]];
        };
        self.header.changeBlock = ^{
          
            YYStrongSelf
            [strongSelf refreshData];
            
        };
    }else {
        [self.header setDatas:titles];
    }
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.header;
    
}


#pragma mark -------  setter -------------------

/** 传递外层的滑动给底部tableview*/
- (void)setCanScroll:(BOOL)canScroll {
    
    self.viewModel.canScroll = canScroll;
}

#pragma mark -- lazyMethods 懒加载区域 ----------------------------------------

- (YYHotViewVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYHotViewVM alloc] init];
        YYWeakSelf
        _viewModel.selectedBlock = ^(NSInteger picstate, id data, NSIndexPath *indexPath){
            
            YYStrongSelf
            switch (picstate) {
                case 1:
                case 2:
                case 3:{
                    
                    YYBaseInfoDetailController *infoDetail = [[YYBaseInfoDetailController alloc] init];
                    YYHotInfoModel *hotInfoModel = (YYHotInfoModel *)data;
                    infoDetail.jz_wantsNavigationBarVisible = YES;
                    infoDetail.url = hotInfoModel.webUrl;
                    infoDetail.shareImgUrl = hotInfoModel.picurl;
                    infoDetail.newsId = hotInfoModel.infoid;
                    [strongSelf.parentNavigationController pushViewController:infoDetail animated:YES];
                }
                    break;
                  
                case 4:{
                    YYPicsDetailController *picsDetail = [[YYPicsDetailController alloc] init];
                    YYHotInfoModel *hotInfoModel = (YYHotInfoModel *)data;
                    
//                    picsDetail.shareImgUrl = hotInfoModel.picurl;
                    picsDetail.picsModels = hotInfoModel.picarr;
                    picsDetail.jz_wantsNavigationBarVisible = NO;

                    YYLog(@"hotView的父navigationcontroller的地址  %p",strongSelf.parentNavigationController);
                    [strongSelf.parentNavigationController pushViewController:picsDetail animated:YES];
                }
                    break;
                    
                case 5:{
                    
                    YYBaseRankDetailController *rankDetail = [[YYBaseRankDetailController alloc] init];
                    YYHotHotModel *hothotModel = (YYHotHotModel *)data;
                    rankDetail.jz_wantsNavigationBarVisible = YES;
                    rankDetail.url = hothotModel.rlink;
                    [strongSelf.parentNavigationController pushViewController:rankDetail animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        };
    }
    return _viewModel;
}

- (void)configTableView {
    
    self.tableView.separatorColor = UnenableTitleColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTabBarH, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[YYHotTableViewCell class] forCellReuseIdentifier:YYHotTableViewCellId];
    
    [self.tableView registerClass:[YYNewsLeftPicCell class] forCellReuseIdentifier:YYNewsLeftPicCellId];
    [self.tableView registerClass:[YYNewsBigPicCell class] forCellReuseIdentifier:YYNewsBigPicCellId];
    [self.tableView registerClass:[YYNewsThreePicCell class] forCellReuseIdentifier:YYNewsThreePicCellId];
    [self.tableView registerClass:[YYNewsPicturesCell class] forCellReuseIdentifier:YYNewsPicturesCellId];

    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    
    MJWeakSelf;
    
    MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        YYStrongSelf
        [strongSelf loadMoreData];
    }];
    
    [stateFooter setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
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
