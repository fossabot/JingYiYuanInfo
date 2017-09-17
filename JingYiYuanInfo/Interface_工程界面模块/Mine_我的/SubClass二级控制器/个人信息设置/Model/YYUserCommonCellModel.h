//
//  YYUserCommonCellModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  个人中心每个cell的数据model

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, YYUserInfoCellType) {
    
    YYUserInfoCellTypeIcon = 0,
    YYUserInfoCellTypeCommon = 1,
    YYUserInfoCellTypeTel = 2,
    YYUserInfoCellTypeBundle = 3
};

@interface YYUserCommonCellModel : NSObject

/** title*/
@property (nonatomic, copy) NSString *title;

/** icon*/
@property (nonatomic, copy) NSString *icon;

/** subTitle*/
@property (nonatomic, copy) NSString *subTitle;

/** isHaveIndicator*/
@property (nonatomic, assign) BOOL isHaveIndicator;

/** isBundleSDK*/
@property (nonatomic, assign) BOOL isBundleSDK;

/** cellHeight*/
@property (nonatomic, assign) CGFloat cellHeight;

/** YYUserInfoCellType*/
@property (nonatomic, assign) YYUserInfoCellType userInfoCellType;


@end
