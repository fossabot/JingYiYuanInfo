//
//  YYCommentViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentViewController.h"
#import "YYCommentTableViewCell.h"

#import "MJRefresh.h"

@interface YYCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tableview*/
@property (nonatomic,strong)  UITableView *tableView;

/** 数据源dataSource*/
@property (nonatomic,strong)  NSMutableArray *datasource;

@end

@implementation YYCommentViewController


#pragma mark -- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:commentCellId];
    //配置MJ的刷新控件
    [self configMJRefresh];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark -- mannulMethods

/**
 配置MJ的刷新控件
 */
- (void)configMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}


/**
 加载最新数据
 */
- (void)loadNewData {
    //首先去掉上拉加载的网络请求
    [self.tableView.mj_footer endRefreshing];
    
#warning 尚未加载评论数据的模型
//    NSArray *arr;
//    [self.datasource removeAllObjects];
//    [self.datasource addObjectsFromArray:arr];
//    [self.tableView reloadData];

}


/**
 加载更多数据
 */
- (void)loadMoreData {
    
    //首先去掉下拉刷新的网络请求
    [self.tableView.mj_header endRefreshing];
    //    NSArray *arr = [YYInfoModelManager loadMoreInfoModelWithViewController:self];
    //    [self.datasource addObjectsFromArray:arr];
    [self.tableView reloadData];
}


#pragma mark -- lazyMethods

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 10);
        _tableView.separatorColor = GrayColor;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

#pragma -- mark tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYInfoCommentModel *model = self.datasource[indexPath.row];
    YYCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    cell.model = model;

    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
