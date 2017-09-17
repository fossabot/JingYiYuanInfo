//
//  YYShowRecommendModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYShowRecommendModel.h"
#import <MJExtension/MJExtension.h>


@implementation YYShowRecommendModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"showRecommendId":@"id"
             };
}

- (NSString *)indeximg {
    
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_indeximg];
}


- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",showWebJointUrl,_showRecommendId];
}

@end
