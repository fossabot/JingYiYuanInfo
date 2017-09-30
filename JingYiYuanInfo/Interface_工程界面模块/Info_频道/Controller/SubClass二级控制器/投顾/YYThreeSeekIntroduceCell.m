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
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:introduce attributes:@{NSParagraphStyleAttributeName:paragraph}];
    self.introduceLabel.attributedText = attributeStr;
}


@end
