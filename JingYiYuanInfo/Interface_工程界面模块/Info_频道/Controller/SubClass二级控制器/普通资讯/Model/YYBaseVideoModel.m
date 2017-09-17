//
//  YYBaseVideoModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  资讯视频模型

#import "YYBaseVideoModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYBaseVideoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"videoId":@"id"
             };
}

- (NSString *)v_url {
    
    return [NSString stringWithFormat:@"%@%@",infoVideoJointUrl,_v_url];
}

- (NSString *)v_picture {
    
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_v_picture];
}

- (NSString *)v_modtime {
    
    return [NSCalendar commentDateByOriginalDate:_v_modtime withDateFormat:yyyyMMddHHmmss];
}

@end
