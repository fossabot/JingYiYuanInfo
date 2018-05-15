//
//  YYHotPicsModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/31.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  图集的模型

#import "YYBaseModel.h"



@interface YYHotPicsModel : YYBaseModel

/**
 *  img:图片  descreption:描述
 */

/** 图片*/
@property (nonatomic, copy) NSString *img;

/** 描述*/
@property (nonatomic, copy) NSString *desc;


@end
