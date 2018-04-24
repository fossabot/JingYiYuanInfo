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

static const CGFloat margin = 7;
static const CGFloat contentPadding = 16;

@interface YYMineOrderCell()

@property (nonatomic, strong) UIImageView *container;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *state;

@property (nonatomic, strong) UILabel *orderId;

@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UILabel *expireTime;

@property (nonatomic, strong) UILabel *money;

@property (nonatomic, strong) UILabel *buyTime;

/** 研报按钮*/
@property (nonatomic, strong) UIButton *moreBtn;


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
    container.userInteractionEnabled = YES;
    container.image = imageNamed(@"yyfw_mine_orderBackImage_60x60");
    container.contentMode = UIViewContentModeScaleToFill;
    self.container = container;
    [self.contentView addSubview:container];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = TitleColor;
    title.font = TitleFont;
    self.title = title;
    [self.container addSubview:title];
    
    UILabel *state = [[UILabel alloc] init];
    state.textColor = ThemeColor;
    state.font = TitleFont;
    state.textAlignment = NSTextAlignmentRight;
    self.state = state;
    [self.container addSubview:state];
    
    UILabel *orderId = [[UILabel alloc] init];
    orderId.textColor = TitleColor;
    orderId.font = TitleFont;
    self.orderId = orderId;
    [self.container addSubview:orderId];
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = TitleColor;
    price.font = TitleFont;
    self.price = price;
    [self.container addSubview:price];
    
    UILabel *expireTime = [[UILabel alloc] init];
    expireTime.textColor = TitleColor;
    expireTime.font = TitleFont;
    self.expireTime = expireTime;
    [self.container addSubview:expireTime];
    
    UILabel *money = [[UILabel alloc] init];
    money.textColor = TitleColor;
    money.font = TitleFont;
    self.money = money;
    [self.container addSubview:money];
    
    UILabel *buyTime = [[UILabel alloc] init];
    buyTime.textColor = TitleColor;
    buyTime.font = TitleFont;
    self.buyTime = buyTime;
    [self.container addSubview:buyTime];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:imageNamed(@"more") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(checkMore) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    UIButton *cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelOrderBtn.backgroundColor = ClearColor;
    [cancelOrderBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    [cancelOrderBtn setTitleColor:UnenableTitleColor forState:UIControlStateDisabled];
    cancelOrderBtn.titleLabel.font = sysFont(12);
    cancelOrderBtn.layer.borderColor = UnenableTitleColor.CGColor;
    cancelOrderBtn.layer.borderWidth = 1;
    cancelOrderBtn.layer.cornerRadius = 2;
    [cancelOrderBtn setTitle:@"申请终止服务" forState:UIControlStateNormal];
    [cancelOrderBtn addTarget:self action:@selector(cancelThisOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:cancelOrderBtn];
    self.cancelOrderBtn = cancelOrderBtn;
    
}


- (void)masonrySubView {
    
    [self.container makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(YYInfoCellCommonMargin, 5, 5, YYInfoCellCommonMargin));
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(contentPadding);
        make.right.equalTo(self.state.left).offset(-YYInfoCellSubMargin);
    }];
    
    [self.state makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-contentPadding);
        make.top.equalTo(contentPadding);
    }];
    
    [self.orderId makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom).offset(margin);
        make.left.equalTo(self.title);
    }];
    
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.orderId.bottom).offset(margin);
        make.left.equalTo(self.title);
    }];
    
    [self.expireTime makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.price.bottom).offset(margin);
        make.left.equalTo(self.title);
    }];
    
    [self.money makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.expireTime.bottom).offset(margin);
        make.left.equalTo(self.title);
    }];
    
    [self.buyTime makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.money.bottom).offset(margin);
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.container).offset(-contentPadding);
    }];
    
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(-contentPadding);
        make.centerY.equalTo(self.container);
    }];
    
    [self.cancelOrderBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-contentPadding);
        make.centerY.equalTo(self.buyTime);
        make.width.equalTo(90);
        make.height.equalTo(20);
    }];
    
}


- (void)setModel:(YYOrderModel *)model {
    
    _model = model;
    
    self.title.text = model.packname;
    self.state.text = @"支付完成";
    self.orderId.text = model.unique_ordernum;
    self.price.text = model.price;
    self.expireTime.text = model.expireCalculate;
    self.money.text = model.cost;
    self.buyTime.text = model.buytime;
    if ([model.packname isEqualToString:@"产品:365会员"]) {
        self.cancelOrderBtn.hidden = YES;
        return;
    }else {
        self.cancelOrderBtn.hidden = NO;
    }
    NSString *cancelState;
    BOOL cancelEnable = YES;
    if ([model.paystatus isEqualToString:@"3"]) {//退单中
        cancelState = @"申请中";
        cancelEnable = YES;
        [self.cancelOrderBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(50);
        }];
    }else if ([model.paystatus isEqualToString:@"4"]) {
        cancelState = @"已终止";
        cancelEnable = NO;
        [self.cancelOrderBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(50);
        }];
    }else if ([model.paystatus isEqualToString:@"5"]) {
        cancelState = @"已结束服务";
        cancelEnable = NO;
        [self.cancelOrderBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(75);
        }];
    }else {
        cancelState = @"申请终止服务";
        cancelEnable = YES;
        [self.cancelOrderBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(90);
        }];
    }
    
    self.cancelOrderBtn.enabled = cancelEnable;
    [self.cancelOrderBtn setTitle:cancelState forState:UIControlStateNormal];
}

/** 查看研报*/
- (void)checkMore {
    
    if (_moreBlock) {
        _moreBlock(_model.orderId);
    }
}


/** 取消订单*/
- (void)cancelThisOrder {
    
    if (_cancelOrderBlcok) {
        _cancelOrderBlcok(_model.orderId,_model.packname,self);
    }
}
@end
