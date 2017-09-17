//
//  YYMainModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainModel.h"
#import "MJExtension.h"


@implementation YYMainModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"roll_pic":@"YYMainHeadBannerModel",
             @"roll_words":@"YYMainRollwordsModel",
             @"sroll_pic":@"YYMainSrollpicModel"
             };
}


@end
