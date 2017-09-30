//
//  YYSubscribleSettingCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchBlock)(id cell, BOOL isOn);

static NSString *const YYSubscribleSettingCellId = @"YYSubscribleSettingCell";

@interface YYSubscribleSettingCell : UITableViewCell

/** switchBlock*/
@property (nonatomic, copy) SwitchBlock switchBlock;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** subTitle*/
@property (nonatomic, strong) UILabel *subTitle;

/** switchBtn*/
@property (nonatomic, strong) UISwitch *switchBtn;


@end
