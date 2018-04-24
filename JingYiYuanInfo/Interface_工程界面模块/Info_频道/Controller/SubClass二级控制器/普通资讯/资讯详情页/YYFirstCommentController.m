//
//  YYFirstCommentController.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYFirstCommentController.h"

#import "THBaseTableView.h"
#import "YYDetailToolBar.h"
#import "YYCommentView.h"
#import "YYCommentSectionHeader.h"
#import "UIViewController+BackButtonHandler.h"

#import "YYCommentModel.h"
#import "YYCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "YYSecondCommentController.h"

#import <MJExtension/MJExtension.h>
#import "YYRefresh.h"

@interface YYFirstCommentController ()<UITableViewDelegate,UITableViewDataSource>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

@property (nonatomic, strong) THBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYFirstCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"全部评论";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    [self loadComment];
}


/* 加载评论数据*/
- (void)loadComment {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"firstmore",@"act",self.newsId,@"articleid",user.userid,USERID, nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        if (response) {
            
            weakSelf.dataSource = [YYCommentModel mj_objectArrayWithKeyValuesArray:response[@"first_comment"]];
            weakSelf.lastid = response[LASTID];
            if (weakSelf.dataSource.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        YYLog(@"加载全部评论  --  error %@",error);
    } showSuccessMsg:nil];
    
    
}


/* 加载更多评论数据*/
- (void)loadMoreComment {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"firstmore",@"act",self.newsId,@"articleid",user.userid,USERID, nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (response) {
            
            NSMutableArray *arr = [YYCommentModel mj_objectArrayWithKeyValuesArray:response[@"first_comment"]];
            [weakSelf.dataSource addObjectsFromArray:arr];
            weakSelf.lastid = response[LASTID];
            if (arr.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
}

/* 点赞的回调*/
- (void)zan:(NSString *)commentId zanState:(BOOL)zanState {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = nil;
    if (zanState) {//cell回调返回要点赞还是取消的状态  yes点赞  no取消
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"addlike",@"act",@"0",@"comment",commentId,@"commentid",user.userid,USERID, nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"dellike",@"act",@"0",@"comment",commentId,@"commentid",user.userid,USERID, nil];
    }
    
    // comment  0一级评论 1回复评论
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        if (response) {//1成功0失败
            NSString *state = response[STATE];
            if ([state isEqualToString:@"1"]) {
                
                NSString *tip = zanState ? @"点赞成功" : @"取消点赞";
                YYLog(@"%@",tip);
            }else {
                NSString *tip = zanState ? @"点赞失败" : @"取消点赞失败";
                YYLog(@"%@",tip);
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/* 回复评论的回调*/
- (void)writeComment:(YYCommentModel *)model {
    
    YYWeakSelf
    YYUser *user = [YYUser shareUser];
    YYCommentView *commmentView = [[YYCommentView alloc] init];
    __weak typeof(commmentView) weakCommentView = commmentView;
    commmentView.placeHolder = [NSString stringWithFormat:@"回复%@",model.username];
    commmentView.commentBlock = ^(NSString *comment) {
        
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"1",@"comment",weakSelf.newsId,@"articleid",user.userid,USERID,comment,@"reply_msg",model.commentid,@"comment_id",model.userid,@"to_user_id",model.username,@"to_user_name",user.avatar,@"user_avatar", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
            
            if (response) {//state  1成功0失败
                
                if ([response[STATE] isEqualToString:@"1"]) {
                    YYLog(@"回复一级评论成功");
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                    [weakCommentView clearText];
                }else {
                    YYLog(@"回复一级评论失败");
                    [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    };
    [commmentView show];
    
}

/* 评论文章*/
- (void)commentToArticle:(NSString *)commentStr {
    
    YYWeakSelf
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = yyyyMMddHHmmss;
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"0",@"comment",self.newsId,@"articleid",user.userid,USERID,commentStr,@"reply_msg", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        YYStrongSelf
        if (response) {//state  1成功0失败
            
            if ([response[STATE] isEqualToString:@"1"]) {
                YYLog(@"评论文章成功");
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                
                YYCommentModel *model = [[YYCommentModel alloc] init];
                model.zan_count = @"0";
                model.avatar = user.avatar;
                model.username = user.username;
                model.userid = user.userid;
                model.reply_msg = commentStr;
                model.create_date = now;
                model.flag = @"0";
                [strongSelf.dataSource insertObject:model atIndex:0];
                NSIndexPath *indexPath0 = [NSIndexPath  indexPathForRow:0 inSection:1];
                [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath0] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.toolBar clearText];
            }else {
                
                YYLog(@"评论文章失败");
                [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
    
}


#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.hotDataSource.count;
    }
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 0) || self.dataSource.count == 0;
    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return [YYCommentSectionHeader replyViewFirst];
    }
    return [YYCommentSectionHeader replyViewLast];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommentModel *model;
    if (indexPath.section == 0) {
         model = self.hotDataSource[indexPath.row];
    }else {
        model = self.dataSource[indexPath.row];
    }
    return [tableView fd_heightForCellWithIdentifier:YYCommentCellId cacheByIndexPath:indexPath configuration:^(YYCommentCell *cell) {
        
        cell.model = model;
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYLog(@"选中了cell  ---  %ld",indexPath.row);
    YYCommentModel *model;
    if (indexPath.section == 0) {
        model = self.hotDataSource[indexPath.row];
    }else {
        model = self.dataSource[indexPath.row];
    }
    YYSecondCommentController *secCommentVc = [[YYSecondCommentController alloc] init];
    secCommentVc.commentid = model.commentid;
    secCommentVc.newsId = self.newsId;
    secCommentVc.firstCommentModel = model;
    [self.navigationController pushViewController:secCommentVc animated:YES];
    
}


#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommentModel *model;
    if (indexPath.section == 0) {
        model = self.hotDataSource[indexPath.row];
    }else {
        model = self.dataSource[indexPath.row];
    }
    YYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:YYCommentCellId];
    //  隐藏每个分区最后一个cell的分割线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 2.自定义Cell
        cell.separatorView.hidden = YES;
    }
    else
    {
        cell.separatorView.hidden = NO;
    }
    
    YYWeakSelf
    cell.zanBlock = ^(id data, YYCommentCell *cell, BOOL zanState) {
        
        
        YYCommentModel *commentModel = (YYCommentModel *)data;
        NSString *commentId = commentModel.commentid;
        [weakSelf zan:commentId zanState:zanState];
    };
    
    cell.feedBackBlock = ^(id data){
        
        YYCommentModel *commentModel = (YYCommentModel *)data;
        [weakSelf writeComment:commentModel];
    };
    
    cell.model = model;
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (YYDetailToolBar *)toolBar {
    
    if (!_toolBar) {
        
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-YYTopNaviHeight-ToolBarHeight, kSCREENWIDTH, ToolBarHeight)];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment;
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf commentToArticle:comment];
        };
    }
    return _toolBar;
}

- (THBaseTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, ToolBarHeight, 0);
        [_tableView registerClass:[YYCommentCell class] forCellReuseIdentifier:YYCommentCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YYWeakSelf
        
        YYBackFooter *footer = [YYBackFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreComment];
        }];
        _tableView.mj_footer = footer;
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无评论";
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


- (NSMutableArray *)hotDataSource {
    
    if (!_hotDataSource) {
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
