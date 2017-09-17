//
//  YYHotPicsModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/31.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotPicsModel.h"
#import "MJExtension.h"

@implementation YYHotPicsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"desc":@"description"
             };
}

//- (NSString *)img {
//    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_img];
//}

@end
