//
//  YYMessageModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/9/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMessageModel : NSObject

/** 
  [{"date":日期 "04月10日",
 //"info":相应日期的快讯数组 [{"id":消息的id,拼接成链接 "5", "title":消息的标题 "文字公告", "addtime":消息添加的时间 "2017-04-10"}]}]
 */

/** id 消息的id 拼接成链接*/
@property (nonatomic, copy) NSString *msgId;

/** title 消息的标题*/
@property (nonatomic, copy) NSString *title;

/** addtime 消息添加的时间*/
@property (nonatomic, copy) NSString *addtime;

@end
