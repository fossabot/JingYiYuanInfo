//
//  YYPushListCellModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPushListCellModel.h"
#import <MJExtension/MJExtension.h>
#import "NSString+Size.h"
#import "NSString+AttributedString.h"


@implementation YYPushListCellModel
{
    CGFloat _cellHeight;
    NSAttributedString *_attributeStr;
    BOOL _lastExtendState;
    BOOL _transitCheckTime;
    BOOL _transitKeyword;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isHaveExtendBtn = YES;
        _extendState = NO;
        _transitCheckTime = NO;
        _transitKeyword = NO;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"pushId":@"id"
             };
}

- (NSAttributedString *)pushAttributedString {
    
    if (_attributeStr.length) {
        return _attributeStr;
    }
    NSString *temp = @"";
    
    if (_remark && _remark.length && ![_remark isEqualToString:@""]) {
        if ([_remark containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_remark componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _remark = [strArr componentsJoinedByString:@"<br />"];
        }
        temp = [temp stringByAppendingString:_remark];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_fxtime && _fxtime.length && ![_fxtime isEqualToString:@""]) {
        if ([_fxtime containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_fxtime componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _fxtime = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"分享时间：%@",_fxtime];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_dmname && _dmname.length && ![_dmname isEqualToString:@""]) {
        if ([_dmname containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_dmname componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _dmname = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"分享股票：%@",_dmname];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_fxcontent && _fxcontent.length && ![_fxcontent isEqualToString:@""]) {
        if ([_fxcontent containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_fxcontent componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _fxcontent = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"分享理由：<br />%@",_fxcontent];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_Section && _Section.length && ![_Section isEqualToString:@""]) {
        if ([_Section containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_Section componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _Section = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"介入区间：%@",_Section];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_fxmoney && _fxmoney.length && ![_fxmoney isEqualToString:@""]) {
        if ([_fxmoney containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_fxmoney componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _fxmoney = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"分享时价：%@",_fxmoney];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    if (_zsmoney && _zsmoney.length && ![_zsmoney isEqualToString:@""]) {
        if ([_zsmoney containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_zsmoney componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _zsmoney = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"止损价格：%@",_zsmoney];
        temp = [temp stringByAppendingString:str];
        temp = [temp stringByAppendingString:@"<br />"];
    }
    
    
    if ([temp hasSuffix:@"<br />"]) {
        NSMutableString *mutableTemp = [[NSMutableString alloc] initWithString:temp];

        NSString *tempStr = [mutableTemp substringToIndex:mutableTemp.length-6];
        mutableTemp = [[NSMutableString alloc] initWithString:tempStr];
        [mutableTemp insertString:@"<div style=\"font-size:14px;color:#666666;\">" atIndex:0];
        temp = [NSString stringWithString:mutableTemp];
        temp = [temp stringByAppendingString:@"</div>"];
    }
    
    if (_mention && _mention.length && ![_mention isEqualToString:@""]) {
        if ([_mention containsString:@"\r\n\r\n\r\n\t"]) {
            NSArray *strArr = [_mention componentsSeparatedByString:@"\r\n\r\n\r\n\t"];
            _mention = [strArr componentsJoinedByString:@"<br />"];
        }
        NSString *str = [NSString stringWithFormat:@"%@",_mention];
        temp = [temp stringByAppendingString:str];
//        temp = [temp stringByAppendingString:@"<br />"];
    }
    
//    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    YYLog(@"返回的数据：------%@",temp);
    
    NSAttributedString *attrTemp = [[NSAttributedString alloc] initWithData:[temp dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.headIndent = 2.0;
//    paragraphStyle.lineSpacing = 2.0;
//    paragraphStyle.paragraphSpacing = 2.f;
    
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:attrTemp attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:TitleFont,NSForegroundColorAttributeName:SubTitleColor}];
    
    _attributeStr = attrTemp;
    _cellHeight = [self cellHeight];
    
    return attrTemp;
}


/**
 *  返回UILabel自适应后的size
 *
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定高度
 *
 *  @return CGSize
 */
//- (CGSize)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
//    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//    tempLabel.attributedText = aString;
//    tempLabel.numberOfLines = 0;
//    [tempLabel sizeToFit];
//    CGSize size = tempLabel.frame.size;
//    size = CGSizeMake(CGFloat_ceil(size.width), CGFloat_ceil(size.height));
//    return size;
//}

//- (BOOL)isHaveExtendBtn {
//    
//    if (self.cellHeight > 80) {
//        
//        return YES;
//    }else {
//        
//        return NO;
//    }
//}



- (CGFloat)cellHeight {
    
    if (_cellHeight && _cellHeight != 0.f && _lastExtendState == _extendState) {
        return _cellHeight;
    }
    _lastExtendState = _extendState;
    
    CGFloat height = [self sizeForAttributeString:[self pushAttributedString] font:TitleFont maxSize:CGSizeMake(kSCREENWIDTH-72, MAXFLOAT)].height;
    //返回的高度需考虑cell上部一个title的高度和底部的展开按钮高度 顶部30 底部20
//    CGSize size = [[self pushAttributedString] boundingRectWithSize:CGSizeMake(kSCREENWIDTH-72, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    YYLog(@"size ---- %@",NSStringFromCGSize(size));
    YYLog(@"推送文字高度 ---- %lf",height);
    
    CGFloat topH = 50;
    CGFloat bottomH = 30;
    if (self.extendState && height > 80) {//有展开按钮 并且是展开状态 且高度大于80
        
        _isHaveExtendBtn = YES;
        _cellHeight = height+bottomH+topH;
    }else if (height > 80 && !self.extendState){//有展开按钮 不是展开状态 且高度大于80
        
        _isHaveExtendBtn = YES;
        _cellHeight = 70+bottomH+topH;
    }else{
        
        _isHaveExtendBtn = NO;
        _cellHeight = height+topH+bottomH;
    }
    
    return _cellHeight;
}

- (NSString *)checktime {
    
    if (_transitCheckTime) {
        return _checktime;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = yyyyMMddHHmmss;
    NSDate *date = [formatter dateFromString:_checktime];
    formatter.dateFormat = @"HH:mm";
    NSString *checkStr = [formatter stringFromDate:date];
    _checktime = checkStr;
    _transitCheckTime = YES;
    return checkStr;
}

- (NSString *)keyword1 {
    if (_transitKeyword) {
        return _keyword1;
    }
    _keyword1 = [self keyWord:[_keyword1 integerValue]];
    return _keyword1;
}

/** 返回keywords*/
- (NSString *)keyWord:(NSInteger)key {
    //keyword1:5 早餐,6早评,7上午分享,8午评,9下午分享,10收评,11夜宵,12即时通知
    _transitKeyword = YES;
    switch (key) {
        case 5:
            return @"早餐";
            break;
            
        case 6:
            return @"早评";
            break;
            
        case 7:
            return @"上午分享";
            break;
            
        case 8:
            return @"午评";
            break;
            
        case 9:
            return @"下午分享";
            break;
            
        case 10:
            return @"收评";
            break;
            
        case 11:
            return @"夜宵";
            break;
            
        case 12:
            return @"即时通知";
            break;
        
        case 13:
            return @"风险提示";
            break;

        case 14:
            return @"获利提示";
            break;
            
        default:
            return @"";
            break;
    }
    
}


- (CGSize)sizeForAttributeString:(NSAttributedString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    //    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    /** 行高 */
    //    paraStyle.lineSpacing = 3;
    //    paraStyle.paragraphSpacing = 5;
    
//    NSDictionary *attrs = @{NSFontAttributeName:font};
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading |  NSStringDrawingUsesLineFragmentOrigin context:nil];
//    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading |  NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}


@end
