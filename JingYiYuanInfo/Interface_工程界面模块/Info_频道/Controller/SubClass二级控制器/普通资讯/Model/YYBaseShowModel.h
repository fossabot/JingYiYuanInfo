//
//  YYBaseShowModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYShowBannerModel;
@class YYShowRecommendModel;
@class YYShowLikeModel;

@interface YYBaseShowModel : NSObject

//返回值:  "lb_arr" 轮播图数组: [{"picurl":图片地址（不需拼接）  "piclink":图片对应的网址（不需拼接）}]
//"tj_arr" 推荐数组: [{ "id": "1"拼接id形成网址 ,"indeximg": 拼接imgJointUrl"uploads/image/20170225/1488014998.png" }
//"xh_arr" 喜欢的列表: [{
//   "id":         id         "301",
//   "actionname": 标题         "主课上午",
//   "palace":     地点         "北京天音",
//   "actiontime": 时间         "2017-09-06 11:40:22",
//   "indeximg":   图片         "uploads/image/20170906/1504671647.jpg",
//   "tag":                 null,
//   "price":      价格         "100元/张"}]
//   "lastid": "34"

/** banner数组*/
@property (nonatomic, strong) NSArray<YYShowBannerModel *> *lb_arr;

/** 推荐数组*/
@property (nonatomic, strong) NSArray<YYShowRecommendModel *> *tj_arr;

/** 喜欢的数组*/
@property (nonatomic, strong) NSArray<YYShowLikeModel *> *xh_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;




@end
