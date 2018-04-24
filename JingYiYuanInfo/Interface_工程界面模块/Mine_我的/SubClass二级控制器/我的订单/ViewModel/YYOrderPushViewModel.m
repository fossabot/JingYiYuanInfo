//
//  YYOrderPushViewModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/31.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYOrderPushViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "YYUser.h"
#import "YYOrderPushModel.h"
#import "YYOrderPushListCell.h"

@interface YYOrderPushViewModel ()<UITableViewDelegate,UITableViewDataSource>

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYOrderPushViewModel
{
    NSInteger _page;
}

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

/** 加载新数据*/
- (void)fetchNewDataCompletion:(void (^)(BOOL))completion {
   
    _page = 1;
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@(_page),@"page",self.orderid,@"orderid", nil];

//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"1507619127fb9qai",USERID,@(_page),@"page",@"18",@"orderid", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:orderListUrl parameters:para success:^(id response) {
        
        NSMutableArray *arr = [YYOrderPushModel mj_objectArrayWithKeyValuesArray:response[@"usarr"]];
        
        if (arr.count) {
            self.dataSource = arr;
            completion(YES);
        }else {
            completion(NO);
        }
    } failure:^(NSError *error) {
        completion(NO);
    } showSuccessMsg:nil];
    
}

- (void)fetchMoreDataCompletion:(void (^)(BOOL))completion {
    
    _page += 1;
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@(_page),@"page",self.orderid,@"orderid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:orderListUrl parameters:para success:^(id response) {
        
        NSMutableArray *arr = [YYOrderPushModel mj_objectArrayWithKeyValuesArray:response[@"usarr"]];
        
        if (arr.count) {
            [self.dataSource addObjectsFromArray:arr];
            completion(YES);
        }else {
            _page -= 1;
            completion(NO);
        }
    } failure:^(NSError *error) {
        _page -= 1;
        completion(NO);
    } showSuccessMsg:nil];
}



#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.mj_footer.hidden = (self.dataSource.count%10 != 0) || self.dataSource.count == 0;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 135;
}


#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYOrderPushListCell * cell = [tableView dequeueReusableCellWithIdentifier:YYOrderPushListCellId];
    YYOrderPushModel *model = self.dataSource[indexPath.row];
    cell.serviceTimeLabel.text = model.addtime;
    cell.codeNameLabel.text = model.gpdm;
    cell.stateLabel.text = model.isgain;
    cell.yanbaoUrl = model.yanbao;
    
    YYWeakSelf
    __weak typeof(model) weakModel = model;
    cell.yanbaoBlock = ^{
        
        [weakSelf checkYanbao:weakModel.yanbao];
    };
    return cell;
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)checkYanbao:(NSString *)yanbaoUrl {
    
    if (_yanbaoBlock) {
        _yanbaoBlock(yanbaoUrl);
    }
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
