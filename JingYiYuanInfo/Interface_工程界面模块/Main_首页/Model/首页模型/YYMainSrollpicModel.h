//
//  YYMainSrollpicModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  中间的横幅轮播图模型

#import <Foundation/Foundation.h>

@interface YYMainSrollpicModel : NSObject

/** 
 "picurl": "http://yyapp.1yuaninfo.com/uploads/image/20170801/1.jpg",
 "piclink": "http://www.baidu5.com"
 */

/** 横幅轮播的图片*/
@property (nonatomic, copy) NSString *picurl;

/** 横幅轮播图片对应的链接*/
@property (nonatomic, copy) NSString *piclink;


@end
