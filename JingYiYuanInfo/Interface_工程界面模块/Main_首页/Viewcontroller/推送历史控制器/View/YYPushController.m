//
//  YYPushViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  通知的列表界面

#import "YYPushController.h"
#import "YYPushViewModel.h"
#import "YYCalendarTopView.h"
#import "YYPushCell.h"
#import "YYCalendarController.h"


@interface YYPushController ()

/** calendarItem*/
@property (nonatomic, strong) UIBarButtonItem *calendarItem;

/** pushTableView*/
@property (nonatomic, strong) UITableView *pushTableView;

/** topView*/
@property (nonatomic, strong) YYCalendarTopView *topView;

/** viewModel*/
@property (nonatomic, strong) YYPushViewModel *viewModel;

/** today*/
@property (nonatomic, copy) NSString *today;

@end

@implementation YYPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"信息推送";
    self.view.backgroundColor = GrayBackGroundColor;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"month%ld_33x33",[self currentMonth]]];
    self.calendarItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(pushToCalendarController:)];
    self.navigationItem.rightBarButtonItem = self.calendarItem;
    
    [self configSubView];
    
    [self loadDataWithDay:self.today];
    
//    [self loadDataWithDay:@"2017-09-13"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 初始化子控件*/
- (void)configSubView {
    
    [self.view addSubview:self.topView];
    YYWeakSelf
    self.topView.selectedBlock = ^(NSString *date){
        YYStrongSelf
        
        [strongSelf loadDataWithDay:date];
//        [strongSelf.viewModel fetchDataWithDate:date completion:^(BOOL success) {
//            
//            if (success) {
//                [strongSelf.pushTableView reloadData];
//            }
//        }];
    };
    
    
    self.pushTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight+5, kSCREENWIDTH, kSCREENHEIGHT-(YYTopNaviHeight+YYTopNaviHeight+5)) style:UITableViewStylePlain];
//    self.pushTableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    self.pushTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.pushTableView.tableFooterView = [[UIView alloc] init];
    self.pushTableView.delegate = self.viewModel;
    self.pushTableView.dataSource = self.viewModel;
    [self.pushTableView registerClass:[YYPushCell class] forCellReuseIdentifier:YYPushCellId];
    self.pushTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = imageNamed(emptyImageName);
    configer.emptyTitle = @"暂无数据,点此重新加载";
    configer.emptyTitleColor = UnenableTitleColor;
    configer.emptyTitleFont = SubTitleFont;
    configer.allowScroll = NO;
    configer.emptyViewTapBlock = ^{
        
        [weakSelf loadDataWithDay:weakSelf.today];
    };
    [self.pushTableView emptyViewConfiger:configer];
    
    [self.view addSubview:self.pushTableView];
}


#pragma mark -- network   数据请求方法  ---------------------------

/** 根据当前传递的日期，加载相应的推送历史记录*/
- (void)loadDataWithDay:(NSString *)day {
    
    _today = day;
    YYWeakSelf
    [self.viewModel fetchDataWithDate:day completion:^(BOOL success) {
        
        if (success) {
            
            [weakSelf.pushTableView reloadData];
        }
    }];
}



#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 跳转日历界面，选择日期回调，刷新topview数据*/
- (void)pushToCalendarController:(UIBarButtonItem *)calendarItem {
    
    YYCalendarController *calendarController = [[YYCalendarController alloc] init];
    YYWeakSelf
    calendarController.selectDateBlock = ^(NSString *date, NSDate *topDate) {
      
        [weakSelf loadDataWithDay:date];
        [weakSelf.topView refreshTopViewWithDate:topDate];
    };
    [self.navigationController pushViewController:calendarController animated:YES];
}

/** 获取现在的月份*/
- (NSInteger)currentMonth {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:now];
    return dateComponents.month;
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (YYCalendarTopView *)topView{
    if (!_topView) {
        _topView = [[YYCalendarTopView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight, kSCREENWIDTH, 70)];
        [_topView refreshTopViewWithDate:[NSDate date]];
        
    }
    return _topView;
}

- (YYPushViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYPushViewModel alloc] init];
        
    }
    return _viewModel;
}


- (NSString *)today{
    if (!_today) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *now = [NSDate date];
        _today = [dateFormatter stringFromDate:now];
    }
    return _today;
}


- (void)dealloc {
    YYLogFunc
}


@end
