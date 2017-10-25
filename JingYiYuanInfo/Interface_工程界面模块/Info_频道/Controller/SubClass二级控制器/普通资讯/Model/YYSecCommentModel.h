//
//  YYSecCommentModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYSecCommentModel : NSObject


@property (nonatomic, copy) NSString *secComment_id;  //当前评论的二级评论id
@property (nonatomic, copy) NSString *user_avatar;   //一级评论用户头像
@property (nonatomic, copy) NSString *from_user_avatar;   //二级评论用户头像
@property (nonatomic, copy) NSString *from_user_name;  //用户昵称
@property (nonatomic, copy) NSString *from_user_id;    //当前评论者id
@property (nonatomic, copy) NSString *to_user_name;    //评论对方的昵称
@property (nonatomic, copy) NSString *to_user_id;    //评论对方的id
@property (nonatomic, copy) NSString *flag;      //点赞状态  1点赞  0未点赞
@property (nonatomic, copy) NSString *reply_msg;    //评论内容
@property (nonatomic, copy) NSString *create_date;    //评论时间
@property (nonatomic, copy) NSString *zan_count;    //点赞数
@property (nonatomic, copy) NSString *comment_id;    //一级评论的id

@property (nonatomic, copy) NSString *name;

//comment_id 一级评论的id
//from_user_id 当前评论者id
//to_user_name 评论对方的昵称
//to_user_id 评论对方的id
//reply_msg 评论内容
//zan_count 点赞数
//create_date 时间
//user_avatar 一级评论用户头像
//from_user_avatar 二级评论用户头像
//flag  点赞状态

@end
