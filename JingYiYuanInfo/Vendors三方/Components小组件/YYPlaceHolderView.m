//
//  YYPlaceHolderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPlaceHolderView.h"

typedef void(^Click)();

@interface YYPlaceHolderView()

/** block*/
@property (nonatomic, copy) Click click;

/** 自动消失*/
@property (nonatomic, assign) BOOL dismissAuto;

/** */
@property (nonatomic, strong) UIView *whiteBgView;

/** */
@property (nonatomic, strong) UILabel *top;

/** */
@property (nonatomic, strong) UIButton *close;

/** */
@property (nonatomic, strong) UILabel *middle;

/** */
@property (nonatomic, strong) UIImageView *money;

/** */
@property (nonatomic, strong) UILabel *integrationLabel;

/** */
@property (nonatomic, strong) UIButton *go;






/** */
@property (nonatomic, strong) UIImageView *imageView;

/** */
@property (nonatomic, strong) UILabel *tip;



@end

@implementation YYPlaceHolderView
{
    
}

/** 单例*/
+ (instancetype)sharedPlaceHolderView{
    static dispatch_once_t once;
    static YYPlaceHolderView *placeHolder;
    dispatch_once(&once, ^ { placeHolder = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return placeHolder;
}


+ (void)rewardNiuManCompletion:(void(^)(NSString *integral))completion {
    
    
    
}

/**
 *  签到成功的提示跳转商城占位图
 */
+ (void)showSignSuccessPlaceHolderWithIntegration:(NSString *)integration clickAction:(void (^)())click {
    
    YYPlaceHolderView *placeHolder = [YYPlaceHolderView sharedPlaceHolderView];
    placeHolder.click = click;
    placeHolder.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    placeHolder.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:placeHolder action:@selector(dismiss:)];
    [placeHolder addGestureRecognizer:tap];
    [kKeyWindow addSubview:placeHolder];
    
    [placeHolder makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(kKeyWindow);
    }];
    
    UIView *whiteBgView = [[UIView alloc] init];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.layer.cornerRadius = 10;
    whiteBgView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapInstead = [[UITapGestureRecognizer alloc] initWithTarget:placeHolder action:@selector(tapInstead:)];
    [whiteBgView addGestureRecognizer:tapInstead];
    
    [placeHolder addSubview:whiteBgView];
    placeHolder.whiteBgView = whiteBgView;
    
    
    UILabel *top = [[UILabel alloc] init];
    top.text = @"签到成功";
    top.font = sysFont(20);
    top.textColor = ThemeColor;
    top.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:top];
    placeHolder.top = top;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:imageNamed(@"searchdelete_44x44") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:close];
    placeHolder.close = close;
    
    UILabel *middle = [[UILabel alloc] init];
    middle.text = @"已成功获得";
    middle.font = sysFont(15);
    middle.textColor = UnenableTitleColor;
    middle.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:middle];
    placeHolder.middle = middle;
    
    UIImageView *money = [[UIImageView alloc] initWithImage:imageNamed(@"signsuccessTip_25x25_")];
    [whiteBgView addSubview:money];
    placeHolder.money = money;
    
    UILabel *integrationLabel = [[UILabel alloc] init];
    integrationLabel.text = [integration stringByAppendingString:@"积分"];
    integrationLabel.font = sysFont(17);
    integrationLabel.textColor = ThemeColor;
    integrationLabel.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:integrationLabel];
    placeHolder.integrationLabel = integrationLabel;
    
    UIButton *go = [UIButton buttonWithType:UIButtonTypeCustom];
    go.backgroundColor = ThemeColor;
    [go setTitle:@"积分兑换" forState:UIControlStateNormal];
    go.titleLabel.font = TitleFont;
    [go addTarget:self action:@selector(goShop:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:go];
    placeHolder.go = go;
    
    [whiteBgView makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(placeHolder);
        make.width.equalTo(230);
    }];
    
    [close makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.top.equalTo(whiteBgView);
        make.width.height.equalTo(40);
    }];
    
    [top makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(whiteBgView.top).offset(30);
        make.centerX.equalTo(placeHolder);
    }];
    
    [middle makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(top.bottom).offset(20);
        make.centerX.equalTo(placeHolder);
    }];
    
    [money makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(middle.bottom).offset(20);
        make.centerX.equalTo(placeHolder);
    }];
    
    [integrationLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(money.bottom).offset(15);
        make.centerX.equalTo(placeHolder);
    }];
    
    [go makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(integrationLabel.bottom).offset(15);
        make.centerX.equalTo(placeHolder);
        make.height.equalTo(30);
        make.width.equalTo(whiteBgView).offset(-60);
        make.bottom.equalTo(whiteBgView.bottom).offset(-20);
    }];
    
}



/**
 显示在View上，并且带有点击事件，block
 
 @param view 显示在View上
 @param imageName 图片名
 @param click 点击回调
 @param dismissAuto 是否自动点击回调后移除还是外部刷新后自己调用dismiss方法
 */
+ (void)showInView:(UIView *)view image:(NSString *)imageName clickAction:(void (^)())click dismissAutomatically:(BOOL)dismissAuto {
    
    
    YYPlaceHolderView *placeHolder = [YYPlaceHolderView sharedPlaceHolderView];
    if (!view) {
        view = kKeyWindow;
    }
    
//    placeHolder.frame = view.frame;
    placeHolder.dismissAuto = dismissAuto;
    [view addSubview:placeHolder];
    
    [placeHolder makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(view);
    }];
    
    if (click) {
        placeHolder.click = click;
    }
    
    UIImage *image = nil;
    if (imageName) {
        image = imageNamed(imageName);
    }else{
        image = imageNamed(@"yyfw_push_empty_112x94_");
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [placeHolder addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
    [placeHolder addGestureRecognizer:tap];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.text = @"暂无数据，点此刷新";
    tip.font = [UIFont systemFontOfSize:14];
    [tip sizeToFit];
    tip.textColor = [UIColor lightGrayColor];
    [placeHolder addSubview:tip];
    placeHolder.tip = tip;
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(placeHolder);
        make.centerY.equalTo(placeHolder).offset(-30);
    }];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(placeHolder);
        make.top.equalTo(imageView.bottom).offset(10);
    }];

}


/**  关闭商城的提示图*/
+ (void)close:(UIButton *)sender {

    [[YYPlaceHolderView sharedPlaceHolderView] removeFromSuperview];
}

/** 去商城*/
+ (void)goShop:(UIButton *)sender {
    
    YYPlaceHolderView *placeHolder = [YYPlaceHolderView sharedPlaceHolderView];
    if (placeHolder.click) {
        placeHolder.click();
    }
    //外部刷新后自己调用dismiss方法
    
    [placeHolder removeFromSuperview];
    
}


+ (void)handTap:(UITapGestureRecognizer*)gesture {
    YYPlaceHolderView *placeHolder = [YYPlaceHolderView sharedPlaceHolderView];
    if (placeHolder.click) {
        placeHolder.click();
    }
    //外部刷新后自己调用dismiss方法
    
    [placeHolder removeFromSuperview];
    
}

- (void)dismiss:(UITapGestureRecognizer *)gesture {

    [[YYPlaceHolderView sharedPlaceHolderView] removeFromSuperview];
}

- (void)tapInstead:(UITapGestureRecognizer *)gesture {
    YYLog(@"顶替背景的点击事件");
}

- (void)dealloc {
    
    YYLog(@"YYPlaceHolderView dealloc");
}

@end
