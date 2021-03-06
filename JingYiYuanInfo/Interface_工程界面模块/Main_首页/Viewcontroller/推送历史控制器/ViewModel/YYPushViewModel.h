//
//  YYPushViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YanBaoModelBlock)(NSString *yanBaoUrl);
typedef void(^CellSelectBlock)(id cell, NSIndexPath *indexPath);

@interface YYPushViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/** 传给ViewModel一个日期，返回相应的15个日期数据源*/
- (NSMutableArray *)oldNineDaysAndLastFiveDaysAccordingDate:(NSDate *)date;

/** 推送历史列表请求方法*/
- (void)fetchDataWithDate:(NSString *)date completion:(void(^)(BOOL success))completion;

/** yan*/
@property (nonatomic, copy) YanBaoModelBlock yanBaoBlock;

@end
