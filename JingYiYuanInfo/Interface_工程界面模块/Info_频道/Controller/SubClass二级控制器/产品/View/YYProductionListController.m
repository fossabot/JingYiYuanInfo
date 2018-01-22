//
//  YYProductionListController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/15.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
// 按产品分类的界面

#import "YYProductionListController.h"
#import "YYVIPDetailController.h"
#import "YYProductionDetailController.h"
#import "YYThreeSeekDetailController.h"

#import "YYCompanyModel.h"
#import "YYProductionCommonModel.h"


#import "THBaseTableView.h"
#import "YYProductionVM.h"
#import "YYCompanyCell.h"
#import "YYProductionCell.h"

#import <MJRefresh/MJRefresh.h>

#define vipDetailUrl @"http://yyapp.1yuaninfo.com/app/yyfwapp/goods_info.php?goodtpye=1&goodid=1"
#define sepecialDetailUrl @"http://yyapp.1yuaninfo.com/app/yyfwapp/goods_info.php?goodtpye=2&goodid="

@interface YYProductionListController ()

/** viewmodel*/
@property (nonatomic, strong) YYProductionVM *viewModel;

/** tableView*/
@property (nonatomic, strong) THBaseTableView *tableView;

@end

@implementation YYProductionListController

#pragma mark -- lifeCycle 生命周期  --------------------------------

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

/** 加载最新数据*/
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

/** 加载更多数据*/
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

- (THBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-YYTopNaviHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        [_tableView registerClass:[YYProductionCell class] forCellReuseIdentifier:YYProductionCellId];
        [_tableView registerClass:[YYCompanyCell class] forCellReuseIdentifier:YYCompanyCellId];
        _tableView.separatorInset = UIEdgeInsetsMake(0, YYCommonCellLeftMargin, 0, YYCommonCellRightMargin);
        
        YYWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];

        [stateFooter setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];

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

- (YYProductionVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYProductionVM alloc] init];
        _viewModel.classid = self.classid;
        YYWeakSelf
        _viewModel.productionSelectBlock = ^(YYProductionType cellType, NSIndexPath *indexPath, id data) {
            
            switch (cellType) {
                case YYProductionTypeVIP:{
                    YYLog(@"点击了VIP项目，需登录方可购买");
                    YYVIPDetailController *vipVc = [[YYVIPDetailController alloc] init];
                    vipVc.url = vipDetailUrl;
                    [weakSelf.navigationController pushViewController:vipVc animated:YES];
                }
                    break;
                    
                case YYProductionTypeNormal:{
                    
                    YYLog(@"点击了普通项目，暂无详情页，需登录并且注册会员方可购买");
                    YYProductionDetailController *productionDetail = [[YYProductionDetailController alloc] init];
                    YYProductionCommonModel *commonModel = (YYProductionCommonModel *)data;
                    productionDetail.productionId = commonModel.iosproid;
                    productionDetail.url = commonModel.webUrl;
                    [weakSelf.navigationController pushViewController:productionDetail animated:YES];
                }
                break;
                    
                default:
                    
                    YYLog(@"点击了公司，进入该公司的详情列表");
                    YYCompanyModel *company = (YYCompanyModel *)data;
                    YYThreeSeekDetailController *threeSeekDetail = [[YYThreeSeekDetailController alloc] init];
                    threeSeekDetail.comid = company.comId;
                    threeSeekDetail.isScrollToProduct = YES;
                    [weakSelf.navigationController pushViewController:threeSeekDetail animated:YES];
                    
                    break;
            }
        };
    }
    return _viewModel;
}


@end
