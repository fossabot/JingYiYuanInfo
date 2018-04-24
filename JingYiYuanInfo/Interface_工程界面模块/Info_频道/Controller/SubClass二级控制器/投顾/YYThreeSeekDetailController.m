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
#import "THBaseTableView.h"

#import "YYProductionDetailController.h"

#import "YYThreeSeekDetailCompanyModel.h"
#import "YYProductionCommonModel.h"

#import "YYThreeSeekIntroduceCell.h"
#import "YYProductionCell.h"
#import "YYEmptyDataCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import <MJExtension/MJExtension.h>

@interface YYThreeSeekDetailController ()<UITableViewDelegate,UITableViewDataSource,YYThreeSeekTabViewDelegate>


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

/** separatorView分隔线*/
@property (nonatomic, strong) UIView *separatorView;

/** 自定义标签tag*/
@property (nonatomic, strong) LabelContainer *labelContainer;

/** tabItem*/
@property (nonatomic, strong) YYThreeSeekTabView *tabView;

/** tableView*/
@property (nonatomic, strong) THBaseTableView *tableView;

/** 公司详情模型*/
@property (nonatomic, strong) YYThreeSeekDetailCompanyModel *companyDetailModel;

/** relativeProduction相关产品推荐*/
@property (nonatomic, strong) NSMutableArray *relativeProductions;

@end

@implementation YYThreeSeekDetailController
{
    BOOL _tabSelecting;
}
#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self masonrySubView];
    [self loadData];
    
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
    }else{
        [self.tag2 updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.companyName.left);
        }];
    }
    
    if (self.companyDetailModel.auth_tag) {
        self.tag2.text = self.companyDetailModel.auth_tag;
    }
    
    [self.tableView reloadData];
}


#pragma mark -- network  数据请求方法  ---------------------------

/** 加载数据*/
- (void)loadData {

    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:self.comid,@"comid", nil];
    YYWeakSelf
    [PPNetworkHelper GET:companyDetailUrl parameters:para responseCache:^(id responseCache) {
        if (responseCache) {
            
            weakSelf.companyDetailModel = [YYThreeSeekDetailCompanyModel mj_objectWithKeyValues:responseCache[@"com_intro_arr"]];
            weakSelf.relativeProductions = [YYProductionCommonModel mj_objectArrayWithKeyValuesArray:responseCache[@"prod_arr"]];
            [weakSelf refreshData];
        }
        [SVProgressHUD dismissWithDelay:1];
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            weakSelf.companyDetailModel = [YYThreeSeekDetailCompanyModel mj_objectWithKeyValues:responseObject[@"com_intro_arr"]];
            weakSelf.relativeProductions = [YYProductionCommonModel mj_objectArrayWithKeyValuesArray:responseObject[@"prod_arr"]];
            [weakSelf refreshData];
        }
        [SVProgressHUD dismissWithDelay:1];
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
        [SVProgressHUD dismissWithDelay:1];
        
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.relativeProductions.count ? self.relativeProductions.count : 1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 2) {
        
        return [tableView fd_heightForCellWithIdentifier:YYThreeSeekIntroduceCellId cacheByIndexPath:indexPath configuration:^(YYThreeSeekIntroduceCell *cell) {
            
            NSString *str = indexPath.section ? self.companyDetailModel.trendcontent : self.companyDetailModel.introduction;
            cell.introduce = str;
        }];
    }else {
        if (!self.relativeProductions.count) {
            return 250;
        }
        return 110;
//        [tableView fd_heightForCellWithIdentifier:YYProductionCellId cacheByIndexPath:indexPath configuration:^(YYProductionCell *cell) {
        
//            cell.commonModel = self.relativeProductions[indexPath.row];
//        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && self.relativeProductions.count) {
        
        YYProductionDetailController *productionDetail = [[YYProductionDetailController alloc] init];
        YYProductionCommonModel *commonModel = self.relativeProductions[indexPath.row];
        productionDetail.url = commonModel.webUrl;
        [self.navigationController pushViewController:productionDetail animated:YES];
        
    }
}

#pragma -- mark TableViewDataSource  ---------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        case 1:{
            
            YYThreeSeekIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:YYThreeSeekIntroduceCellId];
            NSString *str = indexPath.section == 0 ? self.companyDetailModel.introduction : self.companyDetailModel.trendcontent;
            cell.introduce = str;
            return cell;
        }
            break;
            
        default:{
            
            
            if (!self.relativeProductions.count) {
                YYEmptyDataCell *empptyCell = [tableView dequeueReusableCellWithIdentifier:YYEmptyDataCellId];
                return empptyCell;
            }else{
                YYProductionCell *cell = [tableView dequeueReusableCellWithIdentifier:YYProductionCellId];
                cell.commonModel = self.relativeProductions[indexPath.row];
                return cell;
            }
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
    
    _tabSelecting = YES;
    
    CGRect secRect = [self.tableView rectForSection:index];
    YYLog(@"secrect  ----  %@ ----",NSStringFromCGRect(secRect));
    [self.tableView setContentOffset:secRect.origin animated:YES];
//    [self.tableView scrollRectToVisible:secRect animated:NO];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


#pragma mark -------  scrollview  代理方法  ----------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    YYLog(@"scrollViewDidScroll  --- 1");
    
    if (!_tabSelecting) {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY <= [_tableView rectForHeaderInSection:1].origin.y ) { //公司简介的区域（小于section1的头部y）
            
            [self.tabView letMeSelectIndex:0];
        }else if (offsetY >= [_tableView rectForHeaderInSection:1].origin.y && offsetY < [_tableView rectForHeaderInSection:2].origin.y ) {
            
            [self.tabView letMeSelectIndex:1];
        }else {
            
            [self.tabView letMeSelectIndex:2];
        }
    }
    
}

//开始拖动的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    YYLog(@"BeginDragging  --- 3");
    _tabSelecting = NO;
}

#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self.view addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *companyName = [[UILabel alloc] init];
    companyName.font = TitleFont;
    [self.view addSubview:companyName];
    self.companyName = companyName;
    
    UILabel *regMoney = [[UILabel alloc] init];
    regMoney.font = UnenableTitleFont;
    regMoney.textColor = UnenableTitleColor;
    [self.view addSubview:regMoney];
    self.regMoney = regMoney;
    
    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.font = TagLabelFont;
    tag1.textColor = ThemeColor;
    tag1.layer.borderColor = ThemeColor.CGColor;
    [self.view addSubview:tag1];
    self.tag1 = tag1;
    
    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
    tag2.font = TagLabelFont;
    tag2.textColor = ThemeColor;
    tag2.layer.borderColor = ThemeColor.CGColor;
    [self.view addSubview:tag2];
    self.tag2 = tag2;
    
    UIView *separatorView = [[UIView alloc] init];
    [self.view addSubview:separatorView];
    self.separatorView = separatorView;
    
    LabelContainer *labelContainer = [[LabelContainer alloc] init];
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
       
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.logoImageView);
        make.right.equalTo(self.view.right).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.regMoney makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.companyName.bottom).offset(2);
        make.right.equalTo(self.view.right).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.logoImageView.bottom);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.logoImageView.bottom);
    }];
    
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
        
        make.top.equalTo(self.tabView.bottom).offset(YYInfoCellCommonMargin);
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
        _tabView.delegate = self;
    }
    return _tabView;
}

- (THBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabView.frame)+YYInfoCellCommonMargin, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight-YYInfoCellCommonMargin-CGRectGetMaxY(self.tabView.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WhiteColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, YYTopNaviHeight, 0);
        [_tableView registerClass:[YYThreeSeekIntroduceCell class] forCellReuseIdentifier:YYThreeSeekIntroduceCellId];
        [_tableView registerClass:[YYProductionCell class] forCellReuseIdentifier:YYProductionCellId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YYEmptyDataCell class]) bundle:nil] forCellReuseIdentifier:YYEmptyDataCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        [self.tableView emptyViewConfiger:configer];
        
    }
    return _tableView;
}



- (NSArray *)titles {
    
    return @[@"公司简介",@"公司动态",@"产品推荐"];
}

@end
