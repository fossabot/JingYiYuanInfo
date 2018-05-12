//
//  YYSubscribleSettingController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSubscribleSettingController.h"
#import "YYSubscribleSettingCell.h"

#define settingUrl @"http://yyapp.1yuaninfo.com/app/application/setmsg.php"

@interface YYSubscribleSettingController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** stables*/
@property (nonatomic, strong) NSMutableArray *stables;


@end

@implementation YYSubscribleSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订阅设置";
    
//    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
//    save.enabled = NO;
//    self.navigationItem.rightBarButtonItem = save;
//http://yyapp.1yuaninfo.com/app/application/setmsg.php?act=dayservice&userid=USERID  获取订阅设置
    
//http://yyapp.1yuaninfo.com/app/application/setmsg.php?act=moddayservice&dayservice=0,1,1,1,1,1,1,1&userid=USERID   保存

    [self configSubView];
    
    [self loadData];
}


- (void)configSubView {
    
    [self.view addSubview:self.tableView];
    YYWeakSelf
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self addTableFooterView];
    
}

/** 给tableview加footer*/
- (void)addTableFooterView {
    
    CGFloat height = 100;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, height)];
    bottomView.backgroundColor = ClearColor;
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(YYCommonCellLeftMargin, 0, kSCREENWIDTH-YYCommonCellLeftMargin-YYCommonCellRightMargin, height)];
    tip.numberOfLines = 0;
    tip.backgroundColor = ClearColor;
    tip.text = @"免责声明：以上产品文章内容和数据仅供参考，不构成投资建议。投资者据此做出的任何投资决策与壹元服务无关。";
    tip.font = SubTitleFont;
    tip.textColor = UnenableTitleColor;
    [bottomView addSubview:tip];
    self.tableView.tableFooterView = bottomView;
}

- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    self.dataSource = [NSMutableArray array];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"dayservice",@"act",user.userid,USERID,nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:settingUrl parameters:para success:^(id response) {
        if (response) {
            weakSelf.dataSource = response[@"dayservice"];
            [weakSelf.tableView reloadData];
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}


- (void)save {
    
    YYUser *user = [YYUser shareUser];
    NSString *servieceStr = [self.dataSource componentsJoinedByString:@","];
    while ([servieceStr hasSuffix:@","]) {
        servieceStr = [servieceStr substringToIndex:servieceStr.length-2];
    }
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"moddayservice",@"act",servieceStr,@"dayservice",user.userid,USERID,nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:settingUrl parameters:para success:^(id response) {
        
        if (response && [response[STATUS] isEqualToString:@"0"]) {
            
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }
        [SVProgressHUD dismissWithDelay:1];
        
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];

}



#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYSubscribleSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:YYSubscribleSettingCellId];
    
    NSDictionary *dic = self.stables[indexPath.row];
//    NSNumber *on = self.dataSource[indexPath.row];
    cell.title.text = dic[@"title"];
    cell.subTitle.text = dic[@"subTitle"];
//    cell.switchBtn.on = [on integerValue];
    cell.switchBtn.on = NO;
    YYWeakSelf
    cell.switchBlock = ^(id cell, BOOL isOn) {
        
        NSIndexPath *index = [weakSelf.tableView indexPathForCell:cell];
        NSNumber *switchStatus = isOn ? @1 : @0;
        NSMutableArray *arr = [weakSelf.dataSource mutableCopy];
        [arr replaceObjectAtIndex:index.row withObject:switchStatus];
        weakSelf.dataSource = arr;
//        [weakSelf.dataSource replaceObjectAtIndex:index.row withObject:switchStatus];
        
    };
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, YYCommonCellLeftMargin, 0, YYCommonCellRightMargin);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 75;
        [_tableView registerClass:[YYSubscribleSettingCell class] forCellReuseIdentifier:YYSubscribleSettingCellId];
        _tableView.backgroundColor = GrayBackGroundColor;
        YYWeakSelf
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.tableFooterView = nil;
        };
        configer.emptyViewDidDisappear = ^{
            [weakSelf addTableFooterView];
        };
        configer.emptyViewTapBlock = ^{
            [weakSelf loadData];
        };
        [self.tableView emptyViewConfiger:configer];
    }
    return _tableView;
}


- (NSMutableArray *)stables{
    if (!_stables) {
        _stables = [NSMutableArray array];
        [_stables addObject:@{@"title":@"早餐",@"subTitle":@"传播正能量，精彩每一天"}];
        [_stables addObject:@{@"title":@"早评",@"subTitle":@"夜间消息，对盘前的d点评"}];
        [_stables addObject:@{@"title":@"上午分享",@"subTitle":@"盘中适时个股分享"}];
        [_stables addObject:@{@"title":@"午评",@"subTitle":@"上午市场点评，下午市场预判"}];
        [_stables addObject:@{@"title":@"下午分享",@"subTitle":@"盘中适时个股分享"}];
        [_stables addObject:@{@"title":@"收评",@"subTitle":@"下午市场点评，次日市场预判"}];
        [_stables addObject:@{@"title":@"夜宵",@"subTitle":@"总结今天，展望明天"}];
        [_stables addObject:@{@"title":@"即时通知",@"subTitle":@"操作提示"}];
    }
    return _stables;
}


@end
