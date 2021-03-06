//
//  YYSubscribeCell.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/16.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSubscribeCell.h"
#import "YYNiuSubscribeModel.h"
#import "UIView+YYCategory.h"

@interface YYSubscribeCell()

@property (nonatomic, strong) UIImageView *niuImageView;

@property (nonatomic, strong) UILabel *niuName;

@property (nonatomic, strong) UILabel *niuIntroduce;

@property (nonatomic, strong) UILabel *niuPostTime;

@end



@implementation YYSubscribeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
    }
    return self;
}



- (void)configSubView {
    
    UIView *cellSeparator = [[UIView alloc] init];
    cellSeparator.backgroundColor = GraySeperatorColor;
    [self.contentView addSubview:cellSeparator];
    
    UIImageView *niuImageView = [[UIImageView alloc] init];
    self.niuImageView = niuImageView;
    [self.contentView addSubview:niuImageView];
    
    UILabel *niuIntroduce = [[UILabel alloc] init];
    niuIntroduce.numberOfLines = 2;
    niuIntroduce.textColor = TitleColor;
    niuIntroduce.font = TitleFont;
    self.niuIntroduce = niuIntroduce;
    [self.contentView addSubview:niuIntroduce];
    
    UILabel *niuName = [[UILabel alloc] init];
    niuName.textColor = SubTitleColor;
    niuName.font = UnenableTitleFont;
    self.niuName = niuName;
    [self.contentView addSubview:niuName];
    
    UILabel *niuPostTime = [[UILabel alloc] init];
    niuPostTime.textColor = UnenableTitleColor;
    niuPostTime.font = UnenableTitleFont;
    self.niuPostTime = niuPostTime;
    [self.contentView addSubview:niuPostTime];
    
    //底部分隔线的约束
    [cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-0.5);
        make.left.equalTo(self.contentView.left).offset(YYCommonCellLeftMargin);
        make.right.equalTo(self.contentView.right).offset(-YYCommonCellLeftMargin);
        make.height.equalTo(0.5);
    }];
    
    [self.niuImageView makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(YYNewsCellTopMargin);
        make.left.top.equalTo(YYCommonCellLeftMargin);
        make.width.height.equalTo(80);
    }];
    
    [self.niuIntroduce makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.niuImageView.right).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.niuImageView);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.niuName makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.niuImageView.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.niuImageView);
    }];

    
    [self.niuPostTime makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.niuImageView);
    }];

    [self layoutIfNeeded];
}


- (void)setModel:(YYNiuSubscribeModel *)model {
    
    _model = model;
    [self.niuImageView sd_setImageWithURL:[NSURL URLWithString:model.niu_head] placeholderImage:imageNamed(placeHolderMini)];
    self.niuIntroduce.text = model.niu_introduction;
    self.niuName.text = model.niu_name;
    self.niuPostTime.text = model.posttime;
    [self.niuImageView cutRoundView];
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    [self.niuImageView cutRoundView];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [self.niuImageView cutRoundView];
}



@end
