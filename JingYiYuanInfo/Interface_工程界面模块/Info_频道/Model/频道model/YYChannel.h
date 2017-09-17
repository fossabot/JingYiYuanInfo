//
//  YYChannel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYSubtitle;

@interface YYChannel : NSObject

/** icon*/
@property (nonatomic, copy) NSString *icon;

/** title*/
@property (nonatomic, copy) NSString *title;

/** subtitles*/
@property (nonatomic, strong) NSArray<YYSubtitle *> *subtitles;

@end
