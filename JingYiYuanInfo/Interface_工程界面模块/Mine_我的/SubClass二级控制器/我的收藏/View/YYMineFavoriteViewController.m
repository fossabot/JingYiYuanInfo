//
//  YYMineFavoriteViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineFavoriteViewController.h"

#import "YYMineCollectionCell.h"
#import "YYMineCollectionModel.h"
#import "UITableViewRowAction+JZExtension.h"

#import "YYBaseInfoDetailController.h"
#import "YYProjectDetailController.h"
#import "YYNiuNewsDetailViewController.h"

#import "YYRefresh.h"
#import <MJExtension/MJExtension.h>

@interface YYMineFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;



@end

@implementation YYMineFavoriteViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    
    [self.view addSubview:self.tableView];
//    [self loadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadNewData];
}


#pragma mark -- network   数据请求方法  ---------------------------

- (void)loadNewData {
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showInfoWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }

    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"query",@"act", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (response) {
            
            weakSelf.dataSource = [YYMineCollectionModel mj_objectArrayWithKeyValuesArray:response[@"usercollect"]];
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

    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"query",@"act",self.lastid,LASTID, nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:inOutHistoryUrl parameters:para success:^(id response) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (response) {
            NSMutableArray *arr = [YYMineCollectionModel mj_objectArrayWithKeyValuesArray:response[@"usercollect"]];
            [self.dataSource addObjectsFromArray:arr];
            self.lastid = response[@"lastid"];
            if (arr) {
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





#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 去相应的文章详情页 类型:1资讯文章,2资讯视频 3牛人文章 4公社视频 5项目*/
- (void)goDetailVcAtIndexPath:(NSIndexPath *)indexPath {
 
    YYMineCollectionModel *collectionModel = self.dataSource[indexPath.row];
    if ([collectionModel.col_type isEqualToString:@"1"]) {
        
        YYBaseInfoDetailController *baseInfoDetailVc = [[YYBaseInfoDetailController alloc] init];
        baseInfoDetailVc.newsId = collectionModel.col_id;
        baseInfoDetailVc.url = collectionModel.webUrl;
        baseInfoDetailVc.shareUrl = collectionModel.shareUrl;
        baseInfoDetailVc.shareImgUrl = collectionModel.col_img;
        [self.navigationController pushViewController:baseInfoDetailVc animated:YES];
    }else if ([collectionModel.col_type isEqualToString:@"3"]) {
        
        YYNiuNewsDetailViewController *niuNewsDetailVc = [[YYNiuNewsDetailViewController alloc] init];
        niuNewsDetailVc.niuNewsId = collectionModel.col_id;
        niuNewsDetailVc.url = collectionModel.webUrl;
        niuNewsDetailVc.shareUrl = collectionModel.shareUrl;
        niuNewsDetailVc.shareImgUrl = collectionModel.col_img;
        niuNewsDetailVc.newsTitle = collectionModel.col_title;
        [self.navigationController pushViewController:niuNewsDetailVc animated:YES];
    }else if ([collectionModel.col_type isEqualToString:@"5"]) {
        
        YYProjectDetailController *projectDetailVc = [[YYProjectDetailController alloc] init];
        projectDetailVc.projectId = collectionModel.col_id;
        projectDetailVc.url = collectionModel.webUrl;
        projectDetailVc.shareUrl = collectionModel.shareUrl;
        projectDetailVc.shareImgUrl = collectionModel.col_img;
        [self.navigationController pushViewController:projectDetailVc animated:YES];
    }
}


#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 10);
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYMineCollectionModel *model = self.dataSource[indexPath.row];
    switch (model.newsType) {
        case 1:{
            YYBaseInfoDetailController *detail = [[YYBaseInfoDetailController alloc] init];
            detail.url = model.webUrl;
            detail.newsId = model.col_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 3:{
            
            YYNiuNewsDetailViewController *detail = [[YYNiuNewsDetailViewController alloc] init];
            detail.url = model.webUrl;
            detail.niuNewsId = model.col_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 5:{
            
            YYProjectDetailController *detail = [[YYProjectDetailController alloc] init];
            detail.url = model.webUrl;
            detail.projectId = model.col_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        default:
            break;
    }
}


//侧滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYMineCollectionModel *model = self.dataSource[indexPath.row];
    YYUser *user = [YYUser shareUser];
    YYWeakSelf
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        YYLog(@"%@", action);
        [weakSelf setEditing:false animated:true];
//userid=1499064765j6qavy&act=del&colid=7
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"del",@"act",model.collectionId,@"colid",user.userid,USERID, nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:collectionUrl parameters:para success:^(id response) {
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
        
    };
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    
    return @[delete];
}

#pragma -- mark TableViewDataSource  --------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYMineCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:YYMineCollectionCellId];
    YYMineCollectionModel *model = self.dataSource[indexPath.row];
    
    cell.model = model;
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YYMineCollectionCell class] forCellReuseIdentifier:YYMineCollectionCellId];
        
        YYWeakSelf
        
        YYNormalHeader *stateHeader = [YYNormalHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        _tableView.mj_header = stateHeader;
        
        YYBackStateFooter *stateFooter = [YYBackStateFooter footerWithRefreshingBlock:^{

            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = stateFooter;
        
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
