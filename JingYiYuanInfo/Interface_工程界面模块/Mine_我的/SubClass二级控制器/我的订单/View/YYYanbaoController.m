//
//  YYYanbaoController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/1.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

/**
 我:
 http://yyapp.1yuaninfo.com/app/houtai/admin/backOrder.php?userid=&orderid=
 我:
 http://yyapp.1yuaninfo.com/app/houtai/admin/pdfReport.php?orderid=
 */
#define yanbaoDetailUrl @"http://yyapp.1yuaninfo.com/app/houtai/admin/backOrder.php?"

#import "YYYanbaoController.h"
#import "THBaseTableView.h"
#import "YYOrderPushViewModel.h"
#import "YYOrderPushListCell.h"
#import "YYYanbaoDetailController.h"

#import "YYRefresh.h"

@interface YYYanbaoController ()

/** tableView*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYOrderPushViewModel *viewModel;

@end

@implementation YYYanbaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务记录";
    [self.view addSubview:self.tableView];
    [self loadData];
}



#pragma mark -- network   数据请求方法  ---------------------------

/**
 *  加载最新数据
 */
- (void)loadData {
    
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

- (THBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight)    style:UITableViewStylePlain];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYOrderPushListCell class]) bundle:nil] forCellReuseIdentifier:YYOrderPushListCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YYWeakSelf
        YYStateHeader *header = [YYStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadData];
        }];
        _tableView.mj_header = header;
        
        YYBackStateFooter *stateFooter = [YYBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
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
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.mj_footer.hidden = YES;
        };
        [self.tableView emptyViewConfiger:configer];
        
    }
    return _tableView;
}


- (YYOrderPushViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYOrderPushViewModel alloc] init];
        _viewModel.orderid = self.orderId;
        YYWeakSelf
        _viewModel.yanbaoBlock = ^(NSString *url) {
          
            if (url.length) {
                
                YYYanbaoDetailController *yanbaoDetail = [[YYYanbaoDetailController alloc] init];
                yanbaoDetail.url = url;
                [weakSelf.navigationController pushViewController:yanbaoDetail animated:YES];
            }else {
                [SVProgressHUD showImage:nil status:@"暂无研报"];
                [SVProgressHUD dismissWithDelay:1];
            }
        };
    }
    return _viewModel;
}

@end
