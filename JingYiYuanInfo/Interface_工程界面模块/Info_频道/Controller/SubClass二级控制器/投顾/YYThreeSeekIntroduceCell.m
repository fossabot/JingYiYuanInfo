//
//  YYThreeSeekIntroduceCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekIntroduceCell.h"

@interface YYThreeSeekIntroduceCell()

/** introduce*/
@property (nonatomic, strong) UILabel *introduceLabel;

@end

@implementation YYThreeSeekIntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.introduceLabel = [[UILabel alloc] init];
        self.introduceLabel.numberOfLines = 0;
        self.introduceLabel.font = SubTitleFont;
        [self.contentView addSubview:self.introduceLabel];
        [self.introduceLabel makeConstraints:^(MASConstraintMaker *make) {
           
//            make.left.top.equalTo(10);
//            make.right.bottom.equalTo(-10);
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
    }
    return self;
}

- (void)setIntroduce:(NSString *)introduce {
    
    if (!introduce) {
        self.introduceLabel.text = @"";
        return;
    }
    
    _introduce = introduce;
    //NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:introduce attributes:@{NSParagraphStyleAttributeName:paragraph}];
    //NSString *strHtml = @"<b>提示</b><br/>1、测试测试测试测试测试测试测试测试测试测试测试测试<br/>2、测试测试测试测试测试测试测试测试测试测试";
    
    
    NSString *replaceStr = [NSString stringWithFormat:@"<img width=\"%lfpx\"",kSCREENWIDTH-20];
    [introduce stringByReplacingOccurrencesOfString:@"<img" withString:replaceStr];
    NSAttributedString * attributeStr = [[NSAttributedString alloc] initWithData:[introduce dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSBaselineOffsetAttributeName : @(5) } documentAttributes:nil error:nil];
    self.introduceLabel.attributedText = attributeStr;
    
}



@end
