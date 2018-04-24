//
//  YYNiuManModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人榜的牛人模型

#import <Foundation/Foundation.h>

@interface YYNiuManModel : NSObject

/** 
 "id": "1",
 "niu_name": "胡说",
 "niu_introduce": " 小胡说的是八戒也不知道",
 "niu_tag": "小虎 八戒",
 "niu_img": "http://yyapp.1yuaninfo.com/uploads/image/20170801/niuren1.jpg",
 "niu_pop": "112",
 "niu_modtime": "11133111",
 "niu_follow": "1231",
 "niu_type": "0"
 */

/** 牛人id*/
@property (nonatomic, copy) NSString *niu_id;

/** 请求文章时候用这个aid*/
@property (nonatomic, copy) NSString *aid;

/** 牛人名称*/
@property (nonatomic, copy) NSString *niu_name;

/** 牛人介绍*/
@property (nonatomic, copy) NSString *niu_introduce;

/** 牛人定位*/
@property (nonatomic, copy) NSString *niu_tag;

/** 牛人图片*/
@property (nonatomic, copy) NSString *niu_img;

/** 牛人人气值*/
@property (nonatomic, copy) NSString *niu_pop;

/** 牛人更新时间  需换算成几小时前*/
@property (nonatomic, copy) NSString *niu_modtime;

/** 牛人 订阅量*/
@property (nonatomic, copy) NSString *niu_follow;

/** 牛人 推荐，后台使用的*/
@property (nonatomic, copy) NSString *niu_type;

@end
