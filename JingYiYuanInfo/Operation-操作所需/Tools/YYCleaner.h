//
//  YYCleaner.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCleaner : NSObject


// 获取缓存文件的大小
+ (float)readCacheSize;

// 清除缓存
+ (void)clean;


@end
