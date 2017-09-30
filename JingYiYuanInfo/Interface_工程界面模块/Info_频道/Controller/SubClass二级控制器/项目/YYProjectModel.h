//
//  YYProjectModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYProjectModel : NSObject


/** 
 {
 "id": "15897",
 "classid": "39",
 "title": "英国5月楼市复苏或企稳",
 "description": "我的归宿就是健康与才干，一个人终究可以信赖的，不过是他自己，能够为他扬眉吐气的也是他自己，我要什么归宿？我已找回我自己，我就是我的归宿。——《胭脂》",
 "picurl": "uploads/image/20170522/1495453052.png",
 "label": "3",
 "auth_tag": "自定义标签",
 "hits": "1793"
 }
 id,classid,title标题,description简介,picurl图片,label 1热 2荐 3推,auth_tag 自定义标签hits 关注量
 */

/** id*/
@property (nonatomic, copy) NSString *projectId;

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** title标题*/
@property (nonatomic, copy) NSString *title;

/** description简介*/
@property (nonatomic, copy) NSString *desc;

/** picurl图片地址*/
@property (nonatomic, copy) NSString *picurl;

/** label 属性标签 1热 2荐 3推*/
@property (nonatomic, copy) NSString *label;

/** auth_tag自定义标签*/
@property (nonatomic, copy) NSString *auth_tag;

/** hits点击量*/
@property (nonatomic, copy) NSString *hits;

/** webUrl*/
@property (nonatomic, copy) NSString *webUrl;

@end
