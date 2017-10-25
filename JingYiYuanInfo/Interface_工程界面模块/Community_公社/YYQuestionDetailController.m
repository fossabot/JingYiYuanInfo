//
//  YYQuestionDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYQuestionDetailController.h"
#import "YYAnswerCell.h"
#import "YYDetailToolBar.h"
#import "YYAnswerModel.h"
#import "UIView+YYCategory.h"

#import <MJExtension/MJExtension.h>
#import "UITableView+FDTemplateLayoutCell.h"

@interface YYQuestionDetailController ()<UITableViewDelegate,UITableViewDataSource>

/** headerView*/
@property (nonatomic, strong) UIView *headerView;

/** 牛人头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 牛人名字*/
@property (nonatomic, strong) UILabel *name;

/** title*/
@property (nonatomic, strong) UILabel *titleLabel;

/** 我的问题*/
@property (nonatomic, strong) UILabel *question;


/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/* 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYQuestionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.icon cutRoundView];
}

- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendaqa",@"act",user.userid,USERID,self.articleId,@"artid", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            self.dataSource = [YYAnswerModel mj_objectArrayWithKeyValuesArray:response[@"info"]];
            [self.tableView reloadData];
            YYLog(@"我的问答response ----  %@",response[@"info"]);
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


#pragma mark tableview 代理方法  ---------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:YYAnswerCellId cacheByIndexPath:indexPath configuration:^(YYAnswerCell *cell) {
        
        YYAnswerModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YYAnswerModel *model = self.dataSource[indexPath.row];
//    
//}

#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYAnswerModel *model = self.dataSource[indexPath.row];
    YYAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:YYAnswerCellId];
    cell.model = model;
    return cell;
}

#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WhiteColor;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = TitleColor;
    titleLabel.font = TitleFont;
    titleLabel.text = _titleStr;
    self.titleLabel = titleLabel;
    [self.headerView addSubview:titleLabel];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon sd_setImageWithURL:[NSURL URLWithString:_iconUrl] placeholderImage:imageNamed(placeHolderMini)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 25.f;
    self.icon = icon;
    [self.headerView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = TitleFont;
    name.text = _nameStr;
    self.name = name;
    [self.headerView addSubview:name];
    
    UILabel *question = [[UILabel alloc] init];
    question.numberOfLines = 6;
    question.font = SubTitleFont;
    question.textColor = UnenableTitleColor;
    question.text = _questionStr;
    self.question = question;
    [self.headerView  addSubview:question];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = LightGraySeperatorColor;
    [self.headerView addSubview:bottomView];
    
    UILabel *tip = [[UILabel alloc] init];
//                    WithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
    tip.text = @"    全部回复";
    tip.textColor = SubTitleColor;
    tip.font = SubTitleFont;
    [self.view addSubview:tip];
//    _tableView.tableHeaderView = tip;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.toolBar];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];

    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(YYInfoCellSubMargin);
        make.width.height.equalTo(50);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.icon);
    }];
    
    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(-YYInfoCellCommonMargin);
//        make.top.equalTo(self.titleLabel.bottom).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.icon.bottom).offset(YYInfoCellCommonMargin);
    }];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.headerView);
        make.top.equalTo(self.question.bottom).offset(15);
        make.height.equalTo(5);
    }];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.bottom);
        make.height.equalTo(30);
    }];

    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(tip.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(45);
    }];

    
}


//提问牛人
- (void)askQuestionForNiuMan:(NSString *)question {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"useraddq",@"act", user.userid,USERID,self.articleId,@"artid", self.titleStr,@"arttitle", question, @"content",nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[STATE] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"提问成功,静候牛人给您的回复哦"];
                [weakSelf.toolBar clearText];
            }else {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，稍后再试"];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YYAnswerCell class] forCellReuseIdentifier:YYAnswerCellId];
        YYWeakSelf
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf loadData];
        };
        [_tableView emptyViewConfiger:configer];

    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (YYDetailToolBar *)toolBar {
    
    if (!_toolBar) {
        _toolBar = [[YYDetailToolBar alloc] init];
        _toolBar.toolBarType = DetailToolBarTypeWriteComment;
        _toolBar.placeHolder = @"  提问";
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf askQuestionForNiuMan:comment];
        };
    
    }
    return _toolBar;
}

@end
