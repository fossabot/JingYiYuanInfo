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
    NSIndexPath *_lastIndexPath;
    NSString *_lastSelectedDate;
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
    
    if (_lastSelectedDate && ![_lastSelectedDate isEqualToString:date]) {
        [self resetLastIndexPath];
    }
    _lastSelectedDate = date;
    
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

/** 当日期改变时，如果已经点击了展开与关闭的按钮，那么当前VM会记住lastIndexPath，但是切换日期后，加入新的数据源数据没有上一个日期的数据源多，正巧lastindexpath记住的又是上一个日期超过这个日期数据源个数之外的，也就意味着，在点击新的cell时，同时将lastindexpath的cell收起，就会找不到那个cell，数组越界，所以切换日期后需将lastIndexPath置为nil*/
- (void)resetLastIndexPath {
    _lastIndexPath = nil;
}

#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYPushListCellModel *model = self.dataSource[indexPath.row];
    return [model cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYPushCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell extened];
    
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYPushCell * cell = [tableView dequeueReusableCellWithIdentifier:YYPushCellId];
    __block YYPushListCellModel *model = self.dataSource[indexPath.row];
    cell.pushModel = model;
    __weak typeof(tableView) weakTableView = tableView;
    YYWeakSelf
    cell.extendBlock = ^(id cell, BOOL selected) {
        
        NSArray *arr;
        NSIndexPath *index = [weakTableView indexPathForCell:cell];
        if (_lastIndexPath && _lastIndexPath != index) {
            
            YYPushListCellModel *lastModel = weakSelf.dataSource[_lastIndexPath.row];
            lastModel.extendState = NO;
            [weakSelf.dataSource replaceObjectAtIndex:_lastIndexPath.row withObject:lastModel];
            arr = [NSArray arrayWithObjects:_lastIndexPath,index, nil];
        }else {
            arr = [NSArray arrayWithObject:index];
        }
        [weakTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        _lastIndexPath = index;
    };
    
    cell.yanBaoBlock = ^(NSString *yanBaoUrl) {
      
        if (weakSelf.yanBaoBlock) {
            weakSelf.yanBaoBlock(yanBaoUrl);
        }
    };
    
    //  隐藏每个分区最后一个cell的分割线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 1.系统分割线,移到屏幕外
        //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        
        // 2.自定义Cell
        cell.bottomRedLine.hidden = YES;
    }else {
        //cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0)
        cell.bottomRedLine.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        cell.topRedLine.hidden = YES;
    }else {
        cell.topRedLine.hidden = NO;
    }
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
