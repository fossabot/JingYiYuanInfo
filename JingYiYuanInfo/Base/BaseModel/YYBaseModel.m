//
//  YYBaseModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/4.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseModel.h"

@implementation YYBaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selected = NO;//初始化为未选中
    }
    return self;
}

@end
