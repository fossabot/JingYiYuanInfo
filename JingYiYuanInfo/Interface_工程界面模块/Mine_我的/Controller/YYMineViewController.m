//
//  YYMineViewController.m
//  
//
//  Created by VINCENT on 2017/4/24.
//
//

#import "YYMineViewController.h"

#import "YYMineHeaderView.h"
#import "YYMineLogOutHeaderView.h"

#import "YYMineViewModel.h"
#import "YYUser.h"


@interface YYMineViewController ()<YYHeaderViewDestinationDelegate>

/** headerView*/
@property (nonatomic,strong) YYMineHeaderView *headView;

/** logout headerview*/
@property (nonatomic, strong) YYMineLogOutHeaderView *logOutHeaderView;

/** tableview*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYMineViewModel *viewModel;

@end

@implementation YYMineViewController


#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self addNotice];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    //配置tableview的头部视图
    [self configureHeaderView:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    YYLogFunc
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 注册通知*/
- (void)addNotice {
    [kNotificationCenter addObserver:self selector:@selector(configureHeaderView:) name:YYUserInfoDidChangedNotification object:nil];
}


/** 配置tableview的头部视图 根据loginstatus判断加载哪个头部*/
- (void)configureHeaderView:(NSNotification *)notice {
    YYUser *user = [YYUser shareUser];
    BOOL loginStatus = user.isLogin;
    if (notice && [notice.userInfo[LASTLOGINSTATUS] isEqualToString:@"0"] && loginStatus) {
        //登录成功,是登录操作发来的通知，换个人信息头部
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.headView;
        [self.headView setUser:user];
    }else if (notice && [notice.userInfo[LASTLOGINSTATUS] isEqualToString:@"1" ] && !loginStatus) {
        //退出成功,是退出操作发来的通知，换无信息头部
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.logOutHeaderView;
    }else if (notice && [notice.userInfo[LASTLOGINSTATUS] isEqualToString:@"1" ] && loginStatus){
        //过去是登录，现在还是登录，说明只是简单的修改个人信息
        [self.headView setUser:user];
    }else if (loginStatus && !notice){
        //如果是没有通知，并且是登录状态，说明只是初始化登录过的MineVC而已
        if (!_headView) {
            self.tableView.tableHeaderView = nil;
            self.tableView.tableHeaderView = self.headView;
        }
        [self.headView setUser:user];
    }else if (!loginStatus && !notice) {
        //如果是退出状态，并且没有通知，说明只是初始化未登录的MineVC而已
        if (!_logOutHeaderView) {
            self.tableView.tableHeaderView = nil;
            self.tableView.tableHeaderView = self.logOutHeaderView;
        }
    }
    
}

#pragma mark -- headerview的代理
/** HeaderView各个控件跳转的目标控制器*/
- (void)destinationController:(UIViewController *)viewController {
//    [self.rt_navigationController pushViewController:viewController animated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}




#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYMineHeaderView *)headView{
    if (!_headView) {
        _headView = [YYMineHeaderView headerView];
        _headView.frame = CGRectMake(0, 0, kSCREENWIDTH, 180);
        _headView.delegate = self;
    }
    return _headView;
}

- (YYMineLogOutHeaderView *)logOutHeaderView{
    if (!_logOutHeaderView) {
        _logOutHeaderView = [YYMineLogOutHeaderView headerView];
        _logOutHeaderView.frame = CGRectMake(0, 0, kSCREENWIDTH, 150);
    }
    return _logOutHeaderView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
    }
    return _tableView;
}


- (YYMineViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYMineViewModel alloc] init];
        YYWeakSelf
        _viewModel.cellSelecteBlock = ^(NSIndexPath *indexPath, NSString *vc, UIAlertController *alert) {
            YYStrongSelf
            if (alert) {
                
                [kKeyWindow.rootViewController  presentViewController:alert animated:YES completion:^{
                    YYLog(@"presentViewController:alert");
//                    [strongSelf.navigationController setNavigationBarHidden:YES animated:NO];
                }];
//                [strongSelf presentViewController:alert animated:YES completion:^{
//                    YYLog(@"presentViewController:alert");
//                    [strongSelf.navigationController setNavigationBarHidden:YES animated:NO];
//                }];
            }else {
                UIViewController *viewController = [[NSClassFromString(vc) alloc] init];
                viewController.jz_wantsNavigationBarVisible = YES;
                [strongSelf.navigationController pushViewController:viewController animated:YES];
            }
        };
    }
    return _viewModel;
}

@end
