//
//  YYPushViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushViewModel.h"
#import "NSDate+YYCalculation.h"

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
        dateComponents = [[NSDate preComponent:_preDate] copy];
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
- (void)fetchDataWithDate:(NSString *)date {
    
    [YYHttpNetworkTool GETRequestWithUrlstring:pushListUrl parameters:@{@"data":date} success:^(id response) {
#warning 什么玩应
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
    
}



#pragma -- mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


@end
