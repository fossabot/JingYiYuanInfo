//
//  YYCommentModel.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/18.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentModel.h"
#import "NSCalendar+YYCommentDate.h"

@implementation YYCommentModel

- (NSString *)create_date {
    
    return [NSCalendar commentDateByOriginalDate:_create_date withDateFormat:yyyyMMddHHmmss];
}

@end
