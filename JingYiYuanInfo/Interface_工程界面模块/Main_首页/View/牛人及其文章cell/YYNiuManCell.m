//
//  YYNiuManCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManCell.h"
#import "YYNiuManModel.h"
#import "YYEdgeLabel.h"

@interface YYNiuManCell()

/** 牛人排序*/
@property (nonatomic, strong) UIButton *indexButton;

/** 牛人头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 牛人名称*/
@property (nonatomic, strong) UILabel *name;

/** 牛人定位*/
@property (nonatomic, strong) UILabel *niutag;

/** 牛人更新时间*/
@property (nonatomic, strong) YYEdgeLabel *modtime;

/** 牛人介绍*/
@property (nonatomic, strong) UILabel *introduce;

/** 牛人人气值三个字*/
@property (nonatomic, strong) UILabel *renqizhi;

/** 牛人人气值数值*/
@property (nonatomic, strong) UILabel *renqiValue;

/** 牛人上升图*/
@property (nonatomic, strong) UIImageView *upImage;


/** 排行*/
@property (nonatomic, assign) NSInteger index;

@end

@implementation YYNiuManCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子控件
        [self createSubview];
        
        //添加约束
        [self configAutoLayout];
        
    }
    return self;
}


/**
 *  控件赋值
 */
- (void)setNiuManModel:(YYNiuManModel *)niuManModel andIndex:(NSInteger)index {
    _niuManModel = niuManModel;
    [_icon sd_setImageWithURL:urlString(niuManModel.niu_img) placeholderImage:nil];
    _name.text = niuManModel.niu_name;
    _niutag.text = niuManModel.niu_tag;
//    _modtime.text = niuManModel.niu_modtime;
    _introduce.text = niuManModel.niu_introduce;
    _renqiValue.text = niuManModel.niu_pop;
    
    _index = index;
    switch (index) {
        case 0:
            [_indexButton setImage:imageNamed(@"yyfw_main_first_40x40_") forState:UIControlStateNormal];
            break;
            
        case 1:
            [_indexButton setImage:imageNamed(@"yyfw_main_second_40x40_") forState:UIControlStateNormal];
            break;
            
        case 2:
            [_indexButton setImage:imageNamed(@"yyfw_main_third_40x40_") forState:UIControlStateNormal];
            break;
            
        default:
            [_indexButton setTitle:[NSString stringWithFormat:@"%ld.",index+1] forState:UIControlStateNormal];
            break;
    }

}


- (void)setNiuManModel:(YYNiuManModel *)niuManModel {
    
    _niuManModel = niuManModel;
    [_icon sd_setImageWithURL:urlString(niuManModel.niu_img) placeholderImage:nil];
    _name.text = niuManModel.niu_name;
    _niutag.text = niuManModel.niu_tag;
//    _modtime.text = niuManModel.niu_modtime;
    _introduce.text = niuManModel.niu_introduce;
    _renqiValue.text = niuManModel.niu_pop;
    [_indexButton updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(5);
        make.width.equalTo(0);
    }];
}

/**
 *  创建子控件
 */
- (void)createSubview {
    
    
    UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    indexButton.userInteractionEnabled = NO;
    indexButton.titleLabel.font = SubTitleFont;
    indexButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:indexButton];
    self.indexButton = indexButton;
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    UILabel *name = [[UILabel alloc] init];
    name.font = TitleFont;
    name.textColor = TitleColor;
    [self.contentView addSubview:name];
    self.name = name;
    
    UILabel *niutag = [[UILabel alloc] init];
    niutag.font = SubTitleFont;
    niutag.textColor = UnenableTitleColor;
    niutag.numberOfLines = 1;
    [self.contentView addSubview:niutag];
    self.niutag = niutag;
    
    YYEdgeLabel *modtime = [[YYEdgeLabel alloc] init];
    modtime.font = UnenableTitleFont;
    modtime.textColor = UnenableTitleColor;
    modtime.layer.borderWidth = 0.5;
    modtime.layer.borderColor = UnenableTitleColor.CGColor;
    modtime.layer.cornerRadius = 2;
    [self.contentView addSubview:modtime];
    self.modtime = modtime;
    
    UILabel *introduce = [[UILabel alloc] init];
    introduce.font = SubTitleFont;
    introduce.textColor = TitleColor;
    introduce.numberOfLines = 1;
    [self.contentView addSubview:introduce];
    self.introduce = introduce;
   
    UILabel *renqizhi = [[UILabel alloc] init];
    renqizhi.font = SubTitleFont;
    renqizhi.textColor = UnenableTitleColor;
    renqizhi.text = @"人气值";
    [self.contentView addSubview:renqizhi];
    self.renqizhi = renqizhi;
    
    UILabel *renqiValue = [[UILabel alloc] init];
    renqiValue.font = SubTitleFont;
    renqiValue.textColor = ThemeColor;
    renqiValue.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:renqiValue];
    self.renqiValue = renqiValue;
    
    UIImageView *upImage = [[UIImageView alloc] init];
    upImage.image = imageNamed(@"yyfw_main_up_20x20_");
    [self.contentView addSubview:upImage];
    self.upImage = upImage;


}

/**
 *  添加约束
 */
- (void)configAutoLayout {
    
    [self.indexButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.width.equalTo(25);
    }];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indexButton.right).offset(YYInfoCellSubMargin);
        make.top.equalTo(self.indexButton);
        make.height.equalTo(96);
        make.width.equalTo(72);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.top);
        make.left.equalTo(self.icon.right).offset(YYInfoCellCommonMargin);
    }];
    
    [self.niutag makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.bottom);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin*4);
        make.left.equalTo(self.name.left);
    }];
    
    [self.introduce makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.left);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.icon.bottom);
        make.bottom.equalTo(self.contentView.bottom).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.modtime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.left);
        make.bottom.equalTo(self.introduce.top);
    }];
    
    [self.renqizhi makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.top);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.upImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.renqizhi.bottom);
        make.right.equalTo(self.renqizhi.right);
        make.width.height.equalTo(15);
    }];
    [self.renqiValue makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.renqizhi.bottom);
        make.centerY.equalTo(self.upImage);
        make.right.equalTo(self.upImage.left);
    }];
    
    
}



@end
