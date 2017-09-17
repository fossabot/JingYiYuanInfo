//
//  YYMainPostmsgModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  推送信息的模型
/**
 *  "id": "2",
 "keyword1": "5",
 "alert": "iso标题",
 "title": "安卓标题",
 "show_msg": "显示简介",
 "addtime": "2017-07-08 12:23:44"
 */
#import <Foundation/Foundation.h>

@interface YYMainPostmsgModel : NSObject

/** 推送信息的id*/
@property (nonatomic, copy) NSString *postmsg_id;

/** 推送  keyword1:5 早餐,6早评,7上午分享,8午评,9下午分享,10收评,11夜宵,12即使通知*/
@property (nonatomic, assign) NSInteger keyword1;

/** 推送iOS的标题*/
@property (nonatomic, copy) NSString *alert;

/** 推送Android的标题*/
@property (nonatomic, copy) NSString *title;

/** 推送信息简介*/
@property (nonatomic, copy) NSString *remark;

/** 推送信息时间  需要格式化成 时:分:秒 */
@property (nonatomic, copy) NSString *addtime;

@end
