//
//  NSDate+YYCalculation.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "NSDate+YYCalculation.h"

@implementation NSDate (YYCalculation)

/** 是否是明天*/
+ (BOOL)isTomorrow:(NSDateComponents *)componets {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:componets];
    return [calendar isDateInTomorrow:date];

}

/** 是否是昨天*/
+ (BOOL)isYesterday:(NSDateComponents *)componets {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:componets];
    return [calendar isDateInYesterday:date];
    
}

/** 是否是今天*/
+ (BOOL)isToday:(NSDateComponents *)componets {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:componets];
    return [calendar isDateInToday:date];
    
}

/** 是否是未来*/
+ (BOOL)isFuture:(NSDateComponents *)componets {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *date = [calendar dateFromComponents:componets];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([dateStr integerValue] > [now integerValue]) {
        //是未来
        return YES;
    }else {
        return NO;
    }
    
}


/** 两个日期是否相等*/
- (BOOL)isEqualToComponents:(NSDateComponents *)componets {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [calendar dateFromComponents:componets];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSString *varA = [dateFormatter stringFromDate:self];
    NSString *varB = [dateFormatter stringFromDate:date];
    
    BOOL equal = [varA isEqualToString:varB];
    return equal;
    
}

/** 昨天*/
+ (NSDateComponents *)preComponent:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    if (components.day == 1) {
        if (components.month == 1) {
            components.month = 12;
        }else{
            components.month -= 1;
        }
        NSDate *yesterday = [calendar dateFromComponents:components];
        NSInteger totalPreMonthDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:yesterday].length;
        components.day = totalPreMonthDays;
    }
    
    return components;
}

/** 明天*/
+ (NSDateComponents *)nextComponent:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    if ([self isLastDayOnMonthOfDate:date]) {
        if ([self isLastMonthInThisYearOfDate:date]) {
            components.month = 1;
        }else{
            components.month += 1;
        }
        components.day = 1;
    }else {
        components.day += 1;
    }
    
    return components;
}


/** 是否是最后一天*/
+ (BOOL)isLastDayOnMonthOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger totalMonthDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    if (totalMonthDays == components.day) {
        return YES;
    }else {
        return NO;
    }
}


/** 是否是这年的最后一月*/
+ (BOOL)isLastMonthInThisYearOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger totalMonths = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date].length;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    if (totalMonths == components.month) {
        return YES;
    }else {
        return NO;
    }
}


@end
