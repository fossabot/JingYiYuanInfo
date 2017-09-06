//
//  THBaseTableViewController.h
//  基类封装
//
//  Created by VINCENT on 2017/6/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "MJRefresh.h"

@interface THBaseTableViewController : THBaseViewController

/** 表视图*/
@property (nonatomic, strong) UITableView *tableView;

/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;



/**
 添加刷新控件，子类直接调用
 */
- (void)addRefresControl;

/**
 加载最新数据
 */
- (void)loadNewData;

/**
 加载更多数据
 */
- (void)loadMoreData;

@end
