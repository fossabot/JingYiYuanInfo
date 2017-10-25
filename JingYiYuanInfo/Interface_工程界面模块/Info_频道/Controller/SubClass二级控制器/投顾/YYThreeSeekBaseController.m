//
//  YYThreeSeekBaseController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekBaseController.h"
#import "YYThreeSeekDetailController.h"
#import "YYThreeSeekVM.h"
#import "YYCompanyCell.h"
#import "YYCompanyModel.h"
#import <MJRefresh/MJRefresh.h>

@interface YYThreeSeekBaseController ()

/** viewModel*/
@property (nonatomic, strong) YYThreeSeekVM *viewModel;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YYThreeSeekBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    if (self.fatherId == 6) {
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 20)];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.text = @"我们只认准国家认证的84家正规机构";
        tip.textColor = ThemeColor;
        tip.font = UnenableTitleFont;
        tip.backgroundColor = LightGraySeperatorColor;
        self.tableView.tableHeaderView = tip;
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    YYWeakSelf
    [self.viewModel fetchNewDataForThreeSeek:self.fatherId completion:^(BOOL success) {
        
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
    [self.viewModel fetchMoreDataForThreeSeek:self.fatherId completion:^(BOOL success) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [weakSelf.tableView reloadData];
        }
    }];
    
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYThreeSeekVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYThreeSeekVM alloc] init];
        _viewModel.fatherId = self.fatherId;
        _viewModel.classid = self.classid;
        YYWeakSelf
        _viewModel.cellSelectBlock = ^(NSIndexPath *indexPath, id data) {//选中相应的cell
            YYCompanyModel *company = (YYCompanyModel *)data;
            YYStrongSelf
            YYThreeSeekDetailController *threeSeekDetailVc = [[YYThreeSeekDetailController alloc] init];
            threeSeekDetailVc.comid = company.comId;
            [strongSelf.navigationController pushViewController:threeSeekDetailVc animated:YES];
        };
        
        _viewModel.changeBlock = ^{//推荐换一批回调
          
            YYStrongSelf
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-64) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 5);
        [_tableView registerClass:[YYCompanyCell class] forCellReuseIdentifier:YYCompanyCellId];
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

@end
