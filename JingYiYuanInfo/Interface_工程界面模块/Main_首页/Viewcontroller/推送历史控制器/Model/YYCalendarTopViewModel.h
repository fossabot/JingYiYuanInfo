//
//  YYCalendarTopViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCalendarTopViewModel : NSObject

/** 年月日2017-08-08*/
@property (nonatomic, copy) NSString *date;  

/** 周几*/
@property (nonatomic, copy) NSString *weekDay;

/** 日期*/
@property (nonatomic, copy) NSString *dateStr;

/** 今天之后不能点击*/
@property (nonatomic, assign) BOOL isFuture;

/** 是否选中按钮*/
@property (nonatomic, assign) BOOL isSelected;

@end

