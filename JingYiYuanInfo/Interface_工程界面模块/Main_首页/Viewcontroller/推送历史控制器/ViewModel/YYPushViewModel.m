//
//  YYPushViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushViewModel.h"
#import "NSDate+YYCalculation.h"
#import "YYPushCell.h"
#import "YYPushListCellModel.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <MJExtension/MJExtension.h>

@interface YYPushViewModel()

/** dataSource*/
@property (nonatomic, strong)  NSMutableArray *dataSource;

@end

@implementation YYPushViewModel
{
    NSDate *_preDate;
    NSDate *_nextDate;
    
    NSDateComponents *_dateComponents;
}
/** 传给ViewModel一个日期，返回相应的15个日期数据源*/
- (NSMutableArray *)oldNineDaysAndLastFiveDaysAccordingDate:(NSDate *)date {
    
    _preDate = date;
    _nextDate = date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
//    NSDateComponents *dateComponent = nil;
    NSMutableArray *componentsArr = [NSMutableArray arrayWithObject:components];
    for (int i = 0; i<9; i++) {//前边的9天
        NSDateComponents *dateComponents = nil;
        dateComponents = [NSDate preComponent:_preDate];
        _preDate = [calendar dateFromComponents:dateComponents];
        [componentsArr insertObject:dateComponents atIndex:0];
    }
    for (int i = 0; i<5; i++) {//后边的5天
        NSDateComponents *dateComponents = nil;
        dateComponents = [NSDate nextComponent:_nextDate];
        _nextDate = [calendar dateFromComponents:dateComponents];
        [componentsArr addObject:dateComponents];
    }
    
    return componentsArr;
}

/** 推送历史列表请求方法*/
- (void)fetchDataWithDate:(NSString *)date completion:(void(^)(BOOL success))completion{
    
    [YYHttpNetworkTool GETRequestWithUrlstring:pushListUrl parameters:@{@"date":date} success:^(id response) {

        if (response) {
            
            self.dataSource = [YYPushListCellModel mj_objectArrayWithKeyValuesArray:response[@"msglist_arr"]];
            completion(YES);
        }else {
            completion (NO);
        }
        
    } failure:^(NSError *error) {
        completion(NO);
    } showSuccessMsg:nil];
    
}

#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYPushListCellModel *model = self.dataSource[indexPath.row];
//    if (model.extendState) {
//        
//        CGFloat height = [tableView fd_heightForCellWithIdentifier:YYPushCellId cacheByIndexPath:indexPath configuration:^(YYPushCell *cell) {
//            
//            cell.pushModel = model;
//        }];
//        return height;
//    }else if(!model.extendState && !model.isHaveExtendBtn){
//        
//        CGFloat height = [tableView fd_heightForCellWithIdentifier:YYPushCellId cacheByIndexPath:indexPath configuration:^(YYPushCell *cell) {
//            
//            cell.pushModel = model;
//        }];
//        return height;
//    }else {
//        
//        return 90;
//    }
    
    return [model cellHeight];
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYPushCell * cell = [tableView dequeueReusableCellWithIdentifier:YYPushCellId];
    __block YYPushListCellModel *model = self.dataSource[indexPath.row];
    cell.pushModel = model;
    __weak typeof(tableView) weakTableView = tableView;
    cell.extendBlock = ^(id cell, BOOL selected) {
      
        NSIndexPath *index = [weakTableView indexPathForCell:cell];
//        model.extendState = selected;
        [weakTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
