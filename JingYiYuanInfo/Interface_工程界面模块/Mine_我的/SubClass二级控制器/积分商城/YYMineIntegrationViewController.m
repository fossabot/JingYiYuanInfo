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
#import "YYRefresh.h"
#import "YYEightBtn.h"
#import <MJExtension/MJExtension.h>

#define buttonW 60
#define buttonH 67

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
{
    CGFloat cellWidth;
    CGFloat cellHeight;
}

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellWidth = (kSCREENWIDTH-38)/2;
    cellHeight = (132.f/169.f)*cellWidth+73;
    
    self.view.backgroundColor = GrayBackGroundColor;
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
    
    self.navigationItem.title = @"积分商城";
//    UIBarButtonItem *buy = [[UIBarButtonItem alloc] initWithTitle:@"购买积分" style:UIBarButtonItemStyleDone target:self action:@selector(buyIntegral)];
//    self.navigationItem.rightBarButtonItem = buy;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WhiteColor;
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    NSArray *imageArr = @[@"integration",@"incomeDetail",@"exchangeList",@"earnIntegration"];
    NSArray *fourBtnArr = @[@"0积分",@"收支明细",@"兑换记录",@"获取积分"];
    NSInteger index = 0;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *title in fourBtnArr) {
        
        YYEightBtn *btn = [[YYEightBtn alloc] init];
        btn.contentMode = UIViewContentModeCenter;
        btn.imageName = imageArr[index];
        btn.title = title;
        btn.titleColor = index == 0 ? ThemeColor : SubTitleColor;
        btn.userInteractionEnabled = index != 0;
        btn.titleMargin = 0;
        btn.buttonFont = 14;
        btn.tag = index + 100;
        btn.imageRect = CGRectMake(0, 0, buttonW, 44);
        btn.titleRect = CGRectMake(0, 53, buttonW, 14);
        [btn addTarget:self action:@selector(selectFourBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:btn];
        [temp addObject:btn];
        index ++;
    }
    
    [temp mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:afterScale(buttonW) leadSpacing:afterScale(YYInfoCellCommonMargin) tailSpacing:afterScale(YYInfoCellCommonMargin)];
    [temp makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(21);
        make.height.equalTo(buttonH);
        make.bottom.equalTo(-32);
    }];
    
    [self.view addSubview:self.collectionView];
    
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(buttonH+21+32);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.bottom).offset(8);
        make.bottom.equalTo(self.view);
    }];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 刷新头部视图积分数*/
- (void)refreshHeader:(NSNotification *)notice {
    
    YYUser *user = [YYUser shareUser];
//    self.integrationLabel.text = [NSString stringWithFormat:@"%@",user.integral];
    NSString *temp;
    NSInteger integra = [user.integral integerValue];
    if (integra > 10000) {
        temp = [NSString stringWithFormat:@"%.2f万",(float)integra/10000.f];
    }else {
        temp = user.integral;
    }
    YYEightBtn *btn = [self.headerView viewWithTag:100];
    btn.title = [NSString stringWithFormat:@"%@",temp];
    
}

/** 选中segmentcontrol的一个item*/
- (void)selectFourBtn:(YYEightBtn *)fourBtn {
    
    YYUser *user = [YYUser shareUser];
//    NSInteger segmentIndex = segView.selectedSegmentIndex;
    NSInteger index = fourBtn.tag - 100;
    if (index == 1) {
        
        YYIODetailController *IODetailVc = [[YYIODetailController alloc] init];
        [self.navigationController pushViewController:IODetailVc animated:YES];
    }else if (index == 2 && user.isLogin){
        
        YYProductionHistoryController *history = [[YYProductionHistoryController alloc] init];
        [self.navigationController pushViewController:history animated:YES];
    }else if (index == 3 && user.isLogin){
        
        YYIntegrationRulesDetailController *rule = [[YYIntegrationRulesDetailController alloc] init];
        rule.url = integrationRuleUrl;
        [self.navigationController pushViewController:rule animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus:@"账号未登录"];
        [SVProgressHUD dismissWithDelay:1];
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
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        
        YYIntegrationShopSecHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusableSectionHeader forIndexPath:indexPath];
        header.tip.text = indexPath.section == 0 ? @"热门兑换" : @"为您推荐";
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.frame = CGRectMake(0, 0, cellWidth, cellHeight);
//    borderLayer.lineWidth = 1.f;
//    borderLayer.strokeColor = lineColor.CGColor;
//    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, cellWidth, cellHeight) cornerRadius:5];
    maskLayer.path = bezierPath.CGPath;
//    borderLayer.path = bezierPath.CGPath;
    
//    [cell.contentView.layer insertSublayer:borderLayer atIndex:0];
    [cell.layer setMask:maskLayer];
     
     
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYGoodsCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:YYGoodsCollectionCellId forIndexPath:indexPath];
    YYGoodsModel *good;
    if (indexPath.section == 0) {
        good = self.hot_arr[indexPath.row];
    }else {
        good = self.tj_arr[indexPath.row];
    }
    [collectionCell.imageView sd_setImageWithURL:[NSURL URLWithString:good.pro_picture] placeholderImage:imageNamed(placeHolderMini)];
    collectionCell.title.text = good.pro_name;
    collectionCell.tagLabel.text = good.pro_label;
    collectionCell.integration.text = [good.pro_presentprice stringByAppendingString:@"积分"];
    
    return collectionCell;
    
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------


- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        cellWidth = (kSCREENWIDTH-38)/2;
////        cellHeight = (kSCREENWIDTH-39)/2+70;
//        cellHeight = (132.f/169.f)*cellWidth+73;
        _flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(9, 15, 9, 15);
        _flowLayout.headerReferenceSize = CGSizeMake(kSCREENWIDTH, 45);
        _flowLayout.minimumLineSpacing = 9;
        _flowLayout.minimumInteritemSpacing = 8;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = GrayBackGroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YYGoodsCollectionCell class] forCellWithReuseIdentifier:YYGoodsCollectionCellId];
        [_collectionView registerClass:[YYIntegrationShopSecHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableSectionHeader];
        YYWeakSelf
        _collectionView.mj_header = [YYStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        YYBackStateFooter *stateFooter = [YYBackStateFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
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
