//
//  YYBaseRankListController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  排行列表界面

#import "YYBaseRankListController.h"
#import "YYBaseRankDetailController.h"

#import "THBaseTableView.h"
#import "YYHotTableViewCell.h"
#import "YYBaseHotModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YYRefresh.h"
#import <MJExtension/MJExtension.h>

@interface YYBaseRankListController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) THBaseTableView *tableView;

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
    
    self.tableView.mj_footer.hidden = (self.dataSource.count%10 != 0) || self.dataSource.count == 0;
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

- (THBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[YYHotTableViewCell class] forCellReuseIdentifier:YYHotTableViewCellId];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

#warning 没有MJHeader
        
        YYWeakSelf
        YYBackStateFooter *footer = [YYBackStateFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = footer;
        
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

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
