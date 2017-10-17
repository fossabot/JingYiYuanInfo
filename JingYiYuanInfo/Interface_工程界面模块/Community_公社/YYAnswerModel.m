//
//  YYAnswerModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAnswerModel.h"
#import "NSCalendar+YYCommentDate.h"

@implementation YYAnswerModel

- (NSString *)atime {
    
//    NSString *time = [NSCalendar commentDateByOriginalDate:_atime withDateFormat:yyyyMMddHHmmss];
    return [NSString stringWithFormat:@"%@回复",_atime];
}

@end
