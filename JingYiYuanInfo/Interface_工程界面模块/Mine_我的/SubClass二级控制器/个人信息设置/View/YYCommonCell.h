//
//  YYCommonCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYCommonCellId = @"YYCommonCell";

@interface YYCommonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweentyConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveConstraints;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
