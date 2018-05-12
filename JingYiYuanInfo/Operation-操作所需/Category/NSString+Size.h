//
//  NSString+Size.h
//  壹元服务
//
//  Created by VINCENT on 2017/9/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;

//- (CGSize)subClassString:(NSAttributedString *)attrStr sizeWithFont:(UIFont *)font size:(CGSize)size;

+ (CGSize)attributeString:(NSAttributedString *)attributeString size:(CGSize)size;

+ (CGSize)attributeString:(NSAttributedString *)attributeString attribute:(NSDictionary *)attribute size:(CGSize)size;



@end
