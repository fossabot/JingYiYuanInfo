//
//  YYCommunityQuestionModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityQuestionModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYCommunityQuestionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"articleId":@"id",
             @"desc":@"description"
             };
}

- (NSString *)picurl {
    
    if ([_picurl containsString:@"http"]) {
        return _picurl;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_picurl];
}

- (NSString *)niu_img {
    
    if ([_niu_img containsString:@"http"]) {
        return _niu_img;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_niu_img];
}

@end
