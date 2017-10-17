//
//  YYMineHeaderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineHeaderView.h"

#import "YYLoginViewController.h"
#import "YYUserInfoViewController.h"
#import "YYSettingViewController.h"
#import "YYMineIntegrationViewController.h"
#import "YYMineSubscriptionViewController.h"

#import "YYSignBgView.h"
#import "YYUser.h"
#import "YYPlaceHolderView.h"
#import "YYLoginManager.h"

#import "UIView+YYViewFrame.h"

@interface YYMineHeaderView ()

@property (nonatomic, assign) BOOL isLogin;

/** 登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginIcon;
/** 会员状态的图片（365与非365）*/
@property (weak, nonatomic) IBOutlet UIImageView *VIPStatusIcon;
/** 名字*/
@property (weak, nonatomic) IBOutlet UILabel *name;

/** VIP到期时间 VIPTime*/
@property (weak, nonatomic) IBOutlet UILabel *VIPTime;

/** 积分 integration*/
@property (weak, nonatomic) IBOutlet UILabel *integration;


/** signView*/
@property (nonatomic, strong) YYSignBgView *signView;

@end

@implementation YYMineHeaderView

+ (instancetype)headerView{
    
    YYMineHeaderView *headView = [[[NSBundle mainBundle] loadNibNamed:@"YYMineHeaderView" owner:nil options:nil] firstObject];
    
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

//更新签到状态
- (void)changeSignState {

    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"quesign",@"act", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:signIntegralUrl parameters:para success:^(id response) {
        
        if (response && [response[STATE] isEqualToString:@"0"]) {//已经签到
            
            [self.signView setSignDays:[NSString stringWithFormat:@"%@",response[@"signtimes"]]];
        }else if (response && [response[STATE] isEqualToString:@"2"]) {
            [self.signView setSignDays:@"0"];
        }
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];
}

/** 更新个人信息*/
- (void)setUser:(YYUser *)user {
    _user = user;
    
    _name.text = [NSString stringWithFormat:@"昵称:%@",user.username];
    [_loginIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:imageNamed(@"yyfw_mine_unloginicon_83x83_")];
    _integration.text = [NSString stringWithFormat:@"积分:%@",user.integral];
    
    NSString *groupId = [NSString stringWithFormat:@"%@",user.groupid];
    if ([groupId containsString:@"3"]) {
        _VIPTime.text = [NSString stringWithFormat:@"会员:%@到期",user.expiretime];
        _VIPStatusIcon.image = imageNamed(@"vip_22x22_");
    }else {
        _VIPTime.text = [NSString stringWithFormat:@"会员:未开通"];
        _VIPStatusIcon.image = nil;
    }
    [self changeSignState];
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
        [self.delegate destinationController:[[YYUserInfoViewController alloc] init]];
    }
}

/** 订阅按钮点击事件*/
- (IBAction)subscribe:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(destinationController:)]) {
        [self.delegate destinationController:[[YYMineSubscriptionViewController alloc] init]];
    }
}

/** 签到按钮的点击事件*/
- (void)signButtonClick:(YYSignBgView *)sender {
    //判断自己的图标  是不是已经签到了 ，如果是，则提醒今天已签到，否则提示签到成功
    //根据签到日期来计算今天有没有签到  后台返回签到状态
    if (sender.isSigned) {//已签到
        [SVProgressHUD showImage:nil status:@"今天已签到，明天再来"];
        [SVProgressHUD dismissWithDelay:1];
    }else{
//        sender.selected = YES;
        //这是进行网络请求，给后台签到，在成功的回调中调用提醒签到成功
        YYWeakSelf
        YYUser *user = [YYUser shareUser];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"signup",@"act", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:signIntegralUrl parameters:para success:^(id response) {
            
            if (response) {
                NSString *state = response[STATE];
                if ([state isEqualToString:@"1"]) {
                    [self.signView setSignDays:[NSString stringWithFormat:@"%@",response[@"signtimes"]]];
                    [YYLoginManager getUserInfo];
                    [YYPlaceHolderView showSignSuccessPlaceHolderWithIntegration:response[@"getintegral"] clickAction:^{
                        //提示框点击跳转商城
                        YYStrongSelf
                        if ([strongSelf.delegate respondsToSelector:@selector(destinationController:)]) {
                            [strongSelf.delegate destinationController:[[YYMineIntegrationViewController alloc] init]];
                        }
                        
                    }];
                }
            }
        } failure:^(NSError *error) {
            
            
        } showSuccessMsg:nil];
        
    }
    
}

/** 让代理跳转设置界面*/
- (IBAction)moreInfoButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(destinationController:)]) {
        [self.delegate destinationController:[[YYSettingViewController alloc] init]];
    }
    
}


@end
