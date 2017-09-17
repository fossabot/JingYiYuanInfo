//
//  YYFastMsgSecionModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYMainRollwordsModel;

@interface YYFastMsgSecionModel : NSObject

/** "info"*/
@property (nonatomic, strong) NSArray<YYMainRollwordsModel *> *info;

/** lastdate*/
@property (nonatomic, copy) NSString *date;

@end
