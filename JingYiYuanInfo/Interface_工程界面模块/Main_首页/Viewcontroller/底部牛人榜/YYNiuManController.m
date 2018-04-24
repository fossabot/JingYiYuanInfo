//
//  YYNiuManController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/17.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManController.h"

#import "YYNiuManDetailViewController.h"
#import "YYNiuManIntroduceController.h"


@interface YYNiuManController ()

/** focus*/
@property (nonatomic, strong) UIBarButtonItem *focusItem;

/** niuid*/
@property (nonatomic, copy) NSString *niu_id;

/** aid*/
@property (nonatomic, copy) NSString *aid;

/** 牛人名称*/
@property (nonatomic, copy) NSString *niu_name;

/** 牛人介绍*/
@property (nonatomic, copy) NSString *niu_introduce;

/** 牛人图片*/
@property (nonatomic, copy) NSString *niu_img;

/** 牛人人气值*/
@property (nonatomic, copy) NSString *niu_pop;

@end

@implementation YYNiuManController
{
    BOOL _followState;  //关注牛人的状态
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.niu_name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *focusItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(focus)];
    focusItem.image = imageNamed(@"project_favor_normal_20x20");
    self.navigationItem.rightBarButtonItem = focusItem;
    self.focusItem = focusItem;
    
    self.navigationItem.title = self.niuManModel.niu_name;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 40)
        contentViewFrame:CGRectMake(0, 40, screenSize.width, kSCREENHEIGHT-40-64)];
    self.tabBar.backgroundColor = ThemeColor;
    self.tabBar.itemTitleColor = WhiteColor;
    self.tabBar.itemTitleSelectedColor = WhiteColor;
    self.tabBar.itemTitleFont = TitleFont;
    self.tabBar.itemTitleSelectedFont = NavTitleFont;
    self.tabBar.indicatorColor = WhiteColor;
    
    [self.tabBar setIndicatorWidthFixTextAndMarginTop:38 marginBottom:0 widthAdditional:20 tapSwitchAnimated:YES];
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemColorChangeFollowContentScroll = NO;
    
    [self setContentScrollEnabled:YES tapSwitchAnimated:YES];
    self.interceptRightSlideGuetureInFirstPage = YES;
    self.loadViewOfChildContollerWhileAppear = YES;
    self.tabBar.delegate = self;
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    [self checkFollowState];
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    
    NSMutableArray *viewContrllers = [NSMutableArray array];
    
    YYNiuManIntroduceController *introduceVc = [[YYNiuManIntroduceController alloc] init];
    introduceVc.yp_tabItemTitle = @"个人简介";
    introduceVc.niu_name = self.niu_name;
    introduceVc.niu_pop = self.niu_pop;
    introduceVc.niu_img = self.niu_img;
    introduceVc.niu_introduce = self.niu_introduce;
    [viewContrllers addObject:introduceVc];
    
    YYNiuManDetailViewController *detailVc = [[YYNiuManDetailViewController alloc] init];
    detailVc.yp_tabItemTitle = @"发布文章";
    detailVc.aid = self.aid;
    detailVc.niuid = self.niu_id;
    [viewContrllers addObject:detailVc];
    
    self.viewControllers = viewContrllers;
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
                //                [_focusItem setTitle:@"已关注"];
                [_focusItem setImage:imageNamed(@"project_favor_white_20x20")];
                _followState = YES;
            }else {
                _followState = NO;
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}

/**
 *  关注牛人
 */
- (void)focus {
    
    //关注后修改右耳目为已关注
    //  info=  1查询时候标识已经关注/添加时候表示成功 0未关注/添加失败
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账户"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    YYWeakSelf
    NSDictionary *para = nil;
    if (!_followState) {
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[@"info"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                    //                    [_focusItem setTitle:@"已关注"];
                    [_focusItem setImage:imageNamed(@"project_favor_white_20x20")];
                    _followState = YES;
                }else if([response[@"info"] isEqualToString:@"1"]){
                    [SVProgressHUD showErrorWithStatus:@"文章错误或者牛人不存在"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
            
            if (weakSelf.focusChangedBlock) {
                weakSelf.focusChangedBlock();
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"delbyniuid",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[STATE] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"取消关注"];
                    //                    [_focusItem setTitle:@"关注"];
                    [_focusItem setImage:imageNamed(@"project_favor_normal_20x20")];
                    _followState = NO;
                }else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
            if (weakSelf.focusChangedBlock) {
                weakSelf.focusChangedBlock();
            }
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }
    
}




#pragma mark  setter

- (void)setNiuManModel:(YYNiuManModel *)niuManModel {
    self.niu_id = niuManModel.niu_id;
    self.aid = niuManModel.aid;
    self.niu_name = niuManModel.niu_name;
    self.niu_pop = niuManModel.niu_pop;
    self.niu_img = niuManModel.niu_img;
    self.niu_introduce = niuManModel.niu_introduce;
}

- (void)setSubscribleModel:(YYNiuSubscribeModel *)subscribleModel {

    self.niu_id = subscribleModel.niu_id;
    self.aid = subscribleModel.aid;
    self.niu_name = subscribleModel.niu_name;
    self.niu_pop = subscribleModel.niu_pop;
    self.niu_img = subscribleModel.niu_head;
    self.niu_introduce = subscribleModel.niu_introduction;
}




@end
