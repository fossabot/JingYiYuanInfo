//
//  YYCompanyCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCompanyCell.h"
#import "YYEdgeLabel.h"
#import "YYCompanyModel.h"
#import "YYTagView.h"

@interface YYCompanyCell()

/** iamgeView公司logo*/
@property (nonatomic, strong) UIImageView *logoImageView;

/** companyName公司名称*/
@property (nonatomic, strong) UILabel *companyName;

/** regMoney注册资金*/
@property (nonatomic, strong) UILabel *regMoney;

/** part功能标签模型中用逗号分隔 1，2，3*/
@property (nonatomic, strong) YYTagView *tagView1;

/** part功能标签*/
@property (nonatomic, strong) YYTagView *tagView2;

/** part功能标签*/
@property (nonatomic, strong) YYTagView *tagView3;

/** auth_tag认证标签*/
@property (nonatomic, strong) YYTagView *authTagView;


/** 功能标签的数组*/
@property (nonatomic, strong) NSMutableDictionary *partDic;

@end


@implementation YYCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
        [self masonrySubView];
    }
    return self;
}

/** 配置子控件*/
- (void)configSubView {
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *companyName = [[UILabel alloc] init];
    companyName.font = TitleFont;
    [self.contentView addSubview:companyName];
    self.companyName = companyName;
    
    UILabel *regMoney = [[UILabel alloc] init];
    regMoney.font = UnenableTitleFont;
    regMoney.textColor = UnenableTitleColor;
    [self.contentView addSubview:regMoney];
    self.regMoney = regMoney;
    
    YYTagView *tagView1 = [[YYTagView alloc] init];
    tagView1.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tagView1];
    self.tagView1 = tagView1;
    
    YYTagView *tagView2 = [[YYTagView alloc] init];
    tagView2.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tagView2];
    self.tagView2 = tagView2;

    YYTagView *tagView3 = [[YYTagView alloc] init];
    tagView3.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tagView3];
    self.tagView3 = tagView3;
    
    YYTagView *authTagView = [[YYTagView alloc] init];
    authTagView.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:authTagView];
    self.authTagView = authTagView;
    
}


- (void)masonrySubView {
    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(YYInfoCellCommonMargin);
        make.left.equalTo(YYCommonCellLeftMargin);
        make.width.equalTo(100);
        make.height.equalTo(70);
    }];
    
    [self.companyName makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoImageView);
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYCommonCellRightMargin);
    }];
    
    [self.regMoney makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.companyName);
        make.top.equalTo(self.companyName.bottom).offset(YYInfoCellSubMargin);
        make.right.equalTo(-YYCommonCellRightMargin);
    }];
    
    [self.tagView1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.tagView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagView1.right);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.tagView3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagView2.right);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.authTagView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagView3.right);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    
}


- (void)setCompanyModel:(YYCompanyModel *)companyModel {
    
    _companyModel = companyModel;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:companyModel.logo] placeholderImage:imageNamed(@"placeholder")];
    self.companyName.text = companyModel.gname;
    self.regMoney.text = companyModel.regmoney;
    
    if (![companyModel.part isEqualToString:@""]) {//1,2,3
        NSArray *keywords = nil;
        if ([companyModel.part containsString:@" "]) {
            
            keywords = [companyModel.part componentsSeparatedByString:@" "];
            [self dispatchTags:keywords comType:companyModel.comtype];
        }else if ([companyModel.part containsString:@","]){
            
            keywords = [companyModel.part componentsSeparatedByString:@","];
            [self dispatchTags:keywords comType:companyModel.comtype];
        }else {
            
            self.tagView1.title = [self part:companyModel.part comType:companyModel.comtype];
            self.tagView2.title = @"";
            self.tagView3.title = @"";
//            [self.tag2 updateConstraints:^(MASConstraintMaker *make) {
//
//                make.width.equalTo(0);
//                make.left.equalTo(self.tag1.right);
//            }];
//            [self.tag3 updateConstraints:^(MASConstraintMaker *make) {
//
//                make.width.equalTo(0);
//                make.left.equalTo(self.tag2.right);
//            }];
//
//            [self.authTag makeConstraints:^(MASConstraintMaker *make) {
//
//                make.left.equalTo(self.tag1.right).offset(YYInfoCellSubMargin);
//            }];
            
        }
    }else{//0
        self.tagView1.title = @"";
        self.tagView2.title = @"";
        self.tagView3.title = @"";
//        [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
//        }];
    }
    
    self.authTagView.title = companyModel.auth_tag;
    
    [self.tagView1 setNeedsLayout];
    [self.tagView2 setNeedsLayout];
    [self.tagView3 setNeedsLayout];
    [self.authTagView setNeedsLayout];
//    if (![companyModel.auth_tag isEqualToString:@""]) {
//    }else {
//        [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//
//            make.width.equalTo(0);
//        }];
//    }
}

- (void)dispatchTags:(NSArray *)keywords comType:(NSString *)comtype {
    self.tagView1.title = [self part:keywords[0] comType:comtype];
    self.tagView2.title = [self part:keywords[1] comType:comtype];
    if (keywords.count >= 3) {
        self.tagView3.title = [self part:keywords[2] comType:comtype];
    }else {
        self.tagView3.title = @"";
    }
//    if (keywords.count < 3) {//2

//        [self.authTagView updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.tag2.right).offset(YYInfoCellSubMargin);
//        }];
//    }else{//3
//
//        self.tagView3.title = [self part:keywords[2] comType:comtype];
//    }
}

/** 功能标签 根据公司类型来确定相应的功能标签*/
- (NSString *)part:(NSString *)part comType:(NSString *)comType {
    
    NSDictionary *dic = [[self partDic] objectForKey:comType];
    NSString *function = [dic objectForKey:part];
    return function;
}

- (NSMutableDictionary *)partDic{
    if (!_partDic) {
        _partDic = [NSMutableDictionary dictionary];
        [_partDic setObject:@{@"1":@"荐股",@"2":@"工具",@"3":@"方法"} forKey:@"投顾"];
        [_partDic setObject:@{@"1":@"QDII/QFII",@"2":@"交易",@"3":@"资管"} forKey:@"券商"];
        [_partDic setObject:@{@"1":@"股票型",@"2":@"货币型",@"3":@"债券型"} forKey:@"基金"];
    }
    return _partDic;
}

@end
