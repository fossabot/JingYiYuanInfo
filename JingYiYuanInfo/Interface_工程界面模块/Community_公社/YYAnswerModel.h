//
//  YYAnswerModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYAnswerModel : NSObject

/** 
 "info": [
 {
 "artitle": "王卫“搞圈子” 顺丰的BAT之路",
 "question": "没有明白",
 "qtime": "2017-09-13",
 "arid": "4",
 "answer": "回复第二次的追问",
 "questionid": "2",
 "niuid": "1",
 "atime": "2017-07-27",
 "niuhead": "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3829735578,2254608249&fm=173&s=D10ABA570133763635E0C37E03004067&w=640&h=480&img.JPEG"
 },
 */

/** 回答的id*/
@property (nonatomic, copy) NSString *answerId;

/** questionid问题的id*/
@property (nonatomic, copy) NSString *questionid;

/** niuhead牛人头像*/
@property (nonatomic, copy) NSString *niuhead;

/** answer 回答内容*/
@property (nonatomic, copy) NSString *content;

/** 牛人id*/
@property (nonatomic, copy) NSString *niuid;

/** 回答时间*/
@property (nonatomic, copy) NSString *posttime;

/** 提问内容*/
@property (nonatomic, copy) NSString *qucotent;

/** qtime 提问时间*/
@property (nonatomic, copy) NSString *qtime;

/** arid 文章id*/
@property (nonatomic, copy) NSString *arid;


@end
