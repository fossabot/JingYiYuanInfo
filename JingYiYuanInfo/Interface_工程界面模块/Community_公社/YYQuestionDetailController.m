//
//  YYQuestionDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYQuestionDetailController.h"

#import "THBaseTableView.h"
#import "YYAnswerCell.h"
#import "YYDetailToolBar.h"
#import "YYAnswerModel.h"
#import "UIView+YYCategory.h"

#import <MJExtension/MJExtension.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "NSString+Size.h"

@interface YYQuestionDetailController ()<UITableViewDelegate,UITableViewDataSource>

/** headerView*/
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *bgView;

/** 牛人头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 牛人名字*/
@property (nonatomic, strong) UILabel *name;

/** 关注牛人的按钮focus*/
@property (nonatomic, strong) UIButton *focus;

/** title*/
@property (nonatomic, strong) UILabel *titleLabel;

/** 我的问题*/
@property (nonatomic, strong) UILabel *question;

/** extendButton*/
@property (nonatomic, strong) UIButton *extendButton;

/** 时间*/
@property (nonatomic, strong) UILabel *time;

/** tableView*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** toolBar*/
@property (nonatomic, strong) YYDetailToolBar *toolBar;

/* 数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYQuestionDetailController
{
    BOOL _followState;  //关注牛人的状态
    CGFloat questionHeight; //问题的高度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"问答";
    [self configSubView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkFollowState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.bgView cutRoundViewRadius:5];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [_toolBar removeCommentView];
}

- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendaqa",@"act",user.userid,USERID,self.articleId,@"artid", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            self.dataSource = [YYAnswerModel mj_objectArrayWithKeyValuesArray:response[@"info"]];
            [self.tableView reloadData];
            self.tableView.tableHeaderView = self.headerView;
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



#pragma mark tableview 数据源方法  ---------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYAnswerModel *model = self.dataSource[indexPath.row];
    YYAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:YYAnswerCellId];
    cell.niuManName = [self.nameStr stringByAppendingString:@":"];
    cell.model = model;
//    cell.niuMan.text = [self.nameStr stringByAppendingString:@":"];
    return cell;
}

#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WhiteColor;
    self.headerView = headerView;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.toolBar];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 20.f;
    [icon sd_setImageWithURL:[NSURL URLWithString:_iconUrl] placeholderImage:imageNamed(placeHolderMini)];
    self.icon = icon;
    [self.headerView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = TitleColor;
    name.font = [UIFont boldSystemFontOfSize:17];;
    name.text = _nameStr;
    self.name = name;
    [self.headerView addSubview:name];
    
    UIButton *focus = [UIButton buttonWithType:UIButtonTypeCustom];
    [focus setImage:imageNamed(@"niu_focus") forState:UIControlStateNormal];
    [focus setImage:imageNamed(@"niu_focused") forState:UIControlStateSelected];
    [focus addTarget:self action:@selector(focusNiuMan:) forControlEvents:UIControlEventTouchUpInside];
    self.focus = focus;
    [self.headerView addSubview:focus];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = YYRGB(245, 245, 245);
    bgView.layer.cornerRadius = 3;
    self.bgView = bgView;
    [self.headerView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = TitleColor;
    titleLabel.font = shabiFont5;
    titleLabel.text = _titleStr;
    self.titleLabel = titleLabel;
    [self.headerView addSubview:titleLabel];
    
    UILabel *question = [[UILabel alloc] init];
    question.numberOfLines = 0;
    question.font = shabiFont4;
    question.textColor = UnenableTitleColor;
    question.attributedText = _questionStr;
    self.question = question;
    [self.headerView addSubview:question];
    
    UIButton *extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [extendButton setImage:imageNamed(@"niu_question_donw") forState:UIControlStateNormal];
    [extendButton addTarget:self action:@selector(extend:) forControlEvents:UIControlEventTouchUpInside];
    self.extendButton = extendButton;
    [self.headerView addSubview:extendButton];
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = LightSubTitleColor;
    time.text = _timeStr;
    self.time = time;
    [self.headerView addSubview:time];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = LightGraySeperatorColor;
    [self.headerView addSubview:bottomView];
    
    UIImageView *redView = [[UIImageView alloc] init];
    redView.backgroundColor = ThemeColor;
    [self.headerView addSubview:redView];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.text = @"全部回复";
    tip.textColor = TitleColor;
    tip.font = shabiFont5;
    [self.headerView addSubview:tip];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = LightGraySeperatorColor;
    [self.headerView addSubview:separator];

    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];

    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(self.view);
    }];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(14);
        make.top.equalTo(15);
        make.width.height.equalTo(40);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(17);
        make.left.equalTo(self.icon.right).offset(17);
    }];
    
    [self.focus makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(12);
        make.right.equalTo(-14);
    }];
    
    [bgView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.name.left);
        make.top.equalTo(self.name.bottom).offset(15);
        make.right.equalTo(-14);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.top).offset(12);
        make.left.equalTo(bgView.left).offset(10);
        make.right.equalTo(-10);
    }];
    
    questionHeight = [NSString attributeString:self.questionStr size:CGSizeMake(kSCREENWIDTH - 123, MAXFLOAT)].height;
    if (questionHeight > 45) {//有展开按钮
        
        [self.question makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.bottom).offset(15);
            make.left.equalTo(bgView.left).offset(12);
            make.right.equalTo(bgView.right).offset(-20);
            make.height.equalTo(45);
        }];
        
        [self.extendButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.question.bottom).offset(15);
            make.left.equalTo(bgView.left).offset(12);
            make.right.equalTo(bgView.right).offset(-20);
            make.bottom.equalTo(bgView.bottom).offset(-5);
        }];
    }else {
        
        [self.question makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.bottom).offset(15);
            make.left.equalTo(bgView.left).offset(12);
            make.right.equalTo(bgView.right).offset(-20);
            make.height.equalTo(questionHeight);
        }];
        
        [self.extendButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.question.bottom);
            make.left.equalTo(bgView.left).offset(12);
            make.right.equalTo(bgView.right).offset(-20);
            make.bottom.equalTo(bgView.bottom);
            make.height.equalTo(0);
        }];
    }
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView);
        make.top.equalTo(bgView.bottom).offset(15);
    }];
    
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.headerView);
        make.top.equalTo(self.time.bottom).offset(15);
        make.height.equalTo(8);
    }];
    
    [redView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomView.bottom).offset(15);
        make.left.equalTo(14);
        make.width.equalTo(2);
        make.height.equalTo(16);
    }];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomView.bottom).offset(15);
        make.left.equalTo(redView.right).offset(11);
        make.height.equalTo(15);
        make.bottom.equalTo(self.headerView.bottom).offset(-15);
    }];
    
    [separator makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.headerView);
        make.left.equalTo(redView);
        make.right.equalTo(-14);
        make.height.equalTo(0.5);
    }];

    [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(45);
    }];
    
}



#pragma mark -- inner Methods 自定义方法  -------------------------------

//提问牛人
- (void)askQuestionForNiuMan:(NSString *)question {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"useraddq",@"act", user.userid,USERID,self.articleId,@"artid", self.titleStr,@"arttitle", question, @"content",nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[STATE] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"提问成功,静候牛人给您的回复哦"];
                [weakSelf.toolBar clearText];
                [weakSelf loadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，稍后再试"];
            }
            [SVProgressHUD dismissWithDelay:1];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/** 展开问题*/
- (void)extend:(UIButton *)sender {
    
//    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH - 123, MAXFLOAT)];
//    temp.attributedText = self.questionStr;
//    CGFloat height = [temp sizeThatFits:CGSizeMake(kSCREENWIDTH - 123, MAXFLOAT)].height;
//    CGFloat height = [NSString attributeString:self.questionStr size:CGSizeMake(kSCREENWIDTH - 123, MAXFLOAT)].height;
//    CGFloat height = [self.questionStr sizeWithFont:SubTitleFont size:CGSizeMake(kSCREENWIDTH - 123, MAXFLOAT)].height;
    [self.question remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.bottom).offset(15);
        make.left.equalTo(self.bgView.left).offset(12);
        make.right.equalTo(self.bgView.right).offset(-20);
    }];
    
    [sender updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0);
    }];
//    self.question.numberOfLines = 0;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = self.headerView;
    
}



//检查关注牛人状态
- (void)checkFollowState {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        return;
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"quebyniuid",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[@"info"] isEqualToString:@"1"]) {
                self.focus.selected = YES;
                _followState = YES;
            }else {
                _followState = NO;
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


/** 关注牛人*/
- (void)focusNiuMan:(UIButton *)sender {
        
    //关注后修改右耳目为已关注
    //  info=  1查询时候标识已经关注/添加时候表示成功 0未关注/添加失败
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账户"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    NSDictionary *para = nil;
    if (!_followState) {
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[@"info"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                    sender.selected = YES;
                    _followState = YES;
                }else if([response[@"info"] isEqualToString:@"1"]){
                    [SVProgressHUD showErrorWithStatus:@"文章错误或者牛人不存在"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"delbyniuid",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[STATE] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"取消关注"];
                    sender.selected = NO;
                    _followState = NO;
                }else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
            
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }

}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (THBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 40, 0);
        _tableView.separatorInset = UIEdgeInsetsMake(0, YYInfoCellCommonMargin, 0, YYInfoCellCommonMargin);
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
        _toolBar.placeHolder = @"提问";
        YYWeakSelf
        _toolBar.sendCommentBlock = ^(NSString *comment) {
            
            [weakSelf askQuestionForNiuMan:comment];
        };
    
    }
    return _toolBar;
}

@end
