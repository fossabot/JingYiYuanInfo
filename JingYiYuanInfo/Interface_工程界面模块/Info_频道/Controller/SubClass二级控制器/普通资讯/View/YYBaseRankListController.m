//
//  YYBaseRankListController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  排行列表界面

#import "YYBaseRankListController.h"
#import "YYBaseRankDetailController.h"

#import "YYHotTableViewCell.h"
#import "YYBaseHotModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface YYBaseRankListController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYBaseRankListController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.tableView];
    [self loadMoreData];
}

- (void)loadMoreData {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"rankmore",@"act",self.lastid,@"rank_lastid",self.classid,@"classid", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:rankMoreUrl parameters:para success:^(id response) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (response) {
            
            weakSelf.dataSource = [YYBaseHotModel mj_objectArrayWithKeyValuesArray:response[@"rank_arr"]];
            weakSelf.lastid = response[@"rank_lastid"];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
}


#pragma -- mark TableViewDelegate  ---------------------------


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    YYBaseHotModel *model = self.dataSource[indexPath.row];
    CGFloat height = [tableView fd_heightForCellWithIdentifier:YYHotTableViewCellId cacheByIndexPath:indexPath configuration:^(YYHotTableViewCell *hotCell) {
        [hotCell setBaseModel:model andIndex:indexPath.row];
    }];
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYLog(@"点击了 %ld 行",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYBaseHotModel *model = self.dataSource[indexPath.row];
    YYBaseRankDetailController *detail = [[YYBaseRankDetailController alloc] init];
    detail.url = model.self_link;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma -- mark TableViewDataSource  ---------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYHotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:YYHotTableViewCellId];
    YYBaseHotModel *model = self.dataSource[indexPath.row];
    [cell setBaseModel:model andIndex:indexPath.row];
    return cell;
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[YYHotTableViewCell class] forCellReuseIdentifier:YYHotTableViewCellId];
        
        YYWeakSelf
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        /** 普通闲置状态  壹元君正努力为您加载数据*/
        footer.stateLabel.text = @"壹元君正努力为您加载中...";
        _tableView.mj_footer = footer;
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无问答数据";
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
