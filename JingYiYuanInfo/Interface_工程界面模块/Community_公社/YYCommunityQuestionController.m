//
//  YYCommunityQuestionController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityQuestionController.h"

#import "THBaseTableView.h"
#import "YYQuestionCell.h"
#import "YYCommunityQuestionModel.h"
#import "YYCommunityQuestionVM.h"
#import "YYQuestionDetailController.h"

#import "YYRefresh.h"

@interface YYCommunityQuestionController ()
/** tab*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYCommunityQuestionVM *viewModel;

@end

@implementation YYCommunityQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
//    [self loadNewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        [self.tableView.mj_header endRefreshing];
        return;
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
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        [self.tableView.mj_header endRefreshing];
        return;
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

- (YYCommunityQuestionVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYCommunityQuestionVM alloc] init];
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            YYStrongSelf
            YYCommunityQuestionModel *model = (YYCommunityQuestionModel *)data;
            YYQuestionDetailController *questionDetail = [[YYQuestionDetailController alloc] init];
            questionDetail.articleId = model.articleId;
            questionDetail.iconUrl = model.niu_img;
            questionDetail.nameStr = model.niu_name;
            questionDetail.titleStr = model.title;
            questionDetail.questionStr = model.desc;
            [strongSelf.navigationController pushViewController:questionDetail animated:YES];
        };
        
    }
    return _viewModel;
}



- (THBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTabBarH, 0);
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YYQuestionCell class] forCellReuseIdentifier:YYQuestionCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        configer.emptyTitle = @"暂无数据，快去提问吧";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        configer.emptyViewDidAppear = ^{

            weakSelf.tableView.mj_footer.hidden = YES;
        };
       
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}


@end
