//
//  YYCalendarCollectionCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const CalendarCollectionCellID = @"CalendarCollectionCell";

@interface YYCalendarCollectionCell : UICollectionViewCell

///周一到周日
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;

///日期 
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@end
