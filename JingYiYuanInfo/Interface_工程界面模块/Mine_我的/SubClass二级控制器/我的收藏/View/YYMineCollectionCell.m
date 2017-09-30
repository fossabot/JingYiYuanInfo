//
//  YYMineCollectionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineCollectionCell.h"
#import "YYMineCollectionModel.h"

@interface YYMineCollectionCell()

/** title*/
@property (nonatomic, strong) UILabel *title;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic;

/** source来源*/
@property (nonatomic, strong) UILabel *source;

/** time时间*/
@property (nonatomic, strong) UILabel *time;


@end


@implementation YYMineCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubview];
    }
    return self;
}

- (void)setModel:(YYMineCollectionModel *)model {
    _model = model;
    [self.newsPic sd_setImageWithURL:[NSURL URLWithString:model.col_img] placeholderImage:imageNamed(placeHolderMini)];
    self.title.text = model.col_title;
    self.source.text = model.col_type;
    self.time.text = model.col_time;
    
}


/**
 *  创建子控件
 */
- (void)configSubView {
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 2;
    [self.contentView addSubview:title];
    self.title = title;
    
    UIImageView *newsPic = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic];
    self.newsPic = newsPic;
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    [self.contentView addSubview:source];
    self.source = source;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    [self.contentView addSubview:time];
    self.time = time;
    
}

/**
 配置子控件的约束
 */
- (void)masonrySubview {
   
    [self.newsPic makeConstraints:^(MASConstraintMaker *make) {//图片的约束
        make.top.left.equalTo(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.contentView.bottom).offset(-YYInfoCellCommonMargin);
        make.width.equalTo(110);
        make.height.equalTo(70);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {//设置第一个cell的标题label约束
        
        make.top.equalTo(self.newsPic);
        make.left.equalTo(self.newsPic.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {//来源label的约束
        make.left.equalTo(self.newsPic.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.newsPic.bottom);
    }];
    
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {//时间label的约束
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.newsPic.bottom);
    }];

    
    
}


@end
