//
//  YYSearchModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSearchModel.h"

#import <MJExtension/MJExtension.h>

@implementation YYSearchModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"searchId":@"id"
             };
}

- (NSString *)webUrl {
    
    _webUrl = [NSString stringWithFormat:@"%@%@",infoWebJointUrl,_searchId];
    return _webUrl;
}

- (NSString *)shareUrl {
    _shareUrl = [NSString stringWithFormat:@"%@%@",infoWebShareJointUrl,_searchId];
    return _shareUrl;
}

@end
