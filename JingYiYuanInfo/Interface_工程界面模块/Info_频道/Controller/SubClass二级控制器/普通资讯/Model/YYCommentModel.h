//
//  YYCommentModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/18.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCommentModel : NSObject


@property (nonatomic, copy) NSString *avatar;   //用户头像
@property (nonatomic, copy) NSString *username;  //用户昵称
@property (nonatomic, copy) NSString *userid;    //用户id
@property (nonatomic, copy) NSString *flag;      //点赞状态  1点赞  0未点赞
@property (nonatomic, copy) NSString *reply_msg;    //评论内容
@property (nonatomic, copy) NSString *create_date;    //评论时间
@property (nonatomic, copy) NSString *zan_count;    //点赞数
@property (nonatomic, copy) NSString *commentid;    //评论id




@end
