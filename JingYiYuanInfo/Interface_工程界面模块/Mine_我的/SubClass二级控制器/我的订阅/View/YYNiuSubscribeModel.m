//
//  YYNiuSubscribeModel.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/16.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuSubscribeModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYNiuSubscribeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"subscribeId":@"id"
             };
}

- (NSString *)posttime {
    
    return [NSCalendar commentDateByOriginalDate:_posttime withDateFormat:yyyyMMddHHmmss];
}


- (NSString *)niu_head {
    
    if ([_niu_head containsString:@"http"]) {
        return _niu_head;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_niu_head];
    
}

@end
