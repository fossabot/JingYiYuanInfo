//
//  YYProductionVIPModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYProductionVIPModel : NSObject

/** 
 "vip": {
 "id": "1",
 "titleimg": "http://yyapp.1yuaninfo.com/app/application/img/vvvip.jpg",
 "title": "365会员",
 "expense": "365",
 "sellstate": "1",
 "iosproid": "com.yyapp_vip_1",
 "iosyprice": "388"
 }, */

/** id*/
@property (nonatomic, copy) NSString *vipId;

/** title*/
@property (nonatomic, copy) NSString *title;

/** titleimg*/
@property (nonatomic, copy) NSString *titleimg;

/** 价格*/
@property (nonatomic, copy) NSString *expense;

/** 销售状态*/
@property (nonatomic, copy) NSString *sellstate;

/** ios产品的苹果后台的id */
@property (nonatomic, copy) NSString *iosproid;

/** ios的售价*/
@property (nonatomic, copy) NSString *iosyprice;

@end
