//
//  YYBaseInfoDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseDetailController.h"

typedef void(^DislikeBlock)(NSString *newsId);

@interface YYBaseInfoDetailController : YYBaseDetailController

/** newsId*/
@property (nonatomic, copy) NSString *newsId;

/** indexPath*/
@property (nonatomic, strong) NSIndexPath *indexPath;

/** 不喜欢的回调*/
@property (nonatomic, copy) DislikeBlock dislikeBlock;

@end
