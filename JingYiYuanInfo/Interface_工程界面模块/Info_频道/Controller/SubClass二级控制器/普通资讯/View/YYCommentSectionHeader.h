//
//  YYCommentSectionHeader.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCommentSectionHeader : UIView



/** 类方法快速返回热门跟帖的view */
+ (instancetype)replyViewFirst;

/** 类方法快速返回最新跟帖的view */
+ (instancetype)replyViewLast;

@end
