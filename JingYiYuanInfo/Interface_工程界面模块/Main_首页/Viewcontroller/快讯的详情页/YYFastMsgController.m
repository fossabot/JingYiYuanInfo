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
    
    self.title = @"快讯";
    [self.view addSubview:self.tableView];
    [self loadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"morerollwords",@"act", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:fastMsgListUrl parameters:para success:^(id response) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (response) {
            
            weakSelf.dataSource = [YYFastMsgSecionModel mj_objectArrayWithKeyValuesArray:response[@"roll_words"]];
            weakSelf.lastdate = response[@"lastdate"];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    } showSuccessMsg:nil];
}

- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"morerollwords",@"act",self.lastdate,@"lastdate", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:fastMsgListUrl parameters:para success:^(id response) {
        
        NSArray *tempArr = [YYFastMsgSecionModel mj_objectArrayWithKeyValuesArray:response[@"roll_words"]];
        if (tempArr.count) {
            
            [weakSelf.dataSource addObjectsFromArray:tempArr];
            [weakSelf.tableView reloadData];
        }else {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.lastdate = response[@"lastdate"];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
}


#pragma -- mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYFastMsgSecionModel *secModel = self.dataSource[section];
    tableView.mj_footer.hidden = (secModel.info.count%10 != 0);
    return secModel.info.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
    view.backgroundColor = WhiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kSCREENWIDTH, 20)];
    label.textColor = UnenableTitleColor;
    label.font = TagLabelFont;
    YYFastMsgSecionModel *secModel = self.dataSource[section];
    label.text = secModel.date;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight+20) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //contentinset的上边距应该和tableview的高度同步，否则将tableview上移之后，但是高度没有增加，则尾部的加载更多的按钮会出现
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(0, YYCommonCellLeftMargin, 0, YYCommonCellLeftMargin);
        YYWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        MJRefreshBackNormalFooter *stateFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
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

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
