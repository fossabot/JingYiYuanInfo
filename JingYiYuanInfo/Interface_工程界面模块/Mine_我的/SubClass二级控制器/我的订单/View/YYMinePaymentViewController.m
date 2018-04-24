//
//  YYMinePaymentViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMinePaymentViewController.h"
#import "YYBackOrderController.h"
#import "YYYanbaoController.h"

#import "YYMineOrderCell.h"
#import "YYOrderModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "YYRefresh.h"
#import <MJExtension/MJExtension.h>

#define yanbaoDetailUrl @"http://yyapp.1yuaninfo.com/app/houtai/admin/pdfReport.php?"
#define cancelOrderUrl @"http://yyapp.1yuaninfo.com/app/houtai/admin/backOrder.php?"


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
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"orderover",@"act",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:orderUrl parameters:para success:^(id response) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (response) {
            weakSelf.dataSource = [YYOrderModel mj_objectArrayWithKeyValuesArray:response[@"user_order"]];
            weakSelf.lastid = response[LASTID];
            [weakSelf.tableView reloadData];
            if (weakSelf.dataSource.count < 10) {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    } showSuccessMsg:nil];
}


- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    YYWeakSelf
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"orderover",@"act",user.userid,USERID,self.lastid,LASTID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:orderUrl parameters:para success:^(id response) {
        
        if (response) {
            NSMutableArray *arr = [YYOrderModel mj_objectArrayWithKeyValuesArray:response[@"user_order"]];
            [weakSelf.dataSource addObjectsFromArray:arr];
            weakSelf.lastid = response[LASTID];
            [weakSelf.tableView reloadData];
            if (arr.count < 10) {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}


#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 0) || self.dataSource.count == 0;
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
    
    YYOrderModel *model = self.dataSource[indexPath.row];
    [self checkMore:model.orderId];
}

#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYMineOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:YYMineOrderCellId];
    YYOrderModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    YYWeakSelf
    cell.moreBlock = ^(NSString *orderId) {

        [weakSelf checkMore:orderId];
    };
    
    cell.cancelOrderBlcok = ^(NSString *orderId,NSString *orderName,YYMineOrderCell *cell) {

        [weakSelf backOrder:indexPath];
    };
    
    return cell;
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 跳转订单的推送详情页，可查看研报*/
- (void)checkMore:(NSString *)orderId {
    
    YYYanbaoController *yanbaoDetail = [[YYYanbaoController alloc] init];
    yanbaoDetail.orderId = orderId;
    [self.navigationController pushViewController:yanbaoDetail animated:YES];
}

/** 跳转到取消订单控制器*/
- (void)backOrder:(NSIndexPath *)indexPath {
    
    YYBackOrderController *backOrderController = [[YYBackOrderController alloc] init];
    YYOrderModel *order = self.dataSource[indexPath.row];
    if ([order.paystatus isEqualToString:@"3"]) {//申请中
        
        backOrderController.isNeverCommited = NO;
    }else if ([order.paystatus isEqualToString:@"4"]) {//已退单
        backOrderController.isNeverCommited = NO;
    }else {
        backOrderController.isNeverCommited = YES;
    }
    backOrderController.orderId = order.orderId;
    __weak typeof(order) weakModel = order;
    YYWeakSelf
    backOrderController.backSucceedBlock = ^(NSString *orderId) {
        
        weakModel.paystatus = @"3";
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:weakModel];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:backOrderController animated:YES];
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
        [_tableView registerClass:[YYMineOrderCell class] forCellReuseIdentifier:YYMineOrderCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YYWeakSelf
        
        YYStateHeader *stateHeader = [YYStateHeader headerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadData];
        }];
        _tableView.mj_header = stateHeader;
        
        YYBackNormalFooter *stateFooter = [YYBackNormalFooter footerWithRefreshingBlock:^{

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


@end
