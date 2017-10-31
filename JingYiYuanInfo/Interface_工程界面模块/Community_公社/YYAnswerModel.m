//
//  YYAnswerModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAnswerModel.h"
#import "NSCalendar+YYCommentDate.h"
#import <MJExtension/MJExtension.h>

@implementation YYAnswerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"answerId":@"id"
             };
}

- (NSString *)content {
    if (!_content) {
        return @"暂无回复";
    }
    return _content;
}

- (NSString *)posttime {
    
    if (_posttime && _posttime.length) {
        NSString *time = [NSCalendar commentDateByOriginalDate:_posttime withDateFormat:yyyyMMddHHmmss];
        
        return [NSString stringWithFormat:@"%@回复",time];
    }
    return @"";
}

@end
