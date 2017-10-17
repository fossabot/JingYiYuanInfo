//
//  YYIAPTool.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAPShare.h"

@interface YYIAPTool : NSObject


/** 购买产品  通过产品id(通常为产品id一般为你工程的 Bundle ID + 功能 + 数字，ps:com.yyinfo)  需与iTunes connect 产品ID后台一致  productType 商品类型1会员2特色3三找4积分*/
+ (void)buyProductByProductionId:(NSString *)productionId type:(NSString *)productType;

+ (void)printReceipt;

@end
