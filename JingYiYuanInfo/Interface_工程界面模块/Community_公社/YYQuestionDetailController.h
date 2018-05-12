//
//  YYQuestionDetailController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface YYQuestionDetailController : THBaseViewController

/** 牛人id  关注牛人时使用*/
@property (nonatomic, copy) NSString *niu_id;


/** articleId文章id  根据这个查相关回复*/
@property (nonatomic, copy) NSString *articleId;

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSAttributedString *questionStr;


@end
