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
    
    return [self sizeWithFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size {
    
    NSDictionary *attr = @{
                           NSFontAttributeName:font
                           };
    CGSize contentSize = [self boundingRectWithSize:size
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attr
                                            context:nil].size;
    return contentSize;
}

+ (CGSize)attributeString:(NSAttributedString *)attributeString size:(CGSize)size {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    
    NSDictionary *info = @{NSFontAttributeName:sysFont(13),NSParagraphStyleAttributeName:paragraphStyle};
    return [self attributeString:attributeString attribute:info size:size];
    
}

+ (CGSize)attributeString:(NSAttributedString *)attributeString attribute:(NSDictionary *)attribute size:(CGSize)size {
    
    CGSize contentSize = [attributeString.string boundingRectWithSize:size
                                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           attributes:attribute
                                                              context:nil].size;

    return contentSize;
}


@end
