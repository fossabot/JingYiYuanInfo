//
//  THBaseTableViewController.m
//  基类封装
//
//  Created by VINCENT on 2017/6/21.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseTableViewController.h"


@interface THBaseTableViewController ()

@end

@implementation THBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}


#pragma mark -- inner Methods 自定义方法


/**
 加载最新数据
 */
- (void)loadNewData {
    
    
    
}


/**
 加载更多数据
 */
- (void)loadMoreData {

    
    
}


#pragma mark -- lazyMethods 懒加载区域
/** 数据源数组懒加载*/
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma -- mark TableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
