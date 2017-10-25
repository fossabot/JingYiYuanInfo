//
//  YYIODetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIODetailController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "YYIOModel.h"
#import "YYIOTableViewCell.h"

#define inoutUrl  @"http://yyapp.1yuaninfo.com/app/application/userintegral.php?userid=1499064765j6qavy&act=inall"

@interface YYIODetailController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYIODetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收支明细";
    
    [self.view addSubview:self.tableView];
    [self loadNewData];
    
}

#pragma mark -- network   数据请求方法  ---------------------------

- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"inall",@"act", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:inOutHistoryUrl parameters:para success:^(id response) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (response) {
            
            weakSelf.dataSource = [YYIOModel mj_objectArrayWithKeyValuesArray:response[@"inout"]];
            weakSelf.lastid = response[@"lastid"];
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
    
    YYUser *user = [YYUser shareUser];
//#warning userid需改成用户的
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"inall",@"act",self.lastid,LASTID, nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:inOutHistoryUrl parameters:para success:^(id response) {
        
        if (response) {
            NSMutableArray *arr = [YYIOModel mj_objectArrayWithKeyValuesArray:response[@"inout"]];
            [self.dataSource addObjectsFromArray:arr];
            self.lastid = response[@"lastid"];
            if (arr) {
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadData];
            }else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
}



#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYIOTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:YYIOTableViewCellId];
    YYIOModel *model = self.dataSource[indexPath.row];
    cell.title.text = model.goodtitle;
    cell.desc.text = model.addtime;
    cell.integration.text = model.amount;
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-64) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YYIOTableViewCell class] forCellReuseIdentifier:YYIOTableViewCellId];
        
        YYWeakSelf
        MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
        [stateFooter setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
        self.tableView.mj_footer = stateFooter;
        
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


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
