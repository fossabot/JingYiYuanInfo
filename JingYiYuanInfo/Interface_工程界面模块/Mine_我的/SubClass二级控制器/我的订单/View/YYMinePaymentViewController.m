//
//  YYMinePaymentViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMinePaymentViewController.h"

#import "YYMineOrderCell.h"
#import "YYOrderModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface YYMinePaymentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYMinePaymentViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    [self configSubView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)configSubView {
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

/** 加载数据*/
- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showInfoWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"orderover",@"act",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:orderUrl parameters:para success:^(id response) {
        
        if (response) {
            self.dataSource = [YYOrderModel mj_objectArrayWithKeyValuesArray:response[@"user_order"]];
            self.lastid = response[LASTID];
            [self.tableView reloadData];
            if (self.dataSource.count < 10) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


- (void)loadMoreData {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"orderover",@"act",user.userid,USERID,self.lastid,LASTID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:orderUrl parameters:para success:^(id response) {
        
        if (response) {
            NSMutableArray *arr = [YYOrderModel mj_objectArrayWithKeyValuesArray:response[@"user_order"]];
            [self.dataSource addObjectsFromArray:arr];
            self.lastid = response[LASTID];
            [self.tableView reloadData];
            if (arr.count < 10) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}


#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:YYMineOrderCellId cacheByIndexPath:indexPath configuration:^(YYMineOrderCell *cell) {
       
        YYOrderModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYMineOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:YYMineOrderCellId];
    YYOrderModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}





#pragma mark  懒加载方法区域   -------------------------------------------

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YYMineOrderCell class] forCellReuseIdentifier:YYMineOrderCellId];
        
        YYWeakSelf
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
            [weakSelf loadData];
        };
        [self.tableView emptyViewConfiger:configer];
        
    }
    return _tableView;
}


@end
