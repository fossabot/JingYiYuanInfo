//
//  YYSecondCommentController.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@class YYCommentModel;

@interface YYSecondCommentController : THBaseViewController

@property (nonatomic, strong) YYCommentModel *firstCommentModel;

/** newsId*/
@property (nonatomic, copy) NSString *newsId;

@property (nonatomic, copy) NSString *commentid;

@end
