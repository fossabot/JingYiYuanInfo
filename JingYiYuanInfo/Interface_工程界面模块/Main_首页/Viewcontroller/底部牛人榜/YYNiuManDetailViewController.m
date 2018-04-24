//
//  YYNiuManDetailViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人详情页

#import "YYNiuManDetailViewController.h"
#import "UIBarButtonItem+YYExtension.h"
#import "YYRefresh.h"

#import "YYNiuManHeader.h"
#import "YYNiuManDetailVM.h"
#import "YYNiuArticleCell.h"
#import "YYNiuManEmptyCell.h"
#import "YYNiuArticleModel.h"
#import "YYNiuNewsDetailViewController.h"

@interface YYNiuManDetailViewController ()

@property (nonatomic, strong) UIView *titleView;

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** uitableView*/
@property (nonatomic, strong) UITableView *tableView;

/** focus*/
@property (nonatomic, strong) UIBarButtonItem *focusItem;

/** viewModel*/
@property (nonatomic, strong) YYNiuManDetailVM *viewModel;

//关注牛人的状态
@property (nonatomic, assign) BOOL followState;

@end

@implementation YYNiuManDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _followState = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self loadNewData];
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)configSubView {

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 30, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.hidden = YES;
    self.titleView = titleView;
    self.navigationItem.titleView = titleView;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:titleView.bounds];
    imageV.layer.cornerRadius = imageV.yy_height/2;
    imageV.layer.masksToBounds = YES;
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    self.imageView = imageV;
    [titleView addSubview:imageV];
    
    [self.view addSubview:self.tableView];
}

/** 刷新头部视图*/
- (void)refreshHeader {
    
    YYNiuManHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YYNiuManHeader" owner:nil options:nil].firstObject;
    header.frame = CGRectMake(0, 0, kSCREENWIDTH, 195);
    header.icon = self.imgUrl;
    header.name = self.niuName;
    header.hotVlaue = self.hotValue;
    header.introduce = self.introduce;
    self.tableView.tableHeaderView = header;
    
    YYWeakSelf
    __weak typeof(header) weakHeader = header;
    __block CGRect frame = weakHeader.frame;
    header.openOrCloseBlock = ^(BOOL selected, CGFloat height) {

        frame.size.height = height;
        weakHeader.frame = frame;
        weakSelf.tableView.tableHeaderView = weakHeader;
    };
}

/**
 *  加载最新牛人观点
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
 *  加载更多牛人观点
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


- (YYNiuManDetailVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYNiuManDetailVM alloc] init];
        _viewModel.aid = self.aid;
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf
            YYNiuArticleModel *model = (YYNiuArticleModel *)data;
            YYNiuNewsDetailViewController *niuNewsDetail = [[YYNiuNewsDetailViewController alloc] init];
            niuNewsDetail.niuNewsId = model.art_id;
//            niuNewsDetail.niuId = model.niu_id;
            niuNewsDetail.url = model.webUrl;
            niuNewsDetail.shareImgUrl = model.picurl;
            [strongSelf.navigationController pushViewController:niuNewsDetail animated:YES];
            
        };
        
        _viewModel.hiddenHeaderBlock = ^(BOOL hidden) {
            [UIView animateWithDuration:2 animations:^{
                weakSelf.titleView.hidden = hidden;
            }];
        };
        
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTabBarH, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin);
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin)];
        }
        
        [self.tableView registerClass:[YYNiuArticleCell class] forCellReuseIdentifier:YYNiuArticleCellID];
        [self.tableView registerNib:[UINib nibWithNibName:@"YYNiuManEmptyCell" bundle:nil] forCellReuseIdentifier:YYNiuManEmptyCellId];
        YYWeakSelf
        YYAutoFooter *footer = [YYAutoFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = footer;
        
        YYNormalHeader *header = [YYNormalHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        _tableView.mj_header = header;
        
//        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
//        configer.emptyImage = imageNamed(emptyImageName);
//        configer.emptyTitle = @"暂无数据,点此重新加载";
//        configer.emptyTitleColor = UnenableTitleColor;
//        configer.emptyTitleFont = SubTitleFont;
//        configer.allowScroll = YES;
//        configer.emptyViewTapBlock = ^{
//            [weakSelf.tableView.mj_header beginRefreshing];
//        };
//        configer.emptyViewDidAppear = ^{
//            weakSelf.tableView.mj_footer.hidden = YES;
//        };
//        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}



@end
