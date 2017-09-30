//
//  YYNiuManDetailViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人详情页

#import "YYNiuManDetailViewController.h"
#import "UIBarButtonItem+YYExtension.h"
#import <MJRefresh/MJRefresh.h>

#import "YYNiuManDetailVM.h"
#import "YYNiuArticleCell.h"
#import "YYNiuArticleModel.h"
#import "YYNiuNewsDetailViewController.h"

@interface YYNiuManDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** uitableView*/
@property (nonatomic, strong) UITableView *tableView;

/** focus*/
@property (nonatomic, strong) UIBarButtonItem *focusItem;

/** viewModel*/
@property (nonatomic, strong) YYNiuManDetailVM *viewModel;

@end

@implementation YYNiuManDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSubView];
    [self loadNewData];
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)configSubView {
    
//    UIBarButtonItem *focusItem = [[UIBarButtonItem alloc] initWithTitle:@"+关注" style:UIBarButtonItemStyleDone target:self action:@selector(focus)];
//    self.navigationItem.rightBarButtonItem = focusItem;
//    self.focusItem = focusItem;

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:titleView.bounds];
    imageV.layer.cornerRadius = imageV.yy_height/2;
    imageV.layer.masksToBounds = YES;
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    self.imageView = imageV;
    [titleView addSubview:imageV];
    
    [self.view addSubview:self.tableView];
}

/**
 *  关注牛人
 */
- (void)focus {
    
    //关注后修改右耳目为已关注
    [self.focusItem setTitle:@"已关注"];
}

/**
 *  加载最新牛人观点
 */
- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        if (success) {

            [strongSelf.tableView reloadData];
        }
    }];

}

/**
 *  加载更多牛人观点
 */
- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    YYWeakSelf
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [strongSelf.tableView reloadData];
        }
    }];
}



/**
 *  监听滑动  改变头部头像的大小
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentSet = scrollView.contentOffset.y + _tableView.contentInset.top;
    
    if (contentSet <= 0 && contentSet >= -44) {
        self.imageView.transform = CGAffineTransformMakeScale(1 - contentSet/44, 1-contentSet/44);
        self.imageView.yy_y = 0;
    }else if (contentSet > 0) {
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
        self.imageView.yy_y = 0;
    }
    
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (YYNiuManDetailVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYNiuManDetailVM alloc] init];
        _viewModel.niuid = self.niuid;
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(id data, NSIndexPath *indexPath) {
            
            //跳转到相应的详情页（牛人详情或者新闻详情）
            YYStrongSelf
            YYNiuArticleModel *model = (YYNiuArticleModel *)data;
            YYNiuNewsDetailViewController *niuNewsDetail = [[YYNiuNewsDetailViewController alloc] init];
            niuNewsDetail.url = model.webUrl;
            niuNewsDetail.shareImgUrl = model.picurl;
            [strongSelf.navigationController pushViewController:niuNewsDetail animated:YES];
            
        };
        
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-64) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
        [self.tableView registerClass:[YYNiuArticleCell class] forCellReuseIdentifier:YYNiuArticleCellID];
        YYWeakSelf
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        /** 普通闲置状态  壹元君正努力为您加载数据*/
        footer.stateLabel.text = @"壹元君正努力为您加载中...";
        _tableView.mj_footer = footer;
        
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        header.stateLabel.text = @"壹元君正努力为您加载中...";
        _tableView.mj_header = header;
        
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



@end
