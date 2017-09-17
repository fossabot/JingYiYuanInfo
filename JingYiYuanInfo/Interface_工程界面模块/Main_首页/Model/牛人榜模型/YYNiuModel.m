//
//  YYNiuModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuModel.h"
#import "MJExtension.h"


@implementation YYNiuModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"niu_arr":@"YYNiuManModel",
             @"niuart_arr":@"YYNiuArticleModel"
             };
}

@end
