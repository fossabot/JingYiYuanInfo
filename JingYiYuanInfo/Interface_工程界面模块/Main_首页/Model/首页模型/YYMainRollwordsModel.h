//
//  YYMainRollwordsModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  快讯的模型

#import <Foundation/Foundation.h>

@interface YYMainRollwordsModel : NSObject

/** 
 wid":"12","title":"白糖需求会逐步好转12","addtime":"2017-05-30"
 */

/** 快讯的id*/
@property (nonatomic, copy) NSString *wid;

/** 快讯的标题*/
@property (nonatomic, copy) NSString *title;

/** 快讯时间*/
@property (nonatomic, copy) NSString *addtime;


@end
