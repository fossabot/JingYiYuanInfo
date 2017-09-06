//
//  YYEdgeLabel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYEdgeLabel.h"

@implementation YYEdgeLabel

+ (instancetype)edgeInsetLabelWithTitle:(NSString *)title
                             titleColor:(UIColor *)titleColor
                             edgeInsets:(UIEdgeInsets)edgeInsets
                            borderColor:(UIColor *)borderColor
                            borderWidth:(CGFloat)borderWidth
                               fontSize:(CGFloat)fontSize
                           maskToBounds:(BOOL)maskToBounds
                           cornerRadius:(CGFloat)cornerRadius {
    
    YYEdgeLabel *edgeInsetLabel = [[YYEdgeLabel alloc] init];
    
    edgeInsetLabel.edgeInsets = edgeInsets;//UIEdgeInsetsMake(2, 2, 2, 2);
    edgeInsetLabel.text = title;
    edgeInsetLabel.font = [UIFont systemFontOfSize:fontSize];
    edgeInsetLabel.textColor = titleColor;
    edgeInsetLabel.layer.masksToBounds = maskToBounds;
    edgeInsetLabel.layer.cornerRadius = cornerRadius;
    edgeInsetLabel.layer.borderColor = borderColor.CGColor;
    edgeInsetLabel.layer.borderWidth = borderWidth;
    [edgeInsetLabel sizeToFit];
    
    return edgeInsetLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _edgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
        self.font = [UIFont systemFontOfSize:14];
        self.layer.borderWidth = 0.3;
        
    }
    return self;
    
}

// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

/** 增加label的内边距*/
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}



@end
