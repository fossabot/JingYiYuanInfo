//
//  YYThreeSeekDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  三找的公司详情界面

#import "YYThreeSeekDetailController.h"
#import "YYEdgeLabel.h"
#import "LabelContainer.h"
#import "YYThreeSeekTabView.h"

#import "YYThreeSeekDetailCompanyModel.h"
#import "YYRelativeProductionModel.h"

#import "YYThreeSeekIntroduceCell.h"
#import "YYProductionCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

//#import "YYPlaceHolderView.h"
#import "BAButton.h"
#import <MJExtension/MJExtension.h>

@interface YYThreeSeekDetailController ()<UITableViewDelegate,UITableViewDataSource,YYThreeSeekTabViewDelegate>


/** tipView*/
@property (nonatomic, strong) BAButton *tipView;

/** headerView*/
@property (nonatomic, strong) UIView *headerView;

/** logoImage 公司logo*/
@property (nonatomic, strong) UIImageView *logoImageView;

/** companyName 公司名称*/
@property (nonatomic, strong) UILabel *companyName;

/** regMoney */
@property (nonatomic, strong) UILabel *regMoney;

/** 功能标签*/
@property (nonatomic, strong) YYEdgeLabel *tag1;

/** 功能标签*/
@property (nonatomic, strong) YYEdgeLabel *tag2;

/** 认证标签*/
@property (nonatomic, strong) YYEdgeLabel *tag3;

/** separatorView分隔线*/
@property (nonatomic, strong) UIView *separatorView;

/** 自定义标签tag*/
@property (nonatomic, strong) LabelContainer *labelContainer;

/** tabItem*/
@property (nonatomic, strong) YYThreeSeekTabView *tabView;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;



/** 公司详情模型*/
@property (nonatomic, strong) YYThreeSeekDetailCompanyModel *companyDetailModel;

/** relativeProduction相关产品推荐*/
@property (nonatomic, strong) NSMutableArray *relativeProductions;

@end

@implementation YYThreeSeekDetailController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self masonrySubView];
    YYWeakSelf
    [YYHttpNetworkTool globalNetStatusNotice:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
//            [weakSelf emptyPlaceHolder];
            self.tipView.hidden = NO;
        }else {
            
            [weakSelf loadData];
        }
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isScrollToProduct == YES) {
        
        CGRect productRect = [self.tableView rectForHeaderInSection:2];
        [self.tableView scrollRectToVisible:productRect animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 网络请求得到数据 刷新控件*/
- (void)refreshData {
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.companyDetailModel.logo] placeholderImage:imageNamed(@"placeholder")];
    
    self.companyName.text = self.companyDetailModel.gname;
    self.regMoney.text = self.companyDetailModel.regmoney;
    if (self.companyDetailModel.comtype) {
        
        self.tag1.text = self.companyDetailModel.comtype;
    }else {
        [self.tag1 updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.right);
            make.width.equalTo(0);
        }];
    }
    if (self.companyDetailModel.auth_tag) {
        
        self.tag2.text = self.companyDetailModel.auth_tag;
    }else {
        
        [self.tag1 updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tag1.right);
            make.width.equalTo(0);
        }];
    }
    
//    [self.headerView updateConstraints:^(MASConstraintMaker *make) {
//       
//        make.bottom.equalTo(self.separatorView).offset(10);
//    }];
//    [self.labelContainer setTitles:nil];
//    [self.tag1 sizeToFit];
//    self.tag1.yy_x = self.companyName.yy_x;
//    self.tag1.yy_y =
//    self.headerView.yy_height = CGRectGetMaxY(self.separatorView.frame)+10;
//    self.tabView.yy_y = CGRectGetMaxY(self.headerView.frame)+10;
//    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.tabView.frame), kSCREENWIDTH, kSCREENHEIGHT-64-CGRectGetMaxY(self.tabView.frame));
    [self.tableView reloadData];
}

/** 无网络或者加载失败时调用的占位图片*/
- (void)emptyPlaceHolder {
    
//    YYWeakSelf
//    [YYPlaceHolderView showInView:self.view image:@"yyfw_push_empty_112x94_" clickAction:^{
//        [weakSelf loadData];
//    } dismissAutomatically:YES];

}


#pragma mark -- network   数据请求方法  ---------------------------

/** 加载数据*/
- (void)loadData {
    self.tipView.hidden = YES;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:self.comid,@"comid", nil];
    YYWeakSelf
    [PPNetworkHelper GET:companyDetailUrl parameters:para responseCache:^(id responseCache) {
        if (responseCache) {
            
            weakSelf.companyDetailModel = [YYThreeSeekDetailCompanyModel mj_objectWithKeyValues:responseCache[@"com_intro_arr"]];
            weakSelf.relativeProductions = [YYRelativeProductionModel mj_objectArrayWithKeyValuesArray:responseCache[@"prod_arr"]];
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            weakSelf.companyDetailModel = [YYThreeSeekDetailCompanyModel mj_objectWithKeyValues:responseObject[@"com_intro_arr"]];
            weakSelf.relativeProductions = [YYRelativeProductionModel mj_objectArrayWithKeyValuesArray:responseObject[@"prod_arr"]];
            [weakSelf refreshData];
        }
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
        [SVProgressHUD dismissWithDelay:1];
        
//        [weakSelf emptyPlaceHolder];
        weakSelf.tipView.hidden = NO;
    }];

}

#pragma -- mark TableViewDelegate  -------------------------

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self sectionHeaderForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    switch (indexPath.section) {
//        case 0:
//            return self.companyDetailModel.trendcontentHeight;
//            break;
//            
//        case 1:
////            return self.companyDetailModel.introductionHeight;
//            return 100;
//            break;
//            
//        default:
//            return 100;
//            break;
//    }
//
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.relativeProductions.count;
    }
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma -- mark TableViewDataSource  ---------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        case 1:{
            
            YYThreeSeekIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:YYThreeSeekIntroduceCellId];
            NSString *str = indexPath.section ? self.companyDetailModel.introduction : self.companyDetailModel.trendcontent;
            cell.introduce = str;
            return cell;
        }
            break;
            
        default:{
            
            YYProductionCell *cell = [tableView dequeueReusableCellWithIdentifier:YYProductionCellId];
            cell.commonModel = self.relativeProductions[indexPath.row];
            return cell;
        }
            break;
    }
    
}

#pragma mark -------  tabview的代理区域  --------------------------------

- (NSArray *)titlesOfTabs {
    return [self titles];
}

/** tab选中了相应的item*/
- (void)threeSeekTabViewSelectIndex:(NSInteger)index {
    
    if (index == 2 && self.relativeProductions.count == 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark -------  scrollview  代理方法  ----------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= [_tableView rectForHeaderInSection:1].origin.y ) { //公司简介的区域（小于section1的头部y）
        
        [self.tabView letMeSelectIndex:0];
    }else if (offsetY >= [_tableView rectForHeaderInSection:1].origin.y && offsetY < [_tableView rectForHeaderInSection:2].origin.y ) {
        
        [self.tabView letMeSelectIndex:1];
    }else {
        
        [self.tabView letMeSelectIndex:2];
    }
    
}


#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *headerView = [[UIView alloc] init];
//                          WithFrame:CGRectMake(0, 0, kSCREENWIDTH, 1)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
//                                  WithFrame:CGRectMake(10, 10, 100, 70)];
    [self.view addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *companyName = [[UILabel alloc] init];
//                            WithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame)+10, 10, kSCREENWIDTH-CGRectGetMaxX(logoImageView.frame)-20, 20)];
    companyName.font = TitleFont;
    [self.view addSubview:companyName];
    self.companyName = companyName;
    
    UILabel *regMoney = [[UILabel alloc] init];
//                         WithFrame:CGRectMake(CGRectGetMinX(companyName.frame), CGRectGetMaxY(companyName.frame), companyName.yy_width, 17)];
    regMoney.font = UnenableTitleFont;
    regMoney.textColor = UnenableTitleColor;
    [self.view addSubview:regMoney];
    self.regMoney = regMoney;
    
    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.layer.borderColor = ThemeColor.CGColor;
    tag1.textColor = ThemeColor;
    [self.view addSubview:tag1];
    self.tag1 = tag1;
    
    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
    tag2.layer.borderColor = ThemeColor.CGColor;
    tag2.textColor = ThemeColor;
    [self.view addSubview:tag2];
    self.tag2 = tag2;
    
//    YYEdgeLabel *tag3 = [[YYEdgeLabel alloc] init];
//    tag3.layer.borderColor = ThemeColor.CGColor;
//    tag3.textColor = ThemeColor;
//    [self.view addSubview:tag3];
//    self.tag3 = tag3;
    
    UIView *separatorView = [[UIView alloc] init];
//                             WithFrame:CGRectMake(10, CGRectGetMaxY(logoImageView.frame)+20, kSCREENWIDTH-20, 0.5)];
    [self.view addSubview:separatorView];
    self.separatorView = separatorView;
    
    LabelContainer *labelContainer = [[LabelContainer alloc] init];
//                                      WithFrame:CGRectMake(10, CGRectGetMaxY(separatorView.frame)+10, kSCREENWIDTH-20, 0.001)];
    [self.view addSubview:labelContainer];
    self.labelContainer = labelContainer;
    
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.tableView];
}


- (void)masonrySubView {
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
//        make.height.equalTo(90);
//        make.bottom.equalTo(self.separatorView.bottom).offset(10);
    }];

    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.view).offset(10);
        make.height.equalTo(70);
        make.width.equalTo(100);
    }];
    
    [self.companyName makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.logoImageView.right).offset(10);
        make.top.equalTo(self.logoImageView);
        make.right.equalTo(self.view.right).offset(-10);
    }];
    
    [self.regMoney makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.logoImageView.right).offset(10);
        make.top.equalTo(self.companyName.bottom).offset(2);
        make.right.equalTo(self.view.right).offset(-10);
    }];
    
    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.logoImageView.right).offset(10);
        make.bottom.equalTo(self.logoImageView.bottom);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right).offset(5);
        make.bottom.equalTo(self.logoImageView.bottom);
    }];
    
//    [self.tag3 makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.tag2.right).offset(5);
//        make.bottom.equalTo(self.logoImageView.bottom);
//    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.logoImageView.bottom).offset(10);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(0.5);
    }];
    
    [self.labelContainer makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(10);
        make.top.equalTo(self.separatorView.bottom).offset(10);
        make.right.equalTo(-10);
//        make.bottom.equalTo(self.headerView.bottom).offset(-10);
        make.height.equalTo(0.001);
    }];
    
    
    
    [self.tabView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.labelContainer.bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tabView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -------  辅助方法  -----------------

- (UIView *)sectionHeaderForSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
    view.backgroundColor = WhiteColor;
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 2, 20)];
    redView.backgroundColor = ThemeColor;
    [view addSubview:redView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 20)];
    title.text = [[self titles] objectAtIndex:section];
    title.font = TitleFont;
    title.textColor = TitleColor;
    [view addSubview:title];
    
    return view;
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYThreeSeekTabView *)tabView{
    if (!_tabView) {
        _tabView = [[YYThreeSeekTabView alloc] init];
//                    WithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame)+10, kSCREENWIDTH, 40)];
        _tabView.delegate = self;
    }
    return _tabView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabView.frame), kSCREENWIDTH, kSCREENHEIGHT-64-CGRectGetMaxY(self.tabView.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WhiteColor;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YYThreeSeekIntroduceCell class] forCellReuseIdentifier:YYThreeSeekIntroduceCellId];
        [_tableView registerClass:[YYProductionCell class] forCellReuseIdentifier:YYProductionCellId];
    }
    return _tableView;
}


- (BAButton *)tipView{
    if (!_tipView) {
        _tipView = [BAButton creatButtonWithFrame:CGRectMake(0, 0, 160, 154) title:@"网络出错，点此重新加载" selTitle:@"网络出错，点此重新加载" titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:14] image:[UIImage imageNamed:@"yyfw_push_empty_112x94_"] selImage:[UIImage imageNamed:@"yyfw_push_empty_112x94_"] buttonPositionStyle:BAButtonPositionStyleTop target:self selector:@selector(loadData)];
        _tipView.hidden = YES;
        _tipView.yy_centerX = self.view.yy_centerX;
        _tipView.yy_centerY = self.view.yy_centerY-40;
        _tipView.padding = 20;
        [self.view addSubview:_tipView];
    }
    return _tipView;
}

- (NSArray *)titles {
    
    return @[@"公司简介",@"公司动态",@"产品推荐"];
}

@end
