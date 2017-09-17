//
//  YYMineHeaderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineHeaderView.h"

#import "YYLoginViewController.h"
#import "YYSettingViewController.h"
#import "YYMineIntegrationViewController.h"

#import "YYSignBgView.h"
#import "YYUser.h"
#import "YYPlaceHolderView.h"

#import "UIView+YYViewFrame.h"


@interface YYMineHeaderView ()

@property (nonatomic, assign) BOOL isLogin;

/** 登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginIcon;
/** 会员状态的图片（365与非365）*/
@property (weak, nonatomic) IBOutlet UIImageView *VIPStatusIcon;
/** 名字*/
@property (weak, nonatomic) IBOutlet UILabel *name;

/** 积分*/
@property (weak, nonatomic) IBOutlet UILabel *integration;
/** VIP到期时间*/
@property (weak, nonatomic) IBOutlet UILabel *VIPTime;


/** signView*/
@property (nonatomic, strong) YYSignBgView *signView;

@end

@implementation YYMineHeaderView

+ (instancetype)headerView{
    
    YYMineHeaderView *headView = [[[NSBundle mainBundle] loadNibNamed:@"YYMineHeaderXibView" owner:nil options:nil] firstObject];
    
    return headView;
    
}

// 切圆角
- (void)cutRoundView:(UIImageView *)imageView
{
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self addSubview:self.signView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self cutRoundView:self.loginIcon.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _signView.frame = CGRectMake(kSCREENWIDTH-signW, self.yy_height-signH, signW, signH);
}

/** 更新个人信息*/
- (void)setUser:(YYUser *)user {
    _user = user;
    
    _name.text = [NSString stringWithFormat:@"姓名:%@",user.mobile];
    [_loginIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:imageNamed(@"yyfw_mine_unloginicon_83x83_")];
    _integration.text = [NSString stringWithFormat:@"积分:暂无积分"];
    if ([user.groupid containsString:@"3"]) {
        _VIPTime.text = [NSString stringWithFormat:@"会员:%@到期",user.expiretime];
        _VIPStatusIcon.image = imageNamed(@"vip_22x22_");
    }else {
        _VIPTime.text = [NSString stringWithFormat:@"会员:未开通"];
        _VIPStatusIcon.image = nil;
    }
    
    [self.signView setSignDays:[NSString stringWithFormat:@"%ld",user.signDays]];
    
}


- (YYSignBgView *)signView{
    if (!_signView) {
        _signView = [[YYSignBgView alloc] initWithFrame:CGRectMake(kSCREENWIDTH-signW, self.yy_height-signH, signW, signH)];
        [_signView addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signView;
}

/** 前往个人中心界面*/
- (IBAction)showPersonalInfo:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(destinationController:)]) {
        [self.delegate destinationController:[[YYSettingViewController alloc] init]];
    }

}

/** 订阅按钮点击事件*/
- (IBAction)subscribe:(UIButton *)sender {
    
    [SVProgressHUD showInfoWithStatus:@"暂未开放，敬请期待"];
}

/** 签到按钮的点击事件*/
- (void)signButtonClick:(YYSignBgView *)sender {
    //判断自己的图标  是不是已经签到了 ，如果是，则提醒今天已签到，否则提示签到成功
    //根据签到日期来计算今天有没有签到  后台返回签到状态
    if (sender.isSigned) {//已签到
        [SVProgressHUD showInfoWithStatus:@"今天已签到，明天再来"];
    }else{
        sender.selected = YES;
        //这是进行网络请求，给后台签到，在成功的回调中调用提醒签到成功
#warning 签到成功的提醒图片未添加
        YYWeakSelf
        [YYPlaceHolderView showSignSuccessPlaceHolderWithIntegration:@"" clickAction:^{
            //提示框点击跳转商城
            YYStrongSelf
            if ([strongSelf.delegate respondsToSelector:@selector(destinationController:)]) {
                [strongSelf.delegate destinationController:[[YYMineIntegrationViewController alloc] init]];
            }
        }];
        [SVProgressHUD showImage:nil status:@"签到成功"];
    }
    
}

/** 让代理跳转设置界面*/
- (IBAction)moreInfoButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(destinationController:)]) {
        [self.delegate destinationController:[[YYSettingViewController alloc] init]];
    }
    
}


@end
