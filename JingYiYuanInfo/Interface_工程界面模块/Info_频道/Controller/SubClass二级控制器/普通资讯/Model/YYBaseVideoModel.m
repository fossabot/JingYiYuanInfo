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
    if ([_v_url containsString:@"http"]) {
        return _v_url;
    }
    return [NSString stringWithFormat:@"%@%@",infoVideoJointUrl,_v_url];
}

- (NSString *)v_picture {
    
    if ([_v_picture containsString:@"http"]) {
        return _v_picture;
    }
    return [NSString stringWithFormat:@"%@%@",yyfwJointUrl,_v_picture];
}

- (NSString *)v_modtime {
    
    return [NSCalendar commentDateByOriginalDate:_v_modtime withDateFormat:yyyyMMddHHmmss];
}

- (NSString *)v_hits {
    NSInteger hits = [_v_hits integerValue];
    if (hits > 10000) {
        return [NSString stringWithFormat:@"%.2lf万次播放",hits/10000.0];
    }else {
        return [NSString stringWithFormat:@"%ld次播放",hits];
    }
}

@end
