//
//  YYBaseMusicModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  音乐的模型

#import "YYBaseMusicModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYBaseMusicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"musicId":@"id"
             };
}

- (NSString *)posttime {
    YYLogFunc
    return [NSCalendar commentDateByOriginalDate:_posttime withDateFormat:yyyyMMddHHmmss];
}

- (void)setPicurl:(NSString *)picurl {
    
    if (![picurl containsString:@"http"]) {
        
        _picurl = [NSString stringWithFormat:@"%@%@",yyappJointUrl,picurl];
    }
}


- (NSString *)URL {
    
    
    if ([_URL containsString:@"http"]) {
        return _URL;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_URL];
}

@end
