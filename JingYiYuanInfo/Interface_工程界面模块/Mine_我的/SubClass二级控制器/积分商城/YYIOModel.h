//
//  YYIOModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYIOModel : NSObject

/** 
 "id": "10",
 "userid": "1499064765j6qavy",
 "type": "1",
 "amount": "300",
 "goodtitle": "西门子冰箱",
 "goodimg": "uploads/image/20170911/ximenzi.jpg",
 "explain": "积分商城兑换电视机",
 "addtime": "2017-03-23 14:49:44"
 */

/** ioId*/
@property (nonatomic, copy) NSString *ioId;

/** userid*/
@property (nonatomic, copy) NSString *userid;

/** type 类型 0 收入 1 商品兑换支出 2 其他支出*/
@property (nonatomic, copy) NSString *type;

/** amount 积分数量*/
@property (nonatomic, copy) NSString *amount;

/** goodtitle 商品标题或者收入 支出 方向标题*/
@property (nonatomic, copy) NSString *goodtitle;

/** goodimg 商品图 其他忽略*/
@property (nonatomic, copy) NSString *goodimg;

/** explain 商品说明*/
@property (nonatomic, copy) NSString *explain;

/** addtime*/
@property (nonatomic, copy) NSString *addtime;


@end
