//
//  YYIapModel.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYIapModel : NSObject

/**
 交易状态返回的交易ID
 */
@property (nonatomic, copy) NSString *transactionIdentifier;

/**
 iTunesconnect后台对于的产品ID
 */
@property (nonatomic, copy) NSString *productIdentifier;

/**
 用户ID，我们自己服务器后台对应的用户ID
 */
@property (nonatomic, copy) NSString *userid;

/**
 交易数据
 */
@property (nonatomic, copy) NSString *receipt;

/**
 产品类型  1、365会员  2、特色服务  3、
 */
@property (nonatomic, copy) NSString *good_type;

/**
 交易时间
 */
@property (nonatomic, copy) NSString *transactionDate;

/**
 到账时间
 */
@property (nonatomic, copy) NSString *rechargeDate;

/**
 交易状态  （1已支付 / 0未支付）
 */
@property (nonatomic, assign) NSInteger state;


@end
