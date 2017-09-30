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

@interface YYCompanyCell()

/** iamgeView公司logo*/
@property (nonatomic, strong) UIImageView *logoImageView;

/** companyName公司名称*/
@property (nonatomic, strong) UILabel *companyName;

/** regMoney注册资金*/
@property (nonatomic, strong) UILabel *regMoney;

/** part功能标签模型中用逗号分隔 1，2，3*/
@property (nonatomic, strong) YYEdgeLabel *tag1;

/** part功能标签*/
@property (nonatomic, strong) YYEdgeLabel *tag2;

/** part功能标签*/
@property (nonatomic, strong) YYEdgeLabel *tag3;

/** auth_tag认证标签*/
@property (nonatomic, strong) YYEdgeLabel *authTag;


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
    
    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.font = UnenableTitleFont;
    tag1.textColor = ThemeColor;
    tag1.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:tag1];
    self.tag1 = tag1;
    
    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
    tag2.font = UnenableTitleFont;
    tag2.textColor = ThemeColor;
    tag2.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:tag2];
    self.tag2 = tag2;

    YYEdgeLabel *tag3 = [[YYEdgeLabel alloc] init];
    tag3.font = UnenableTitleFont;
    tag3.textColor = ThemeColor;
    tag3.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:tag3];
    self.tag3 = tag3;
    
    YYEdgeLabel *authTag = [[YYEdgeLabel alloc] init];
    authTag.font = UnenableTitleFont;
    authTag.textColor = ThemeColor;
    authTag.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:authTag];
    self.authTag = authTag;
    
}


- (void)masonrySubView {
    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.width.equalTo(100);
        make.height.equalTo(70);
    }];
    
    [self.companyName makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoImageView);
        make.left.equalTo(self.logoImageView.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.regMoney makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.companyName);
        make.top.equalTo(self.companyName.bottom).offset(YYInfoCellSubMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.companyName);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.tag3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag2.right).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.authTag makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag3.right).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    
}


- (void)setCompanyModel:(YYCompanyModel *)companyModel {
    
    _companyModel = companyModel;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:companyModel.logo] placeholderImage:imageNamed(@"placeholder")];
    self.companyName.text = companyModel.gname;
    self.regMoney.text = companyModel.regmoney;
    
    /*
//    if (companyModel.part.length) {
//        if ([companyModel.part containsString:@" "]) {
//            
//            NSArray *keywords = [companyModel.part componentsSeparatedByString:@" "];
//            self.tag1.text = [self part:keywords[0] comType:companyModel.comtype];
//            self.tag2.text = [self part:keywords[1] comType:companyModel.comtype];
//            if (keywords.count >=3) {
//                self.tag3.text = [self part:keywords[2] comType:companyModel.comtype];
//            }else {
//                [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.tag2.right).offset(YYInfoCellSubMargin);
//                }];
//            }
//        }else if ([companyModel.part containsString:@"，"]){
//
//            NSArray *keywords = [companyModel.part componentsSeparatedByString:@"，"];
//            self.tag1.text = [self part:keywords[0] comType:companyModel.comtype];
//            self.tag2.text = [self part:keywords[1] comType:companyModel.comtype];
//            if (keywords.count >=3) {
//                self.tag3.text = [self part:keywords[2] comType:companyModel.comtype];
//            }else{
//                [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.tag2.right).offset(YYInfoCellSubMargin);
//                }];
//            }
//        }else{
//            self.tag1.text = [self part:companyModel.part comType:companyModel.comtype];
//            [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.tag1.right).offset(YYInfoCellSubMargin);
//            }];
//        }
//    }else{
//        [self.authTag updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.companyName);
//        }];
//    }
   */
    
    if (companyModel.part.length) {
        NSArray *keywords = nil;
        if ([companyModel.part containsString:@" "]) {
            
            keywords = [companyModel.part componentsSeparatedByString:@" "];
            [self dispatchTags:keywords comType:companyModel.comtype];
        }else if ([companyModel.part containsString:@"，"]){
            
            keywords = [companyModel.part componentsSeparatedByString:@"，"];
            [self dispatchTags:keywords comType:companyModel.comtype];
        }else {
            
            [self.tag2 updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(0);
                make.left.equalTo(self.tag1.right);
            }];
            [self.tag3 updateConstraints:^(MASConstraintMaker *make) {
               
                make.width.equalTo(0);
                make.left.equalTo(self.tag2.right);
            }];
        }
    }
    
    self.authTag.text = companyModel.auth_tag;
}

- (void)dispatchTags:(NSArray *)keywords comType:(NSString *)comtype {
    self.tag1.text = [self part:keywords[0] comType:comtype];
    self.tag2.text = [self part:keywords[1] comType:comtype];
    if (keywords.count < 3) {

        [self.tag3 updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tag2.right);
            make.width.equalTo(0);
        }];
    }else{
        
        self.tag3.text = [self part:keywords[2] comType:comtype];
    }
}

/** 功能标签 根据公司类型来确定相应的功能标签*/
- (NSString *)part:(NSString *)part comType:(NSString *)comType {
    
    NSDictionary *dic = [self.partDic objectForKey:comType];
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
