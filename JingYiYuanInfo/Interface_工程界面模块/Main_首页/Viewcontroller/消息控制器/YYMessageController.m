//
//  YYMessageController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  首页左上角消息按钮进入的界面

#import "YYMessageController.h"
#import "YYMessageViewModel.h"
#import "YYMessageDetailController.h"

#import <MJRefresh/MJRefresh.h>

@interface YYMessageController ()

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYMessageViewModel *viewModel;

@end

@implementation YYMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    [self.view addSubview:self.tableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  刷新数据
 */
- (void)loadNewData {
    
    [self.viewModel loadNewDataCompletion:^(BOOL success) {
        
        
    }];
}



#pragma mark -------  无数据时的占位图片  -----------------------------

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return imageNamed(@"yyfw_push_empty_112x94_");
//}

//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    
//    [self loadNewData];
//}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.tableFooterView = [[UIView alloc] init];
        YYWeakSelf
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
    }
    return _tableView;
}

- (YYMessageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYMessageViewModel alloc] init];
        YYWeakSelf
        _viewModel.cellSelectBlock = ^(NSString *msgId, NSString *title){
            
            YYStrongSelf
            YYMessageDetailController *detailVc = [[YYMessageDetailController alloc] init];
            
            detailVc.url = messagedetailUrl(msgId);
            detailVc.shareTitle = title;
            [strongSelf.navigationController pushViewController:detailVc animated:YES];
        };
    }
    return _viewModel;
}

@end
