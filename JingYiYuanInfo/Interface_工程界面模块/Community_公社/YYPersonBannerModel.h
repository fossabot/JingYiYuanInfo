//
//  YYPersonBannerModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  公社自媒体轮播图的Model

#import <Foundation/Foundation.h>

@interface YYPersonBannerModel : NSObject

/**
 lb_arr:轮播图  picurl图片,piclink 链接
*/

/** picurl图片*/
@property (nonatomic, copy) NSString *picurl;

/** piclink链接*/
@property (nonatomic, copy) NSString *piclink;


@end
