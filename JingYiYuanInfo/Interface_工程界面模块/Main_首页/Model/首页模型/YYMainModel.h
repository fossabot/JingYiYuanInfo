//
//  YYMainModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  首页的模型

#import <Foundation/Foundation.h>
#import "YYMainHeadBannerModel.h"
#import "YYMainRollwordsModel.h"
#import "YYMainSrollpicModel.h"
#import "YYMainPostmsgModel.h"
#import "YYMainMarketDataModel.h"

@interface YYMainModel : NSObject

/** 头部轮播模型数组*/
@property (nonatomic, strong) NSArray<YYMainHeadBannerModel *> *roll_pic;

/** 快讯模型数组*/
@property (nonatomic, strong) NSArray<YYMainRollwordsModel *> *roll_words;

/** 横幅轮播模型数组*/
@property (nonatomic, strong) NSArray<YYMainSrollpicModel *> *sroll_pic;

/** 推送消息*/
@property (nonatomic, strong) YYMainPostmsgModel *post_msg;

/** 证券指数的图片*/
@property (nonatomic, strong) YYMainMarketDataModel *zhishu;

@end
