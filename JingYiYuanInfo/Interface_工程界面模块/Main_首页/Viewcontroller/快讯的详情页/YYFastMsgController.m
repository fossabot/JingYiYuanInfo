//
//  YYFastMsgController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  快讯列表界面

#import "YYFastMsgController.h"
#import "YYMainFastMsgDetailController.h"
#import "YYFastMsgCell.h"
#import "YYFastMsgSecionModel.h"
#import "YYMainRollwordsModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYFastMsgController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** lastdate*/
@property (nonatomic, copy) NSString *lastdate;

@end

@implementation YYFastMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)loadNewData {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"morerollwords",@"act", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:fastMsgListUrl parameters:para success:^(id response) {
        
        self.dataSource = [YYFastMsgSecionModel mj_objectArrayWithKeyValuesArray:response[@"roll_words"]];
        self.lastdate = response[@"lastdate"];
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

- (void)loadMoreData {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"morerollwords",@"act",self.lastdate,@"lastdate", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:fastMsgListUrl parameters:para success:^(id response) {
        NSArray *tempArr = [YYFastMsgSecionModel mj_objectArrayWithKeyValuesArray:response[@"roll_words"]];
        if (tempArr.count) {
            
            [self.dataSource addObjectsFromArray:tempArr];
        }else {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.lastdate = response[@"lastdate"];
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


#pragma -- mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYFastMsgSecionModel *secModel = self.dataSource[section];
    return secModel.info.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 20)];
    view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREENWIDTH, 20)];
    label.textColor = UnenableTitleColor;
    label.font = UnenableTitleFont;
    YYFastMsgSecionModel *secModel = self.dataSource[section];
    label.text = secModel.date;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYFastMsgSecionModel *secModel = self.dataSource[indexPath.section];
    YYMainRollwordsModel *cellModel = secModel.info[indexPath.row];
    YYMainFastMsgDetailController *fastDetailVc = [[YYMainFastMsgDetailController alloc] init];
    fastDetailVc.wid = cellModel.wid;
    fastDetailVc.url = [NSString stringWithFormat:@"%@%@",fastMsgDetailUrl,cellModel.wid];
    [self.navigationController pushViewController:fastDetailVc animated:YES];
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    YYFastMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YYFastMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    YYFastMsgSecionModel *secModel = self.dataSource[indexPath.section];
    YYMainRollwordsModel *cellModel = secModel.info[indexPath.row];
    cell.title.text = cellModel.title;
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        YYWeakSelf
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
           
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        _tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
