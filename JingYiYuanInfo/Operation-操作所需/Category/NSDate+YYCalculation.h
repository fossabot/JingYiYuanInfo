//
//  NSDate+YYCalculation.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YYCalculation)

/** 是否是明天*/
+ (BOOL)isTomorrow:(NSDateComponents *)componets;

/** 是否是昨天*/
+ (BOOL)isYesterday:(NSDateComponents *)componets;

/** 是否是今天*/
+ (BOOL)isToday:(NSDateComponents *)componets;

/** 是否是未来*/
+ (BOOL)isFuture:(NSDateComponents *)componets;

/** 两个日期是否相等*/
- (BOOL)isEqualToComponents:(NSDateComponents *)componets;

/** 昨天*/
+ (NSDateComponents *)preComponent:(NSDate *)date;

/** 明天*/
+ (NSDateComponents *)nextComponent:(NSDate *)date;



@end
