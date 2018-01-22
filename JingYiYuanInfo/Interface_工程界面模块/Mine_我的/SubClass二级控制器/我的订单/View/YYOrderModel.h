//
//  YYOrderModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYOrderModel : NSObject

/*
 "id": "2",
 "packname": "积分购买",
 "ordernum": "14538339022017101016291430989329",
 "leixing": "1",
 "buytime": "",
 "price": "1",
 "number": "10",
 "cost": "10",
 "alltimes": "0",
 "lastime": "0",
 "expiretime": null,
 "transaction_id": null,

 */

@property (nonatomic, copy) NSString *orderId;   //订单表中的id
@property (nonatomic, copy) NSString *packname;  //商品名称
@property (nonatomic, copy) NSString *ordernum;  //订单号
@property (nonatomic, copy) NSString *leixing;   //类型  1会员2特色3三找
@property (nonatomic, copy) NSString *price;     //价格
@property (nonatomic, copy) NSString *cost;      //实付金额
@property (nonatomic, copy) NSString *alltimes;  //总次数
@property (nonatomic, copy) NSString *lastime;    //剩余次数
@property (nonatomic, copy) NSString *expiretime; //到期时间
@property (nonatomic, copy) NSString *buytime;    //购买时间
@property (nonatomic, copy) NSString *paystatus;  //订单状态 3退单中  4已退单

@property (nonatomic, copy) NSString *expireCalculate; //到期时间的计算结果

@end
