//
//  YYShowLikeModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYShowLikeModel.h"
#import <MJExtension/MJExtension.h>

@implementation YYShowLikeModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"likeId":@"id"
             };
}

- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",showWebJointUrl,_likeId];
}

- (NSString *)actiontime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:_actiontime];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [NSString stringWithFormat:@"时间:%@",[formatter stringFromDate:date]];
    
}

- (NSString *)palace {
    
    return [NSString stringWithFormat:@"地点:%@",_palace];
}

//- (NSString *)price {
//    
//    return [NSString stringWithFormat:@"￥%@",_price];
//}

- (NSString *)indeximg {
    
    if ([_indeximg containsString:@"http"]) {
        return _indeximg;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_indeximg];
}

@end
