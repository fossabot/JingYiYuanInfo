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
 "id": "365会员",
 "title": "365会员",
 "expense": "365",
 "sellstate": "0"
 },
 */

/** id*/
@property (nonatomic, copy) NSString *vipId;

/** title*/
@property (nonatomic, copy) NSString *title;

/** 价格*/
@property (nonatomic, copy) NSString *expense;

/** 销售状态*/
@property (nonatomic, copy) NSString *sellstate;

@end
