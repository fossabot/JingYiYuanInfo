//
//  YYMineCollectionModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineCollectionModel.h"
#import <MJExtension/MJExtension.h>
#import "NSCalendar+YYCommentDate.h"

@implementation YYMineCollectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"collectionId":@"id"
             };
}

//类型:1资讯文章,2资讯视频 3牛人文章 4公社视频 5项目
- (NSString *)col_type {
    if ([_col_type isEqualToString:@"1"]) {
        _newsType = 1;
        return @"资讯";
    }else if ([_col_type isEqualToString:@"2"]) {
        _newsType = 2;
        return @"资讯视频";
    }else if ([_col_type isEqualToString:@"3"]) {
        _newsType = 3;
        return @"牛人文章";
    }else if ([_col_type isEqualToString:@"4"]) {
        _newsType = 4;
        return @"公社视频";
    }else {
        _newsType = 5;
        return @"项目";
    }
}

- (NSString *)col_time {
    return [NSCalendar commentDateByOriginalDate:_col_time withDateFormat:yyyyMMddHHmmss];
}

- (NSString *)webUrl {
    
    switch ([_col_type integerValue]) {
        case 1:
            return [NSString stringWithFormat:@"%@%@",infoWebJointUrl,_col_id];
            break;
            
        case 3:
            return [NSString stringWithFormat:@"%@%@",niuWebJointUrl,_col_id];
            break;
            
        case 5:
            return [NSString stringWithFormat:@"%@%@",projecyJointUrl,_col_id];
            break;
            
        default:
            return nil;
            break;
    }
}

@end
