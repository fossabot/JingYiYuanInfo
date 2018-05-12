//
//  YYOrderPushListCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/30.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYOrderPushListCell.h"

@interface YYOrderPushListCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation YYOrderPushListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backView.layer.borderWidth = 1.f;
//    self.backView.layer.borderColor = ThemeColor.CGColor;
    
}


/** 查看股票详情*/
- (IBAction)checkDetail:(UIButton *)sender {
 
    if (_recordDetailBlock) {
        _recordDetailBlock(self);
    }
    
}


- (IBAction)checkYanbao:(UIButton *)sender {
    
    if (_yanbaoBlock) {
        _yanbaoBlock();
    }
}


@end
