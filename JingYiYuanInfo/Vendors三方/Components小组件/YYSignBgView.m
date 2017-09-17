//
//  YYSignBgView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSignBgView.h"

@interface YYSignBgView()

/** 已签到时展示的label*/
@property (nonatomic, strong) UILabel *signedLabel;

@end

@implementation YYSignBgView
{
    CGFloat w;
    CGFloat h;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        w = frame.size.width;
        h = frame.size.height;
        _sign = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)signedLabel {
    if (!_signedLabel) {
        _signedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, h*0.1, w, 0.9*h)];
        _signedLabel.backgroundColor = [UIColor clearColor];
        _signedLabel.textColor = [UIColor whiteColor];
        _signedLabel.textAlignment = NSTextAlignmentCenter;
        _signedLabel.numberOfLines = 0;
        _signedLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_signedLabel];
    }
    return _signedLabel;
}

- (void)setSignDays:(NSString *)signDays {
    if ([signDays isEqualToString:@"0"]) {
        self.signedLabel.text = @"签到";
        _sign = NO;
        return;
    }
    _signDays = [NSString stringWithFormat:@"已签到\n累计签到%@天",signDays];
    NSRange range = [_signDays rangeOfString:@"已签到"];
    
    // 转换成可以操作的字符串类型.
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_signDays];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attrStr.length)];
    
    // 添加属性(粗体)
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:range];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(range.length, _signDays.length-range.length)];
    self.signedLabel.attributedText = attrStr;
    
    _sign = YES;
}

- (void)drawRect:(CGRect)rect {
    
    //100  55
    
    CGFloat rectw = rect.size.width;
    CGFloat recth = rect.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *a = [UIColor colorWithRed:235.0/255 green:130.0/255 blue:40.0/255 alpha:1.0];
    CGContextAddArc(context, 0.55*rectw, recth, recth, 0.0, M_PI, 1);
    CGContextSetFillColorWithColor(context, a.CGColor);
    CGContextDrawPath(context, kCGPathFill);//填充颜色
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isContain = [self touchPointInsideCircle:CGPointMake(w*0.55, h) radius:h targetPoint:point];
    if (isContain) {
        
        return self;
    }
    return nil;
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
     CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) + (point.y - center.y) * (point.y - center.y));
     return (dist <= radius);
}

@end
