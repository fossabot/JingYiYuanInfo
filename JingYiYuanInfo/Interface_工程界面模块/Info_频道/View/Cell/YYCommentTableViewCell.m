//
//  YYCommentTableViewCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentTableViewCell.h"

@interface YYCommentTableViewCell()

/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/** 名称*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/** 时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/** 评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation YYCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.content.preferredMaxLayoutWidth = kSCREENWIDTH - YYInfoCellCommonMargin * 3 -30;
}

- (void)setModel:(YYInfoCommentModel *)model {
    _model = model;
    
    //将model的各个值赋给cell的控件
    
    
}


@end
