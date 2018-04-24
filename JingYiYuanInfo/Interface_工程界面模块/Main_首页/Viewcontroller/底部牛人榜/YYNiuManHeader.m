//
//  YYNiuManHeader.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/11.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManHeader.h"
#import "NSString+Size.h"

@interface YYNiuManHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *hotValueBtn;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceHeightConstraint;


@end

@implementation YYNiuManHeader
{
    NSAttributedString *_attrStr;
}
+ (instancetype)headerView {
    YYNiuManHeader *header = [[NSBundle mainBundle] loadNibNamed:@"NiuManHeader" owner:nil options:nil].firstObject;
    return header;
}


- (IBAction)closeOrOpen:(UIButton *)sender {
    
    CGFloat height =  self.bounds.size.height;
//    CGFloat width =  self.bounds.size.width;
    
//    CGSize size = [self.introduce sizeWithFont:sysFont(15) size:CGSizeMake(kSCREENWIDTH-60, MAXFLOAT)];

    CGSize size = [_attrStr boundingRectWithSize:CGSizeMake(kSCREENWIDTH-60, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;

    CGFloat sub = size.height-10;
    sender.selected = !sender.isSelected;
    if (size.height <= 18) {
        return;
    }
    if (sender.isSelected) {
        height += sub;
    }else {
        height -= sub;
    }
    self.openOrCloseBlock(sender.isSelected,height);
    
//    self.bounds = CGRectMake(0, 0, width, height);
}



- (void)setIcon:(NSString *)icon {
    _icon = icon;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:imageNamed(placeHolderAvatar)];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setHotVlaue:(NSString *)hotVlaue {
    _hotVlaue = hotVlaue;
    [self.hotValueBtn setTitle:hotVlaue forState:UIControlStateNormal];
}

- (void)setIntroduce:(NSString *)introduce {
    
    _introduce = introduce;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:introduce attributes:@{NSFontAttributeName:sysFont(15),NSForegroundColorAttributeName:WhiteColor}];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = imageNamed(@"niumanintroduce");
    attachment.bounds = CGRectMake(0, 0, 15, 14);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrString insertAttributedString:imageAttr atIndex:0];
    
    _attrStr = attrString;
    self.introduceLabel.attributedText = attrString;
    
}




@end
