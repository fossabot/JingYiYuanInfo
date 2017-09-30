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
    
    if ([_indeximg containsString:@"http"]) {
        return _indeximg;
    }
#warning 暂时用之前的yyfw的拼接地址，现在的地址没有数据，上线必须用yyapp
    return [NSString stringWithFormat:@"%@%@",yyfwJointUrl,_indeximg];
}


- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",showWebJointUrl,_showRecommendId];
}

@end
