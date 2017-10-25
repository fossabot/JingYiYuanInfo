//
//  YYMineIntegrationViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineIntegrationViewController.h"
#import "YYIntegrationRulesDetailController.h"
#import "YYIODetailController.h"
#import "YYProductionHistoryController.h"
#import "YYGoodsDetailController.h"
#import "YYBuyIntegralController.h"

#import "YYIntegrationShopSecHeaderView.h"
#import "YYGoodsCollectionCell.h"
#import "YYGoodsModel.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

@interface YYMineIntegrationViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/** headerCiew*/
@property (nonatomic, strong) UIView *headerView;

/** moneyImageView*/
@property (nonatomic, strong) UIImageView *moneyImageView;

/** moneyLabel*/
@property (nonatomic, strong) UILabel *integrationLabel;

/** segmentView*/
@property (nonatomic, strong) UISegmentedControl *segmentView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *hot_arr;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *tj_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

/** collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** sectionHeader*/
@property (nonatomic, strong) YYIntegrationShopSecHeaderView *sectionHeader;

@end

@implementation YYMineIntegrationViewController


#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubView];
    [self refreshHeader:nil];
    [self loadNewData];
    [kNotificationCenter addObserver:self selector:@selector(refreshHeader:) name:YYUserInfoDidChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:YYUserInfoDidChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- network   数据请求方法  ---------------------------

- (void)loadNewData {
    
    if ([self.collectionView.mj_footer isRefreshing]) {
        [self.collectionView.mj_footer endRefreshing];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"goods",@"act", nil];
    YYWeakSelf
    [PPNetworkHelper GET:shopUrl parameters:para responseCache:^(id responseCache) {
        [self.collectionView.mj_header endRefreshing];
        if (responseCache) {
            weakSelf.hot_arr = [YYGoodsModel mj_objectArrayWithKeyValuesArray:responseCache[@"hot_arr"]];
            weakSelf.tj_arr = [YYGoodsModel mj_objectArrayWithKeyValuesArray:responseCache[@"tj_arr"]];
            weakSelf.lastid = responseCache[@"lastid"];
            [weakSelf.collectionView reloadData];
        }
    } success:^(id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        if (responseObject) {
            weakSelf.hot_arr = [YYGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"hot_arr"]];
            weakSelf.tj_arr = [YYGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"tj_arr"]];
            weakSelf.lastid = responseObject[@"lastid"];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadMoreData {
    
    if ([self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header endRefreshing];
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"moretj",@"act",self.lastid,LASTID, nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:shopUrl parameters:para success:^(id response) {
        [self.collectionView.mj_footer endRefreshing];
        if (response) {
            
            [weakSelf.tj_arr addObjectsFromArray:[YYGoodsModel mj_objectArrayWithKeyValuesArray:response[@"tj_arr"]]];
            weakSelf.lastid = response[@"lastid"];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
    
}

//购买积分
- (void)buyIntegral {
    
    YYBuyIntegralController *buyIntegralVc = [[YYBuyIntegralController alloc] init];
    [self.navigationController pushViewController:buyIntegralVc animated:YES];
}

#pragma mark -- layout 子控件配置及相关布局方法  ---------------------------

- (void)configSubView {
    
//    UIBarButtonItem *buy = [[UIBarButtonItem alloc] initWithTitle:@"购买积分" style:UIBarButtonItemStyleDone target:self action:@selector(buyIntegral)];
//    self.navigationItem.rightBarButtonItem = buy;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = ThemeColor;
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    UIImageView *moneyImageView = [[UIImageView alloc] initWithImage:imageNamed(@"yyfw_mine_integration_white_20x20")];
    [self.headerView addSubview:moneyImageView];
    self.moneyImageView = moneyImageView;
    
    UILabel *integrationLabel = [[UILabel alloc] init];
    integrationLabel.textColor = WhiteColor;
    integrationLabel.font = sysFont(25);
    integrationLabel.text = @"0";
    [self.headerView addSubview:integrationLabel];
    self.integrationLabel = integrationLabel;
    
    UISegmentedControl *segmentView = [[UISegmentedControl alloc] initWithItems:@[@"获取积分",@"收支明细",@"兑换记录"]];
    segmentView.layer.cornerRadius = 15.f;
    segmentView.layer.borderWidth = 1;
    segmentView.layer.borderColor = WhiteColor.CGColor;
    segmentView.layer.masksToBounds = YES;
    [segmentView setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:SubTitleFont} forState:UIControlStateNormal];
    segmentView.apportionsSegmentWidthsByContent = NO;
    segmentView.tintColor = WhiteColor;
    segmentView.backgroundColor = ThemeColor;
    segmentView.momentary = YES;
    [segmentView addTarget:self action:@selector(selectSegView:) forControlEvents:UIControlEventValueChanged];
    self.segmentView = segmentView;
    [self.headerView addSubview:segmentView];
    
    [self.view addSubview:self.collectionView];
    
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.moneyImageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.integrationLabel.left).offset(-10);
        make.bottom.equalTo(self.integrationLabel);
    }];
    
    [self.integrationLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.headerView);
//        make.centerY.equalTo(self.headerView).offset(-20);
        make.top.equalTo(20);
    }];
    
    [self.segmentView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.integrationLabel.bottom).offset(20);
        make.centerX.equalTo(self.headerView);
        make.height.equalTo(30);
        make.width.equalTo(250);
        make.bottom.equalTo(self.headerView.bottom).offset(-20);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.bottom);
        make.bottom.equalTo(self.view);
    }];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 刷新头部视图积分数*/
- (void)refreshHeader:(NSNotification *)notice {
    
    YYUser *user = [YYUser shareUser];
    
    self.integrationLabel.text = [NSString stringWithFormat:@"%@",user.integral];
}

- (void)selectSegView:(UISegmentedControl *)segView {
    
    if (segView.selectedSegmentIndex == 0) {
        
        YYIntegrationRulesDetailController *rule = [[YYIntegrationRulesDetailController alloc] init];
        rule.url = integrationRuleUrl;
        [self.navigationController pushViewController:rule animated:YES];
    }else if (segView.selectedSegmentIndex == 1){
        
        YYIODetailController *IODetailVc = [[YYIODetailController alloc] init];
        [self.navigationController pushViewController:IODetailVc animated:YES];
    }else if (segView.selectedSegmentIndex == 2){
        
        YYProductionHistoryController *history = [[YYProductionHistoryController alloc] init];
        [self.navigationController pushViewController:history animated:YES];
    }
    
}

#pragma mark -------  collectionView  代理区域  -------------------

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YYGoodsModel *model;
    if (indexPath.section == 0) {
        
        model = self.hot_arr[indexPath.row];
    }else {
        
        model = self.tj_arr[indexPath.row];
    }
    YYGoodsDetailController *detail = [[YYGoodsDetailController alloc] init];
    detail.url = model.webUrl;
    detail.shareImgUrl = model.pro_picture;
    detail.goodId = model.goodsId;
    detail.integral = model.pro_presentprice;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        YYIntegrationShopSecHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusableSectionHeader forIndexPath:indexPath];
        header.tip.text = indexPath.section==0 ? @"热门兑换" : @"为您推荐";
        return header;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.hot_arr.count;
    }
    return self.tj_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YYGoodsCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:YYGoodsCollectionCellId forIndexPath:indexPath];
    YYGoodsModel *good;
    if (indexPath.section == 0) {
        good = self.hot_arr[indexPath.row];
    }else {
        good = self.tj_arr[indexPath.row];
    }
    [collectionCell.imageView sd_setImageWithURL:[NSURL URLWithString:good.pro_picture] placeholderImage:imageNamed(@"placeholder")];
    collectionCell.title.text = good.pro_name;
    collectionCell.tagLabel.text = good.pro_label;
    collectionCell.integration.text = good.pro_presentprice;
    
    return collectionCell;
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((kSCREENWIDTH-30)/2, (kSCREENWIDTH-30)/2+70);
        _flowLayout.headerReferenceSize = CGSizeMake(kSCREENWIDTH, 30);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YYGoodsCollectionCell class] forCellWithReuseIdentifier:YYGoodsCollectionCellId];
        [_collectionView registerClass:[YYIntegrationShopSecHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableSectionHeader];
        YYWeakSelf
        _collectionView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        MJRefreshBackStateFooter *stateFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        
        [stateFooter setTitle:@"壹元君正努力为您加载中..." forState:MJRefreshStateRefreshing];
        _collectionView.mj_footer = stateFooter;
        
        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        [self.collectionView emptyViewConfiger:configer];
    }
    return _collectionView;
}

@end
