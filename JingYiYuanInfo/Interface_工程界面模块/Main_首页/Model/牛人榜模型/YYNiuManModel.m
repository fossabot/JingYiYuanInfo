//
//  YYNiuManModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManModel.h"
#import "NSCalendar+YYCommentDate.h"

@implementation YYNiuManModel

- (NSString *)niu_modtime {
    NSString *modtime = [NSCalendar commentDateByOriginalDate:_niu_modtime withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"%@更新",modtime];
}

@end
