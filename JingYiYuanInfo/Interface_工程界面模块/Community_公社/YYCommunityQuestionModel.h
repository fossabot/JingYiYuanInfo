//
//  YYCommunityQuestionModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCommunityQuestionModel : NSObject

/** 
 
 "wd_arr": [
 {
 "niu_name": "方风雷",
 "niu_img": "http://yyapp.1yuaninfo.com/app/houtai/uploads/image/20170801/fangfenglei.jpg",
 "id": "4",
 "title": "还在等茅台涨到600元？价值派基金经理早卖了",
 "description": "价值蓝筹股近日连续两日回调，贵州茅台(600519,股吧)连续下跌，海康威视(002415,股吧)也开始逐步回调。价值股自去年以来一路高歌猛进，在一年多时间里不断上涨。如今蓝筹股龙头的回调究竟是上涨路上的一段“小歇”还是见顶信号?",
 "picurl": "uploads/image/20170706/1499329116.jpg"
 }
 ]
 "lastid": "3"
 */

/** niu_name*/
@property (nonatomic, copy) NSString *niu_name;

/** niu_img*/
@property (nonatomic, copy) NSString *niu_img;

/** niu_img*/
@property (nonatomic, copy) NSString *niu_img1;

/** articleId*/
@property (nonatomic, copy) NSString *articleId;

/** niu_id*/
@property (nonatomic, copy) NSString *niu_id;

/** title*/
@property (nonatomic, copy) NSString *title;

/** description*/
@property (nonatomic, copy) NSString *desc;

/** descAttributeStr*/
@property (nonatomic, copy) NSAttributedString *descAttributeStr;

/** picurl*/
@property (nonatomic, copy) NSString *picurl;

/** posttime*/
@property (nonatomic, copy) NSString *posttime;


@end
