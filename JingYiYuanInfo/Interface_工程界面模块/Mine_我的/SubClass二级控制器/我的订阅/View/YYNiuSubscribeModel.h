//
//  YYNiuSubscribeModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/16.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYNiuSubscribeModel : NSObject

//id
//true string
//userid
//true string
//niu_id
//true string
//niu_introduction
//true string
//niu_name
//true string
//niu_head
//true string
//posttime

@property (nonatomic, copy) NSString *subscribeId;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *niu_id;

@property (nonatomic, copy) NSString *niu_introduction;

@property (nonatomic, copy) NSString *niu_name;

@property (nonatomic, copy) NSString *niu_head;

@property (nonatomic, copy) NSString *posttime;
/** 人气*/
@property (nonatomic, copy) NSString *niu_pop;

@property (nonatomic, copy) NSString *aid;

@end
