//
//  YYThreeSeekDetailCompanyModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekDetailCompanyModel.h"


@implementation YYThreeSeekDetailCompanyModel


- (NSString *)logo {
    if (![_logo containsString:@"http"]) {
        return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_logo];
    }
    return _logo;
}

- (CGFloat)introductionHeight {
    
    //段落样式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 5;
    //段落间距
    paragraph.paragraphSpacing = 10;
    //对齐方式
//    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    paragraph.headIndent = 10;
    
    
    return [_introduction boundingRectWithSize:CGSizeMake(kSCREENWIDTH-20, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SubTitleFont,NSParagraphStyleAttributeName:paragraph} context:nil].size.height;
    
}

- (CGFloat)trendcontentHeight {
    
    //段落样式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 5;
    //段落间距
    paragraph.paragraphSpacing = 10;
    //对齐方式
    //    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    paragraph.headIndent = 10;
    
    
    return [_trendcontent boundingRectWithSize:CGSizeMake(kSCREENWIDTH-20, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SubTitleFont,NSParagraphStyleAttributeName:paragraph} context:nil].size.height;
}

@end
