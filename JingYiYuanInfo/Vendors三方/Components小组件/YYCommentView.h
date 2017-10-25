//
//  YYCommentView.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommentBlock)(NSString *comment);

@interface YYCommentView : UIView

@property (nonatomic, copy) CommentBlock commentBlock;

/** 写评论按钮的文字*/
@property (nonatomic, copy) NSString *placeHolder;


/* 清除评论text*/
- (void)clearText;

/* 显示评论框*/
- (void)show;

@end
