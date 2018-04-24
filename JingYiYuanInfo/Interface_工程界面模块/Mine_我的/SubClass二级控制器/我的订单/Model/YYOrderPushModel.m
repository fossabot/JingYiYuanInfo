//
//  YYOrderPushModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/31.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYOrderPushModel.h"

@implementation YYOrderPushModel

- (NSString *)addtime {
    return [NSString stringWithFormat:@"购买时间：%@",_addtime];
}

- (NSString *)gpdm {
    return [NSString stringWithFormat:@"股票代码：%@",_gpdm];
}

- (NSString *)isgain {
    
    if ([_isgain isEqualToString:@"0"]) {
        return @"状态：成功";
    }else if ([_isgain isEqualToString:@"1"]){
        return @"状态：失败";
    }else {
        return @"状态：持股中";
    }
}



@end
