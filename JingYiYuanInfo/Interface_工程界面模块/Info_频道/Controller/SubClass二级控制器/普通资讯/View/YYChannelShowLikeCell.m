//
//  YYChannelShowLikeCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelShowLikeCell.h"
#import "YYEdgeLabel.h"
#import "YYShowLikeModel.h"
#import "UIView+YYCategory.h"

@interface YYChannelShowLikeCell()

/** imageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** time*/
@property (nonatomic, strong) UILabel *time;

/** place*/
@property (nonatomic, strong) UILabel *place;

/** 标签1*/
@property (nonatomic, strong) YYEdgeLabel *tag1;

/** 标签2*/
//@property (nonatomic, strong) YYEdgeLabel *tag2;

/** 标签3*/
//@property (nonatomic, strong) YYEdgeLabel *tag3;

/** 价格*/
@property (nonatomic, strong) UILabel *price;

/** sepatator*/
@property (nonatomic, strong) UIView *separator;


@end

@implementation YYChannelShowLikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
        [self masonrySubView];
        [self.leftImageView cutCornerRect:CGRectMake(0, 0, 120, 180) radius:3];
    }
    return self;
}

- (void)configSubView {
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 0;
    [self.contentView addSubview:title];
    self.title = title;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = SubTitleFont;
    time.textColor = SubTitleColor;
    [self.contentView addSubview:time];
    self.time = time;
    
    UILabel *place = [[UILabel alloc] init];
    place.font = SubTitleFont;
    place.textColor = SubTitleColor;
    [self.contentView addSubview:place];
    self.place = place;

    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.font = TagLabelFont;
    tag1.textColor = ThemeColor;
    tag1.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:tag1];
    self.tag1 = tag1;

//    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
//    tag2.font = SubTitleFont;
//    tag2.textColor = ThemeColor;
//    tag2.layer.borderColor = ThemeColor.CGColor;
//    [self.contentView addSubview:tag2];
//    self.tag2 = tag2;
//
//    YYEdgeLabel *tag3 = [[YYEdgeLabel alloc] init];
//    tag3.font = SubTitleFont;
//    tag3.textColor = ThemeColor;
//    tag3.layer.borderColor = ThemeColor.CGColor;
//    [self.contentView addSubview:tag3];
//    self.tag3 = tag3;
    
    UILabel *price = [[UILabel alloc] init];
    price.font = SubTitleFont;
    price.textColor = ThemeColor;
    [self.contentView addSubview:price];
    self.price = price;
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = GraySeperatorColor;
    self.separator = separator;
    [self.contentView addSubview:separator];
}


- (void)masonrySubView {
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(YYInfoCellCommonMargin);
        make.width.equalTo(120);
        make.height.equalTo(180);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.title.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
    }];
    
    [self.place makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.time.bottom).offset(5);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
    }];
    
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.leftImageView);
    }];
    
    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.price.top).offset(-YYInfoCellCommonMargin);
    }];
    
//    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.tag1.right).offset(YYInfoCellCommonMargin);
//        make.bottom.equalTo(self.price.top).offset(-2);
//    }];
//
//    [self.tag3 makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.tag2.right).offset(YYInfoCellCommonMargin);
//        make.bottom.equalTo(self.price.top).offset(-2);
//    }];
    
    [self.separator makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(-0.5);
        make.height.equalTo(0.5);
        make.left.equalTo(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
}


- (void)setLikeModel:(YYShowLikeModel *)likeModel {
    
    _likeModel = likeModel;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:likeModel.indeximg] placeholderImage:imageNamed(placeHolderMini)];
    self.title.text = likeModel.actionname;
    self.title.textColor = likeModel.selected ? UnenableTitleColor : TitleColor;
    self.time.text = likeModel.actiontime;
    self.place.text = likeModel.palace;
    self.price.text = likeModel.price;
    self.tag1.text = likeModel.tag;

}


@end
