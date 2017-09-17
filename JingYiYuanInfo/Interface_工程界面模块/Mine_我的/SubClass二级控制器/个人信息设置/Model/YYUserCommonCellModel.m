//
//  YYUserCommonCellModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUserCommonCellModel.h"

@implementation YYUserCommonCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isBundleSDK = NO;
        _isHaveIndicator = NO;
    }
    return self;
}

@end
