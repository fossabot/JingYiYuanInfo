//
//  YYMineSettingCellModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMineSettingCellModel : NSObject

/** title*/
@property (nonatomic, copy) NSString *title;

/** subTitle*/
@property (nonatomic, copy) NSString *subTitle;

/** 目标控制器*/
@property (nonatomic, copy) NSString *destinationVc;

/** wifi下播放的按钮数据*/
@property (nonatomic, assign) BOOL canWifiPlay;

/** logOutCell*/
@property (nonatomic, assign) BOOL isLogOut;

/** 退出后  退出cell不能被点击了*/
@property (nonatomic, assign) BOOL canSelect;

@end
