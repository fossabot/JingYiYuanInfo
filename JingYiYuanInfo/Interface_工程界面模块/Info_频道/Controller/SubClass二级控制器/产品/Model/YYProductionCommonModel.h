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
 {
 "id": "1",
 "parenttable": "jijin",
 "com_name": "公司名称",
 "com_pic": "logo",
 "label": "1",
 "part": "股票型",
 "classid": "1",
 "yname": "画龙点睛",
 "ystate": "1",
 "yprice": "1889",
 "introduce": "按时间的"
 }
 parenttable所属公司表名称,com_name公司名称,com_pic公司标题图片,label 1热 2荐 3推,part功能标签,classid所属公司id,yname名称,ystate状态1在售2售罄,yprice价格introduce简介
 */

/** 产品id*/
@property (nonatomic, copy) NSString *productionId;

/** parenttable所属公司 >表< 名称*/
//@property (nonatomic, copy) NSString *parenttable;

/** com_name公司名称*/
@property (nonatomic, copy) NSString *com_name;

/** com_pic公司标题图片*/
@property (nonatomic, copy) NSString *com_pic;

/** label 1热 2荐 3推*/
@property (nonatomic, copy) NSString *label;

/** part功能标签*/
@property (nonatomic, copy) NSString *part;

/** classid所属公司id*/
@property (nonatomic, copy) NSString *classid;

/** yname名称*/
@property (nonatomic, copy) NSString *yname;

/** ystate状态1在售2售罄*/
@property (nonatomic, copy) NSString *ystate;

/** yprice价格*/
@property (nonatomic, copy) NSString *yprice;

/** introduce简介*/
@property (nonatomic, copy) NSString *introduce;

@end
