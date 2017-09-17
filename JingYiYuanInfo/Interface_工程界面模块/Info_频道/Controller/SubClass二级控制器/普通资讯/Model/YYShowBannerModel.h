//
//  YYShowBannerModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYShowBannerModel : NSObject

//"lb_arr" 轮播图数组: [{"picurl":图片地址（不需拼接）  "piclink":图片对应的网址（不需拼接）}]

/** picurl*/
@property (nonatomic, copy) NSString *picurl;

/** piclink*/
@property (nonatomic, copy) NSString *piclink;

@end
