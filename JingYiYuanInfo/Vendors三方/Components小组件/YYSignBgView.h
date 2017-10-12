//
//  YYSignBgView.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat signW = 100;
static CGFloat signH = 55;

/// 宽高比 100:55
@interface YYSignBgView : UIControl

/** 签到天数 设置0为未签到状态  设置不是0则显示签到天数*/
@property (nonatomic, copy) NSString *signDays;

/** 签到状态NO未签到  YES已签到 设置签到按钮的签到天数 签到状态自动变化，设置签到天数@“0”时 表示未签到isSigned=NO  其他则为已签到 isSigned=YES*/
@property (nonatomic, assign, readonly, getter=isSigned) BOOL sign;

@end
