//
//  YYMineOrderCell.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineOrderCell.h"
#import "YYOrderModel.h"
#import "UIView+YYCategory.h"

@interface YYMineOrderCell()

@property (nonatomic, strong) UIImageView *container;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *state;

@property (nonatomic, strong) UILabel *orderId;

@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UILabel *expireTime;

@property (nonatomic, strong) UILabel *money;

@property (nonatomic, strong) UILabel *buyTime;

@end

@implementation YYMineOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubView];
    }
    return self;
}


- (void)configSubView {
    
    UIImageView *container = [[UIImageView alloc] init];
//    container.layer.shadowOffset = CGSizeMake(0, -3);
    container.image = imageNamed(@"yyfw_mine_orderBackImage_60x60");
    container.contentMode = UIViewContentModeScaleToFill;
    self.container = container;
    [self.contentView addSubview:container];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = TitleColor;
    title.font = SubTitleFont;
    self.title = title;
    [self.container addSubview:title];
    
    UILabel *state = [[UILabel alloc] init];
    state.textColor = TitleColor;
    state.font = SubTitleFont;
    self.state = state;
    [self.container addSubview:state];
    
    UILabel *orderId = [[UILabel alloc] init];
    orderId.textColor = TitleColor;
    orderId.font = SubTitleFont;
    self.orderId = orderId;
    [self.container addSubview:orderId];
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = TitleColor;
    price.font = SubTitleFont;
    self.price = price;
    [self.container addSubview:price];
    
    UILabel *expireTime = [[UILabel alloc] init];
    expireTime.textColor = TitleColor;
    expireTime.font = SubTitleFont;
    self.expireTime = expireTime;
    [self.container addSubview:expireTime];
    
    UILabel *money = [[UILabel alloc] init];
    money.textColor = TitleColor;
    money.font = SubTitleFont;
    self.money = money;
    [self.container addSubview:money];
    
    UILabel *buyTime = [[UILabel alloc] init];
    buyTime.textColor = TitleColor;
    buyTime.font = SubTitleFont;
    self.buyTime = buyTime;
    [self.container addSubview:buyTime];
    
}


- (void)masonrySubView {
    
    [self.container makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 10));
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(5);
//        make.top.equalTo(YYInfoCellCommonMargin);
    }];
    
    [self.state makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-5);
        make.top.equalTo(5);
        
    }];
    
    
    [self.orderId makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom).offset(5);
        make.left.equalTo(self.title);
    }];
    
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderId.bottom).offset(5);
        make.left.equalTo(self.title);
    }];
    
    [self.expireTime makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.price.bottom).offset(5);
        make.left.equalTo(self.title);
    }];
    
    [self.money makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.expireTime.bottom).offset(5);
        make.left.equalTo(self.title);
    }];
    
    [self.buyTime makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.money.bottom).offset(5);
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.container).offset(-5);
    }];
    
}


- (void)setModel:(YYOrderModel *)model {
    
    _model = model;
    self.title.text = model.packname;
    self.state.text = @"支付完成";
    self.orderId.text = model.ordernum;
    self.price.text = model.price;
    self.expireTime.text = model.expireCalculate;
    self.money.text = model.cost;
    self.buyTime.text = model.buytime;
}

//- (void)didMoveToWindow {
//    
//    [self.container cutRoundViewRadius:5];
//}


@end
