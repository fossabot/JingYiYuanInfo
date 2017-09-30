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

@end

@implementation YYQuestionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WhiteColor;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    UIImageView *icon = [[UIImageView alloc] init];
    self.icon = icon;
    [self.headerView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = TitleFont;
    self.name = name;
    [self.headerView addSubview:name];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = TitleColor;
    titleLabel.font = TitleFont;
    self.titleLabel = titleLabel;
    [self.headerView addSubview:titleLabel];
    
    UILabel *question = [[UILabel alloc] init];
    question.numberOfLines = 0;
    question.font = SubTitleFont;
    question.textColor = UnenableTitleColor;
    self.question = question;
    [self.headerView  addSubview:question];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = LightGraySeperatorColor;
    [self.headerView addSubview:bottomView];
    
    
    [self.view addSubview:self.tableView];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.headerView);
        make.width.height.equalTo(50);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(10);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.left);
        make.right.equalTo(-15);
        make.top.equalTo(self.icon.bottom).offset(10);
    }];
    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.title);
        make.right.equalTo(-15);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
    }];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.headerView);
        make.top.equalTo(self.question.bottom).offset(15);
        make.height.equalTo(5);
    }];

    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.headerView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
        tip.text = @"    全部回复";
        tip.textColor = TitleColor;
        tip.font = SubTitleFont;
        _tableView.tableHeaderView = tip;
    }
    return _tableView;
}

@end
