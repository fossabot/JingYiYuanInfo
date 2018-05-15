//
//  YYBaseModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/4.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYDataBaseTool.h"

@interface YYBaseModel : NSObject

/** 是否被选中，改变这个值来让其显示是否已阅读*/
@property (nonatomic, assign) BOOL selected;

@end
