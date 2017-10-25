//
//  YYDetailToolBar.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DetailToolBarType) {
    DetailToolBarTypeWriteComment = 1 << 0, //写品论按钮
    DetailToolBarTypeComment = 1 << 1, //评论按钮
    DetailToolBarTypeFavor = 1 << 2, // 收藏按钮
    DetailToolBarTypeShare = 1 << 3, //分享按钮
    DetailToolBarTypeReward = 1 << 4,  //打赏按钮
    DetailToolBarTypeFlexible = 1 <<5  //填补控件，当就一个按钮时需加这个按钮，masonry方法中必须要有两个控件
};

@class YYDetailToolBar;

@protocol YYDetailToolBarDelegate <NSObject>

- (void)detailToolBar:(YYDetailToolBar *)toolBar didSelectBarType:(DetailToolBarType)barType;

@end

//typedef void(^ToolBarSelectBlock)(DetailToolBarType toolBarType);
typedef void(^SendComment)(NSString *comment);

@interface YYDetailToolBar : UIView



/** toolbar的基本类型*/
@property (nonatomic, assign) DetailToolBarType toolBarType;

/** selectBlock*/
//@property (nonatomic, copy) ToolBarSelectBlock selectBlock;

/** 发送评论的回调*/
@property (nonatomic, copy) SendComment sendCommentBlock;

/** favor 是否收藏了*/
@property (nonatomic, assign) BOOL isFavor;

/** 写评论按钮的文字*/
@property (nonatomic, copy) NSString *placeHolder;

/** delegate*/
@property (nonatomic, weak) id<YYDetailToolBarDelegate> delegate;

/** 写评论*/
- (void)writeComments:(void(^)(NSString *comment))comment;

/* 清除评论text*/
- (void)clearText;

@end
