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
#import "YYCalendarController.h"


@interface YYPushController ()<UITableViewDataSource,UITableViewDelegate>

/** calendarItem*/
@property (nonatomic, strong) UIBarButtonItem *calendarItem;

/** collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** pushTableView*/
@property (nonatomic, strong) UITableView *pushTableView;

/** topView*/
@property (nonatomic, strong) YYCalendarTopView *topView;

/** viewModel*/
@property (nonatomic, strong) YYPushViewModel *viewModel;

@end

@implementation YYPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推送消息";
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"month%ld_33x33",[self currentMonth]]];
    self.calendarItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(pushToCalendarController:)];
    self.navigationItem.rightBarButtonItem = self.calendarItem;
    
    [self configSubView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 初始化子控件*/
- (void)configSubView {
    
    
    [self.view addSubview:self.topView];
    YYWeakSelf
    self.topView.selectedBlock = ^(NSString *date){
        YYStrongSelf
        [strongSelf.viewModel fetchDataWithDate:date];
//        [strongSelf.pushTableView reloadData];
    };
    
    self.pushTableView = [[UITableView alloc] init];
    self.pushTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight+TabHeaderH+5, kSCREENWIDTH, kSCREENHEIGHT-(YYTopNaviHeight+TabHeaderH+5)) style:UITableViewStylePlain];
    self.pushTableView.delegate = self;
    self.pushTableView.dataSource = self;
    self.pushTableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.pushTableView];
}

/** 跳转日历界面，选择日期回调，刷新topview数据*/
- (void)pushToCalendarController:(UIBarButtonItem *)calendarItem {
    
    
    
}

/** 获取现在的月份*/
- (NSInteger)currentMonth {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth fromDate:now];
    return dateComponents.month;
}



#pragma -- mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld行",indexPath.row];
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------



- (YYCalendarTopView *)topView{
    if (!_topView) {
        _topView = [[YYCalendarTopView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight, kSCREENWIDTH, 60)];
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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight+TabHeaderH+5, kSCREENWIDTH, kSCREENHEIGHT - (YYTopNaviHeight+TabHeaderH+5)) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor cyanColor];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(40, 40);
    }
    return _flowLayout;
}
- (void)dealloc {
    YYLogFunc
}


@end
