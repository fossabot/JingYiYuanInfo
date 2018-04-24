//
//  YYProductionCommonModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYProductionCommonModel : NSObject

/**
 "id": "6",    ?????
 "classid": "48",
 "ylogo": "http:\/\/yyapp.1yuaninfo.com\/app\/houtai\/uploads\/image\/20180130\/1517283358.jpg",
 "yname": "名人观点",
 "ystate": "1",
 "yprice": "299",
 "ynum": "10",
 "sellmodel": "1"
 */

/** 产品id*/
@property (nonatomic, copy) NSString *productionId;

/** com_pic公司标题图片*/
@property (nonatomic, copy) NSString *com_pic;

/** label 1热 2荐 3推*/
@property (nonatomic, copy) NSString *label;

/** introduce简介*/
@property (nonatomic, copy) NSString *introduce;

/** yname产品名称*/
@property (nonatomic, copy) NSString *yname;

/** ystate状态1在售2售罄*/
@property (nonatomic, copy) NSString *ystate;

/** iosyprice价格*/
@property (nonatomic, copy) NSString *iosyprice;

/** tip提示语*/
@property (nonatomic, copy) NSString *tip;

/** mobile*/
@property (nonatomic, copy) NSString *mobile;

/** iosproid产品的苹果后台id*/
@property (nonatomic, copy) NSString *iosproid;

@property (nonatomic, copy) NSString *webUrl;

@end
