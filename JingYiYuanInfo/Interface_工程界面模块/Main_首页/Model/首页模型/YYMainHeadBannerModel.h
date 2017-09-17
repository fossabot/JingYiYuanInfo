//
//  YYMainHeadBannerModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMainHeadBannerModel : NSObject
/**
 "picurl": "http://yyapp.1yuaninfo.com/uploads/image/20170801/ding1.jpg",
 "piclink": "http://www.baidu1.com"
 */

/** 图片地址*/
@property (nonatomic, copy) NSString *picurl;

/** 图片对应的链接*/
@property (nonatomic, copy) NSString *piclink;

@end
