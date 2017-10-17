//
//  YYCalendarController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCalendarController.h"
#import "NSDate+YYCalculation.h"
#import <FSCalendar/FSCalendar.h>
#import <EventKit/EventKit.h>

@interface YYCalendarController ()<FSCalendarDataSource, FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property(strong, nonatomic) NSCalendar *gregorianCalendar;

@property (strong, nonatomic) NSCalendar *chineseCalendar;

@property (strong, nonatomic) NSArray<NSString *> *lunarChars;

@property (strong, nonatomic) NSArray<EKEvent *> *events;

@end

@implementation YYCalendarController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:self.view.bounds];
    calendar.appearance.headerTitleColor = ThemeColor;
    calendar.appearance.weekdayTextColor = ThemeColor;
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:calendar];
    self.calendar = calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *selectDate = [dateFormatter stringFromDate:date];
    if (_selectDateBlock) {
        
        _selectDateBlock(selectDate,date);
    }
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    
    if ([self.gregorianCalendar isDateInToday:date]) {
        return ThemeColor;
    }
    return nil;
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    
    if ([self.gregorianCalendar isDateInToday:date]) {
        return ThemeColor;
    }
    return OrangeColor;
}


- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorianCalendar isDateInToday:date]) {
        return @"今天";
    }
    return nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    
    if ([self.gregorianCalendar isDateInToday:date]) {
        return nil;
    }
    
    EKEvent *event = [self eventsForDate:date].firstObject;
    if (event) {
        return event.title; // 春分、秋分、儿童节、植树节、国庆节、圣诞节...
    }
    
    NSInteger lunarDay = [self.chineseCalendar component:NSCalendarUnitDay fromDate:date];
    NSString *lunarDayString = self.lunarChars[lunarDay-1];
    return lunarDayString;// 初一、初二、初三...
    
}

// 某个日期的所有事件
- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    return filteredEvents;
}


- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    
    return [NSDate date];
    
}

- (NSDate *)fiveDateAfter {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *fiveDay = nil;
    for (int i=0; i<5; i++) {
        
        NSDateComponents *dateComponents = [NSDate nextComponent:[NSDate date]];
        fiveDay = [calendar dateFromComponents:dateComponents];
    }
    return fiveDay;
}

@end
