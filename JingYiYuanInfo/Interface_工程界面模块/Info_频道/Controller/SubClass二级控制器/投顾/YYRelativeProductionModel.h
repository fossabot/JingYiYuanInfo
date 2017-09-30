//
//  YYRelativeProductionModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  公司简介详情的相关产品推荐

#import <Foundation/Foundation.h>

@interface YYRelativeProductionModel : NSObject

/**
 com_pic 图片
 label 标签: 热 荐 (如果不需要略掉)
 introduce 简介
 part 简介下面 标签
 yname 产品名称
 ystate 状态 1在售2售罄
 yprice  价格
 id  产品id
 
 */

/** com_pic 图片*/
@property (nonatomic, copy) NSString *com_pic;

/**  label 标签: 热 荐 (如果不需要略掉)*/
@property (nonatomic, copy) NSString *label;

/** introduce 简介*/
@property (nonatomic, copy) NSString *introduce;

/** part 简介下面 标签*/
@property (nonatomic, copy) NSString *part;

/** yname 产品名称*/
@property (nonatomic, copy) NSString *yname;

/** ystate 状态 1在售2售罄*/
@property (nonatomic, copy) NSString *ystate;

/** yprice  价格*/
@property (nonatomic, copy) NSString *yprice;

/** 产品id*/
@property (nonatomic, copy) NSString *produtionId;

@end
