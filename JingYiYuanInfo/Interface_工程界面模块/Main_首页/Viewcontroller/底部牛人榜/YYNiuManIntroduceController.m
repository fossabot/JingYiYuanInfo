//
//  YYNiuManIntroduceController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/17.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManIntroduceController.h"
#import "UIView+YYCategory.h"

@interface YYNiuManIntroduceController ()

/** bgImageView*/
@property (nonatomic, strong) UIImageView *bgImageView;

/** name*/
@property (nonatomic, strong) UILabel *name;

/** icon*/
@property (nonatomic, strong) UIImageView *icon;

/** hotValue*/
@property (nonatomic, strong) UIButton *hotValue;

/** separatorView*/
@property (nonatomic, strong) UIView *separatorView;

/** 个人简介四个字*/
@property (nonatomic, strong) UILabel *gerenjianjie;

/** introduce*/
@property (nonatomic, strong) UILabel *introduce;

@end

@implementation YYNiuManIntroduceController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.stableWidth = kSCREENWIDTH;
    [self configSubviews];
    [self masonrySubviews];
    YYLogFunc;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.name.text = self.niu_name;
    [self.hotValue setTitle:self.niu_pop forState:UIControlStateNormal];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.niu_img] placeholderImage:imageNamed(@"placeHolderAvatar")];
    self.introduce.text = self.niu_introduce;
    [self.icon cutRoundView];
}



- (void)configSubviews {
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    UIImage *image = imageNamed(@"niuIntrduceBgImage");
    bgImageView.image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:50];
//    [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [self.baseScrollView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UILabel *name = [[UILabel alloc] init];
    name.font = sysFont(25);
    name.textColor = BlackColor;
    [self.baseScrollView addSubview:name];
    self.name = name;
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self.baseScrollView addSubview:icon];
    self.icon = icon;
    
    UIButton *hotValue = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotValue setImage:imageNamed(@"fire") forState:UIControlStateNormal];
    hotValue.userInteractionEnabled = NO;
    hotValue.titleLabel.font = TitleFont;
    [hotValue setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [self.baseScrollView addSubview:hotValue];
    self.hotValue = hotValue;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = LightGraySeperatorColor;
    [self.baseScrollView addSubview:separatorView];
    self.separatorView = separatorView;
    
    UILabel *gerenjianjie = [[UILabel alloc] init];
    gerenjianjie.textColor = TitleColor;
    gerenjianjie.font = NavTitleFont;
    gerenjianjie.text = @"个人简介";
    [self.baseScrollView addSubview:gerenjianjie];
    self.gerenjianjie = gerenjianjie;
    
    UILabel *introduce = [[UILabel alloc] init];
    introduce.numberOfLines = 0;
    introduce.textColor = SubTitleColor;
    introduce.font = TitleFont;
    [self.baseScrollView addSubview:introduce];
    self.introduce = introduce;
}


- (void)masonrySubviews {
    
    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(YYInfoCellCommonMargin);
        make.left.equalTo(self.view).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.view).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(30);
        make.left.equalTo(self.bgImageView).offset(YYCommonCellLeftMargin);
    }];
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.name);
        make.right.equalTo(self.bgImageView).offset(-YYCommonCellLeftMargin);
        make.width.height.equalTo(80);
    }];
    
    [self.hotValue makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.bottom).offset(30);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.hotValue);
        make.right.equalTo(self.icon);
        make.height.equalTo(1);
        make.top.equalTo(self.hotValue.bottom).offset(YYNewsCellTopMargin);
    }];
    
    [self.gerenjianjie makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.separatorView);
        make.top.equalTo(self.separatorView.bottom).offset(YYNewsCellTopMargin);
    }];

    [self.introduce makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.gerenjianjie);
        make.top.equalTo(self.gerenjianjie.bottom).offset(YYNewsCellTopMargin);
        make.right.equalTo(self.separatorView.right);
        make.bottom.equalTo(self.bgImageView.bottom).offset(-30);
    }];
    
//    [self.bgImageView updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.introduce.bottom).offset(30);
//    }];
    
}



@end
