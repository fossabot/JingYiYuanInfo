//
//  YYCalendarTopView.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CalendarTopViewSelectedBlock)(NSString *);

@interface YYCalendarTopView : UIView

- (void)refreshTopViewWithDate:(NSDate *)date;

/** 选中日期回调*/
@property (nonatomic, copy) CalendarTopViewSelectedBlock selectedBlock;

@end
