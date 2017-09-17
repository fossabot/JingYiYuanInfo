//
//  YYShowRecommendModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYShowRecommendModel : NSObject

//"tj_arr" 推荐数组: [{ "id": "1"拼接id形成网址 ,"indeximg": 拼接imgJointUrl"uploads/image/20170225/1488014998.png" }

/** id*/
@property (nonatomic, copy) NSString *showRecommendId;

/** 推荐内容网址*/
@property (nonatomic, copy) NSString *webUrl;

/** 图片indeximg*/
@property (nonatomic, copy) NSString *indeximg;



@end
