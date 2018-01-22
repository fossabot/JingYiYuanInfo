//
//  YYSecondCommentController.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSecondCommentController.h"
#import "YYDetailToolBar.h"
#import "YYCommentView.h"
#import "THBaseTableView.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIView+YYCategory.h"

#import "YYCommentModel.h"
#import "YYSecCommentModel.h"
#import "YYCommentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "YYSecondCommentController.h"

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYSecondCommentController ()<UITableViewDelegate,UITableViewDataSource>

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

@property (nonatomic, strong) THBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *lastid;

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *tip;

@end

@implementation YYSecondCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self loadComment];
}


- (void)configSubView {
    
    UIView *header = [[UIView alloc] init];
    [self.view addSubview:header];
    
    UIImageView *avatar = [[UIImageView alloc] init];
    [avatar sd_setImageWithURL:[NSURL URLWithString:_firstCommentModel.avatar] placeholderImage:imageNamed(placeHolderAvatar)];
    self.avatar = avatar;
    [header addSubview:avatar];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = SubTitleFont;
    name.text = _firstCommentModel.username;
    self.name = name;
    [header addSubview:name];
    
    UILabel *comment = [[UILabel alloc] init];
    comment.textColor = SubTitleColor;
    comment.font = TitleFont;
    comment.numberOfLines = 0;
    comment.text = _firstCommentModel.reply_msg;
    [comment setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.comment = comment;
    [header addSubview:comment];
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    time.text = _firstCommentModel.create_date;
    self.time = time;
    [header addSubview:time];
    

    UILabel *tip = [[UILabel alloc] init];
    tip.font = SubTitleFont;
    tip.textColor = TitleColor;
    tip.text = @"    全部回复";
    self.tip = tip;
    [header addSubview:tip];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];

    [header makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.avatar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.width.height.equalTo(40);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatar.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.avatar);
    }];
    
    [self.comment makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatar.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.name);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.top.equalTo(self.comment.bottom).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.tip makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(header);
        make.top.equalTo(self.time.bottom);
        make.height.equalTo(30);
        make.bottom.equalTo(header.bottom).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(header.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(ToolBarHeight);
    }];
    
    [self.view layoutIfNeeded];
    [self.avatar cutRoundView];
}

/* 加载评论数据*/
- (void)loadComment {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }

    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"relaymore",@"act",self.commentid,@"commentid",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        [self.tableView.mj_header endRefreshing];
        if (response) {
            
            self.dataSource = [YYSecCommentModel mj_objectArrayWithKeyValuesArray:response[@"reply_comment"]];
            self.lastid = response[LASTID];
            
            if (self.dataSource.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    } showSuccessMsg:nil];
}


/* 加载更多评论数据*/
- (void)loadMoreComment {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }

    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"relaymore",@"act",self.commentid,@"commentid",user.userid,USERID,self.lastid,LASTID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        [self.tableView.mj_footer endRefreshing];
        
        if (response) {
            
            NSMutableArray *arr = [YYSecCommentModel mj_objectArrayWithKeyValuesArray:response[@"reply_comment"]];
            [self.dataSource addObjectsFromArray:arr];
            if (arr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.lastid = response[LASTID];
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
    } showSuccessMsg:nil];
}

/* 点赞的回调*/
- (void)zan:(NSString *)coomentId zanState:(BOOL)zanState {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = nil;
    if (zanState) {//cell回调返回要点赞还是取消的状态  yes点赞  no取消
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"addlike",@"act",@"1",@"comment",coomentId,@"commentid",user.userid,USERID, nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"dellike",@"act",@"1",@"comment",coomentId,@"commentid",user.userid,USERID, nil];
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



/* 回复一级评论*/
- (void)writeComment:(YYCommentModel *)model comment:(NSString *)comment{
    
    YYWeakSelf
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = yyyyMMddHHmmss;
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    YYUser *user = [YYUser shareUser];
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"1",@"comment",weakSelf.newsId,@"articleid",user.userid,USERID,comment,@"reply_msg",model.commentid,@"comment_id",model.userid,@"to_user_id",model.username,@"to_user_name",user.avatar,@"user_avatar", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
        
        YYStrongSelf
        if (response) {//state  1成功0失败
            
            if ([response[STATE] isEqualToString:@"1"]) {
                YYLog(@"回复er级评论成功");
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                YYSecCommentModel *secModel = [[YYSecCommentModel alloc] init];
                secModel.zan_count = @"0";
                secModel.user_avatar = user.avatar;
                secModel.from_user_name = user.username;
                secModel.to_user_name = model.username;
                secModel.from_user_id = user.userid;
                secModel.to_user_id = model.userid;
                secModel.reply_msg = comment;
                secModel.create_date = now;
                secModel.flag = @"0";
                secModel.comment_id = model.commentid;
                [strongSelf.dataSource insertObject:secModel atIndex:0];
                NSIndexPath *indexPath0 = [NSIndexPath  indexPathForRow:0 inSection:0];
                [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath0] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.toolBar clearText];
            }else {
                
                YYLog(@"回复二级评论失败");
                [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
            }
           
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];


}

/* 回复二级评论的cell回调*/
- (void)writeToSecondComment:(YYSecCommentModel *)secondComment {
    
    YYWeakSelf
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = yyyyMMddHHmmss;
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    
    YYUser *user = [YYUser shareUser];
    YYCommentView *commmentView = [[YYCommentView alloc] init];
    __weak typeof(commmentView) weakCommentView = commmentView;
    commmentView.placeHolder = [NSString stringWithFormat:@"回复%@",secondComment.from_user_name];
    commmentView.commentBlock = ^(NSString *comment) {
        
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"addcomment",@"act",@"1",@"comment",weakSelf.newsId,@"articleid",user.userid,USERID,comment,@"reply_msg",_firstCommentModel.commentid,@"comment_id",secondComment.from_user_id,@"to_user_id",secondComment.from_user_name,@"to_user_name",user.avatar,@"user_avatar", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:articleCommentUrl parameters:para success:^(id response) {
            
            YYStrongSelf
            if (response) {//state  1成功0失败
                
                if ([response[STATE] isEqualToString:@"1"]) {
                    YYLog(@"回复二级评论成功");
                    [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                    
                    YYSecCommentModel *secModel = [[YYSecCommentModel alloc] init];
                    secModel.zan_count = @"0";
                    secModel.user_avatar = user.avatar;
                    secModel.from_user_name = user.username;
                    secModel.to_user_name = secondComment.from_user_name;
                    secModel.from_user_id = user.userid;
                    secModel.to_user_id = secondComment.from_user_id;
                    secModel.reply_msg = comment;
                    secModel.create_date = now;
                    secModel.flag = @"0";
                    secModel.comment_id = _firstCommentModel.commentid;
                    [strongSelf.dataSource insertObject:secModel atIndex:0];
                    NSIndexPath *indexPath0 = [NSIndexPath  indexPathForRow:0 inSection:0];
                    [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath0] withRowAnimation:UITableViewRowAnimationNone];
                    [weakCommentView clearText];
                }else {
                    
                    YYLog(@"回复二级评论失败");
                    [SVProgressHUD showErrorWithStatus:@"服务器繁忙！稍后再试"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    };
    [commmentView show];
}

#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYSecCommentModel *model = self.dataSource[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:YYCommentCellId cacheByIndexPath:indexPath configuration:^(YYCommentCell *cell) {
        
        cell.secModel = model;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYLog(@"选中了cell  ---  %ld",indexPath.row);
    
}



#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYSecCommentModel *model = self.dataSource[indexPath.row];
    YYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:YYCommentCellId];
    YYWeakSelf
    cell.zanBlock = ^(id data, YYCommentCell *cell, BOOL zanState) {
    
        YYSecCommentModel *secCommentModel = (YYSecCommentModel *)data;
        NSString * commentId = secCommentModel.secComment_id;
       
        [weakSelf zan:commentId zanState:zanState];
    };
    
    cell.feedBackBlock = ^(id data){
        
        YYSecCommentModel *secCommentModel = (YYSecCommentModel *)data;
        [weakSelf writeToSecondComment:secCommentModel];
    };
    
    cell.fatherCommentUserName = _firstCommentModel.username;
    cell.secModel = model;
    return cell;
}

#pragma mark  setter  --------------------

-(void)setFirstCommentModel:(YYCommentModel *)firstCommentModel {
    _firstCommentModel = firstCommentModel;

}


#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (YYDetailToolBar *)toolBar {
    
    if (!_toolBar) {
        
        _toolBar = [[YYDetailToolBar alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT-YYTopNaviHeight-ToolBarHeight, kSCREENWIDTH, ToolBarHeight)];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment;
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf writeComment:weakSelf.firstCommentModel comment:comment];
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
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YYCommentCell class] forCellReuseIdentifier:YYCommentCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        YYWeakSelf
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//            YYStrongSelf
//            [strongSelf loadComment];
//        }];
        
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreComment];
        }];
//        _tableView.mj_footer.automaticallyHidden = YES;
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无回复";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf loadComment];
        };
        [self.tableView emptyViewConfiger:configer];

    }
    return _tableView;
}



- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
