//
//  YYMineSubscriptionViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/6/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineSubscriptionViewController.h"
#import "YYSubscribeCell.h"
#import "YYNiuSubscribeModel.h"
//#import "YYNiuManDetailViewController.h"
#import "YYNiuManController.h"

#import <MJExtension/MJExtension.h>
#import "YYRefresh.h"

@interface YYMineSubscriptionViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tab*/
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYMineSubscriptionViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"我的订阅";
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账户"];
        [SVProgressHUD dismissWithDelay:1];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"queall",@"act",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
        
        [self.tableView.mj_header endRefreshing];
        if (response) {
            
            self.dataSource = [YYNiuSubscribeModel mj_objectArrayWithKeyValuesArray:response[@"allsubarr"]];
            if (self.dataSource.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.lastid = response[LASTID];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    } showSuccessMsg:nil];
    
    
}


- (void)loadMoreData {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账户"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"queall",@"act",user.userid,USERID,self.lastid,LASTID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
        
        [self.tableView.mj_footer endRefreshing];
        if (response) {
            
            NSMutableArray *arr = [YYNiuSubscribeModel mj_objectArrayWithKeyValuesArray:response[@"allsubarr"]];
            [self.dataSource addObjectsFromArray:arr];
            if (arr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.lastid = response[LASTID];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
    
    
}

#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 隐藏尾部刷新控件
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 0) || self.dataSource.count == 0;
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYWeakSelf
    YYNiuSubscribeModel *model = self.dataSource[indexPath.row];
    YYNiuManController *niuManVc = [[YYNiuManController alloc] init];
    niuManVc.subscribleModel = model;
    niuManVc.focusChangedBlock = ^{
        [weakSelf loadData];
    };
    
    [self.navigationController pushViewController:niuManVc animated:YES];
}


#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYNiuSubscribeModel *model = self.dataSource[indexPath.row];
    YYSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:YYSubscribeCellId];
    cell.model = model;
    return cell;
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.tableView registerClass:[YYSubscribeCell class] forCellReuseIdentifier:YYSubscribeCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YYWeakSelf
        YYAutoFooter *footer = [YYAutoFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = footer;
        
        YYStateHeader *header = [YYStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadData];
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
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.mj_footer.hidden = YES;
        };
        
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
