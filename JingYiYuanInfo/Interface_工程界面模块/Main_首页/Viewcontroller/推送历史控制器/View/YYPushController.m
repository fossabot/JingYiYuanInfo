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

@end

@implementation YYPushController
{
    NSString *_selectedDay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"信息推送";
    self.view.backgroundColor = GrayBackGroundColor;
    self.calendarItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(pushToCalendarController:)];
    [self refreshNavigateItem:[NSDate date]];
    self.navigationItem.rightBarButtonItem = self.calendarItem;
    
    [self configSubView];
    _selectedDay = self.today;
    [self loadDataWithDay:_selectedDay];
    
    [kNotificationCenter addObserver:self selector:@selector(receivedNew365Notification:) name:YYReceived365RemoteNotification object:nil];
//    [self loadDataWithDay:@"2017-09-13"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    
    [kNotificationCenter removeObserver:self];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 初始化子控件*/
- (void)configSubView {
    
    [self.view addSubview:self.topView];
    YYWeakSelf
    self.topView.selectedBlock = ^(NSString *date){
        YYStrongSelf
        _selectedDay = date;
        [strongSelf loadDataWithDay:date];
        [strongSelf transitDate:date];
    };
    
    CGFloat height = CGRectGetHeight(self.topView.frame);
    self.pushTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height+3, kSCREENWIDTH, kSCREENHEIGHT-(height+YYTopNaviHeight+3)) style:UITableViewStylePlain];
    self.pushTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.pushTableView.tableFooterView = [[UIView alloc] init];
    self.pushTableView.delegate = self.viewModel;
    self.pushTableView.dataSource = self.viewModel;
    [self.pushTableView registerClass:[YYPushCell class] forCellReuseIdentifier:YYPushCellId];
    self.pushTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = imageNamed(emptyImageName);
    configer.emptyTitle = @"暂无数据";
    configer.emptyTitleColor = UnenableTitleColor;
    configer.emptyTitleFont = SubTitleFont;
    configer.allowScroll = NO;
    configer.emptyViewTapBlock = ^{
        
        [weakSelf loadDataWithDay:_selectedDay];
    };
    [self.pushTableView emptyViewConfiger:configer];
    
    [self.view addSubview:self.pushTableView];
}


/** 接收到新的消息后得到通知*/
- (void)receivedNew365Notification:(NSNotification *)notice {
    
    if (self.today != _selectedDay) {
        [self.topView refreshTopViewWithDate:[NSDate date]];
    }
    [self loadDataWithDay:self.today];
}

#pragma mark -- network   数据请求方法  ---------------------------

/** 根据当前传递的日期，加载相应的推送历史记录*/
- (void)loadDataWithDay:(NSString *)day {
    
//    _today = day;
    YYWeakSelf
    [self.viewModel fetchDataWithDate:day completion:^(BOOL success) {
        
        if (success) {
            
            [weakSelf.pushTableView reloadData];
        }
    }];
}



#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 根据date的月份来刷新右耳目的月份图片*/
- (void)refreshNavigateItem:(NSDate *)date {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:date];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"month%ld_33x33",dateComponents.month]];
    [self.calendarItem setImage:image];
}

/** 转换日期格式*/
- (void)transitDate:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = yyyyMMdd;
    NSDate *theDate = [formatter dateFromString:date];
    [self refreshNavigateItem:theDate];
}

/** 跳转日历界面，选择日期回调，刷新topview数据*/
- (void)pushToCalendarController:(UIBarButtonItem *)calendarItem {
    
//    [self loadDataWithDay:@"2018-04-12"];
//    [self loadDataWithDay:self.today];
    YYCalendarController *calendarController = [[YYCalendarController alloc] init];
    YYWeakSelf
    calendarController.selectDateBlock = ^(NSString *date, NSDate *topDate) {

        [weakSelf loadDataWithDay:date];
        [weakSelf.topView refreshTopViewWithDate:topDate];
        [weakSelf refreshNavigateItem:topDate];
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
        if (_today) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = yyyyMMddHHmmss;
            [_topView refreshTopViewWithDate:[dateFormatter dateFromString:self.todate]];
        }else {
            [_topView refreshTopViewWithDate:[NSDate date]];
        }
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



@end
