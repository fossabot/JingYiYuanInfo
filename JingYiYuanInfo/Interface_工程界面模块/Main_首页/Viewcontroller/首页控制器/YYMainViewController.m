//
//  YYMainViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/6/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainViewController.h"
#import "PresentAnimation.h"
#import "YYMessageController.h"
#import "YYMainSearchController.h"

#import "MJRefresh.h"
#import "MJExtension.h"

#import "UIView+YYViewInWindow.h"
#import "AppDelegate+YYAppService.h"

#import "YYMainModel.h"

#import "YYMainHeadBannerCell.h"
#import "YYMainRollwordsCell.h"
#import "YYMainEightBtnCell.h"
#import "YYMainMarketDataCell.h"
#import "YYMainPushCell.h"
#import "YYMainSrollpicCell.h"

#import "YYMainCycleWebviewController.h"
#import "YYDetailViewController.h"
#import "YYPushController.h"

#import "YYBottomContainerView.h"
#import "YYMainTouchTableView.h"

#import "IAPShare.h"

#define messageButtonWidth 25.f
#define searchButtonWidth 30.f
#define navSubviewHeight  30.f


@interface YYMainViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>


/** 导航栏View*/
@property (nonatomic, strong) UIView *navView;

/** 消息按钮*/
@property (nonatomic, strong) UIButton *messageBtn;

/** 搜索按钮*/
@property (nonatomic, strong) UIButton *searchBtn;

/** tableview*/
@property (nonatomic, strong) YYMainTouchTableView *tableview;

/** 数据源模型*/
@property (nonatomic, strong) YYMainModel *mainModel;

/** heightArr*/
@property (nonatomic, strong) NSArray *heights;


@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canScroll;


@end

@implementation YYMainViewController
{
//    YYPushController *_push;
//    YYContainerViewController *_footer;
    YYBottomContainerView *_footer;
    PresentAnimation *_presentAnimation;
}
#pragma mark -- lifeCycle 生命周期  ----------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _presentAnimation = [[PresentAnimation alloc] init];
//        self.transitioningDelegate = self;
//        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YYLog(@"首页的navigationcontroller的地址  %p",self.navigationController);
    
    [kNotificationCenter addObserver:self selector:@selector(repeatClickTabbar:) name:YYTabbarItemDidRepeatClickNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(acceptMsg:) name:YYMainVCLeaveTopNotificationName object:nil];

    //创建子控件们
    [self createSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self loadNewData];
    
    //检测版本更新
    [(AppDelegate*)kAppDelegate checkAppUpDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self name:YYTabbarItemDidRepeatClickNotification object:nil];
    [kNotificationCenter removeObserver:self name:YYMainVCLeaveTopNotificationName object:nil];
}


#pragma mark 检测是否有未支付订单，如果有，检测是否支付成功，然后从本地删除(失败)或者给后台传信息(成功)
- (void)paymentTransactionCheck {
    
//    [IAPShare sharedHelper].iap 
}


#pragma mark -- inner Methods 自定义方法  ----------------------------------------

/**
 *  创建子控件们
 */
- (void)createSubviews {
    
    [self.view addSubview:self.tableview];
    
    _footer = [[YYBottomContainerView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-YYTopNaviHeight)];
    self.tableview.tableFooterView = _footer;
    
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.searchBtn];
    [self.navView addSubview:self.messageBtn];
}

/** 两次点击maincontroller*/
- (void)repeatClickTabbar:(NSNotification *)notice {
    
    if (self.view.window == nil) return;
    if (![self.view yy_intersectsWithAnotherView:nil]) return;
    
    [self.tableview.mj_header beginRefreshing];
    
}


/** tab离开顶部时的通知*/
-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

/**
 *  点击消息按钮，进入消息列表
 */
- (void)messageClick:(UIButton *)messageBtn {
    YYLog(@"点击消息按钮");
    YYMessageController *message = [[YYMessageController alloc] init];
    message.jz_wantsNavigationBarVisible = YES;
    [self.navigationController pushViewController:message animated:YES];
}

/**
 *  跳转搜索页
 */
- (void)searchClick:(UIButton *)search {
    YYLog(@"首页搜索按钮点击");
    YYMainSearchController *mainSearchVc = [[YYMainSearchController alloc] init];
    [self.navigationController pushViewController:mainSearchVc animated:YES];
}

/**
 *  刷新数据
 */
- (void)loadNewData {

    //请求成功自动缓存，如果当前数据源有数据，说明是手动刷新的操作，这时不用将缓存赋值给数据源，如果没有，则是第一次初始化等，需要将缓存赋值给数据源等success时，再重新赋值，覆盖掉之前的
    [PPNetworkHelper GET:mainUrl parameters:nil responseCache:^(id responseCache) {
        if (!_mainModel.roll_pic.count) {
            
            self.mainModel = [YYMainModel mj_objectWithKeyValues:responseCache];
            [self.tableview reloadData];
        }
    } success:^(id responseObject) {
        
        [self.tableview.mj_header endRefreshing];
        if (responseObject) {
            
            self.mainModel = [YYMainModel mj_objectWithKeyValues:responseObject];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableview.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:NETERRORMSG];
        [SVProgressHUD dismissWithDelay:1];
        
    }];
    
    
}

#pragma -- mark TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = YYRGB(239, 239, 239);
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 0.00001;
            break;
            
        default:
            return 5.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        YYPushController *push = [[YYPushController alloc] init];
        push.jz_wantsNavigationBarVisible = YES;
        [self.navigationController pushViewController:push animated:YES];
    }
}

#pragma -- mark TableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            YYMainHeadBannerCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:YYMainHeadBannerCellID];
            bannerCell.headBannerModels = self.mainModel.roll_pic;
            return bannerCell;
        }
            break;
        
        case 1:{
            YYMainRollwordsCell *rollwordsCell = [tableView dequeueReusableCellWithIdentifier:YYMainRollwordsCellID];
            rollwordsCell.rollwordsModels = self.mainModel.roll_words;
//            rollwordsCell.rollwordsBlock = ^(NSInteger index, YYMainRollwordsCell *cell){
//#warning 文字轮播的跳转
//                
//            };
            return rollwordsCell;
        }
            break;
            
        case 2:{
            
            YYMainEightBtnCell *eightbtnCell = [tableView dequeueReusableCellWithIdentifier:YYMainEightBtnCellID];

            return eightbtnCell;
        }
            break;
            
        case 3:{
            YYMainMarketDataCell *marketdataCell = [tableView dequeueReusableCellWithIdentifier:YYMainMarketDataCellID];
            [marketdataCell.dataImageView sd_setImageWithURL:[NSURL URLWithString:self.mainModel.zhishu.picurl] placeholderImage:imageNamed(@"placeholder")];
            return marketdataCell;
        }
            break;
            
        case 4:{
            
            YYMainPushCell *pushCell = [tableView dequeueReusableCellWithIdentifier:YYMainPostMsgCellID];
            pushCell.postmsgmodel = self.mainModel.post_msg;

            return pushCell;
        }
            break;
            
        default:{
            
            YYMainSrollpicCell *scrollpicCell = [tableView dequeueReusableCellWithIdentifier:YYMainSrollpicCellID];
            scrollpicCell.srollpicModels = self.mainModel.sroll_pic;
            
            return scrollpicCell;
        }
            break;
    }

}

#pragma mark -- scrollview 代理方法

/**
 *  滚动时的代理方法，改变导航栏的颜色及搜索按钮尺寸
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat alpha = (contentOffsetY-35)/100;
    if (alpha >= 1) {
        alpha = 1;
    }else if(alpha <= 0){
        alpha = 0;
    }
    [self.navView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:alpha]];
    
    CGRect frame = self.searchBtn.frame;
    
    if (contentOffsetY > 75) {//变大啦啦啦
        frame.size.width = kSCREENWIDTH-60;
        frame.origin.x = 40;
        [UIView animateWithDuration:0.5 animations:^{
            self.searchBtn.frame = frame;
        }];
    }else if (contentOffsetY < 50) {//变小啦啦啦
        frame.size.width = 30;
        frame.origin.x = kSCREENWIDTH - 50;
        [UIView animateWithDuration:0.5 animations:^{
            self.searchBtn.frame = frame;
        }];
    }
    
    CGFloat tabOffsetY = [_tableview rectForFooterInSection:5].origin.y + [_tableview rectForFooterInSection:5].size.height - YYTopNaviHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=(int)tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:YYMainVCGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            scrollView.showsVerticalScrollIndicator = NO;
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                scrollView.showsVerticalScrollIndicator = NO;
            }
        }
    }

}


#pragma mark -------  自定义modal转场的代理方法  ---------------------------

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _presentAnimation;
}


#pragma mark -- lazyMethods 懒加载区域  -------------------------------------

/** 
 *  导航栏
 */
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 64)];
        _navView.backgroundColor = [ThemeColor colorWithAlphaComponent:0.f];
    }
    return _navView;
}

- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(10, 27, messageButtonWidth, navSubviewHeight);
        [_messageBtn setImage:imageNamed(@"yyfw_main_message_22x22") forState:UIControlStateNormal];
        [_messageBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREENWIDTH-50, 27, searchButtonWidth, navSubviewHeight);
        [_searchBtn setImage:imageNamed(@"yyfw_search_translucent_19x19_") forState:UIControlStateNormal];
        [_searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [_searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_searchBtn setTitle:@"   搜索股票、基金、债券" forState:UIControlStateNormal];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.titleLabel.font = SubTitleFont;
        _searchBtn.layer.cornerRadius = navSubviewHeight/2;
        _searchBtn.backgroundColor = YYRGBA(200, 200, 200, 0.7);
    }
    return _searchBtn;
}


- (YYMainModel *)mainModel{
    if (!_mainModel) {
        _mainModel = [[YYMainModel alloc] init];
    }
    return _mainModel;
}

- (YYMainTouchTableView *)tableview{
    if (!_tableview) {
        _tableview = [[YYMainTouchTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 100;
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        _tableview.rowHeight = UITableViewAutomaticDimension;
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        [_tableview setSeparatorInset:UIEdgeInsetsMake(0, 0, 49, 0)];
        MJWeakSelf
        _tableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            YYStrongSelf
            [strongSelf loadNewData];
            //给热搜和牛人发送通知，主界面刷新后子界面也要刷新
            [kNotificationCenter postNotificationName:YYMainRefreshNotification object:nil];
        }];
        
        [_tableview registerClass:[YYMainHeadBannerCell class] forCellReuseIdentifier:YYMainHeadBannerCellID];
        [_tableview registerClass:[YYMainRollwordsCell class] forCellReuseIdentifier:YYMainRollwordsCellID];
        [_tableview registerClass:[YYMainEightBtnCell class] forCellReuseIdentifier:YYMainEightBtnCellID];
        [_tableview registerClass:[YYMainMarketDataCell class] forCellReuseIdentifier:YYMainMarketDataCellID];
        [_tableview registerClass:[YYMainPushCell class] forCellReuseIdentifier:YYMainPostMsgCellID];
        [_tableview registerClass:[YYMainSrollpicCell class] forCellReuseIdentifier:YYMainSrollpicCellID];
    
    }
    
    return _tableview;
}

- (NSArray *)heights{
    if (!_heights) {
        //头部轮播等比例0.6，快讯36，八个icon20*3+60*2，行情数据87，推送消息154，横幅轮播宽度的0.2倍
        _heights = [NSArray arrayWithObjects:@(kSCREENWIDTH*0.6), @36, @180, @87, @154, @(kSCREENWIDTH*0.2), @((float)kSCREENHEIGHT-64-49), nil];
    }
    return _heights;
}

@end
