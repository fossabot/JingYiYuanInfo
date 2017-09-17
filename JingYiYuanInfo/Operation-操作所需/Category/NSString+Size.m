//
//  NSString+Size.m
//  壹元服务
//
//  Created by VINCENT on 2017/9/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font {
    
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attr
                                                 context:nil].size;
    return contentSize;
}

@end
