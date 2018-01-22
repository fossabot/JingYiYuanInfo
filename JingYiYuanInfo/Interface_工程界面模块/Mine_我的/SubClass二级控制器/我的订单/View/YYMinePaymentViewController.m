//
//  YYMinePaymentViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMinePaymentViewController.h"

#import "YYYanbaoController.h"
#import "YYMineOrderCell.h"
#import "YYOrderModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

#define yanbaoDetailUrl @"http://yyapp.1yuaninfo.com/app/houtai/admin/pdfReport.php"
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
    
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 0);
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
    
    YYWeakSelf
    cell.yanbaoBlock = ^(NSString *orderId) {
        
        YYYanbaoController *yanbaoDetail = [[YYYanbaoController alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@orderid=%@",yanbaoDetailUrl,orderId];
        yanbaoDetail.url = url;
        [weakSelf.navigationController pushViewController:yanbaoDetail animated:YES];
    };
    
    __weak typeof(tableView) weakTable = tableView;
    cell.cancelOrderBlcok = ^(NSString *orderId,NSString *orderName,YYMineOrderCell *cell) {
        
        NSIndexPath *index = [weakTable indexPathForCell:cell];
        [weakSelf alertUserToConfirmCancelOrder:orderId orderName:orderName indexPath:index];
    };
    
    return cell;
}


/** 提示用户是否真的是要取消这个订单*/
- (void)alertUserToConfirmCancelOrder:(NSString *)orderId orderName:(NSString *)orderName indexPath:(NSIndexPath *)indexPath {
    
    NSString *tip = [NSString stringWithFormat:@"您是否确定取消 %@ 这个订单",orderName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消订单" message:tip preferredStyle:UIAlertControllerStyleAlert];
    
    YYWeakSelf
    UIAlertAction *confim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf postServerToCancelThisOrder:orderId indexPath:indexPath];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confim];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)postServerToCancelThisOrder:(NSString *)orderId indexPath:(NSIndexPath *)indexPath {
    
    YYWeakSelf
    YYUser *user = [YYUser shareUser];
    [YYHttpNetworkTool GETRequestWithUrlstring:cancelOrderUrl parameters:@{@"userid":user.userid,@"orderid":orderId} success:^(id response) {
        
        YYOrderModel *model = weakSelf.dataSource[indexPath.row];
        model.paystatus = @"3";
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [SVProgressHUD showSuccessWithStatus:@"已提交退单申请，稍后工作人员会与您联系，请保持通讯畅通"];
        [SVProgressHUD dismissWithDelay:2];
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
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
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.mj_footer.hidden = YES;
        };
        [self.tableView emptyViewConfiger:configer];
        
    }
    return _tableView;
}


@end
