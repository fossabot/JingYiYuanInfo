//
//  YYOrderPushModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/31.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYOrderPushModel : NSObject

/**
 addtime": "2018-01-31 15:29:48",
 "gpdm": "002571",
 "isgain": "2",
 "yanbao": null

 */

/** addtime*/
@property (nonatomic, copy) NSString *addtime;

/** gpdm 股票代码*/
@property (nonatomic, copy) NSString *gpdm;

/** isgain 0卖出 盈利 1卖出 亏损 2持股中*/
@property (nonatomic, copy) NSString *isgain;

/** yanbao 空值为未上传*/
@property (nonatomic, copy) NSString *yanbao;



@end
