//
//  YYDataBaseTool.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>


#define receiptId  @"receiptId"  //订单号
#define productId  @"productId"  //产品ID

@interface YYDataBaseTool : NSObject


/**
 单例实例化方法

 @return YYDataBaseTool对象
 */
+(instancetype)sharedDataBaseTool;

/**
 插入一条支付订单，支付回调后成功，再插入，否则没有receipt。我也没法判断交易是否成功，或者是否有这条交易信息，拿到交易receipt之后，先查找排重后插入数据库，再请求服务器完成交易后续操作，请求服务器返回成功回调，则将本地的数据库中该数据支付状态改为已支付。

 @param transactionIdentifier 交易ID
 @param productIdentifier 产品ID
 @param userid 用户ID
 @param receipt 交易凭证
 @param good_type 产品类型 1代表365会员  2 代表普通产品  3 代表 特色服务
 @param transactionDate 创建交易的时间
 @param rechargeDate 交易成功的时间
 @param state 交易状态  0代表未完成  1代表完成
 */

- (void)saveIapDataWithTransactionIdentifier:(NSString *)transactionIdentifier productIdentifier:(NSString *)productIdentifier userid:(NSString *)userid receipt:(NSString *)receipt good_type:(NSString *)good_type transactionDate:(NSString *)transactionDate rechargeDate:(NSString *)rechargeDate state:(NSInteger)state;



/**
 修改这条交易transactionIdentifier的交易状态，后台同步成功了
 */
- (void)changeTransactionIdentifierState:(NSString *)transactionIdentifier;



//检查该交易的交易状态，如果state是1 说明已同步完成 ，就不要再发给后台验证了
- (BOOL)checkTransactionDealState:(NSString *)transactionIdentifier;


/**
 检索出所有为支付完成的交易，返回的数组，再一个一个的进行后台同步，每次启动APP都要这么做

 @return 未完成同步的交易结果集
 */
- (NSMutableArray *)getAllUnCompleteIap;

@end
