//
//  YYPlaceHolderView.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPlaceHolderView.h"


@interface YYPlaceHolderView()

/** block*/
@property (nonatomic, copy) void(^block)();

/** 自动消失*/
@property (nonatomic, assign) BOOL dismissAuto;


@end

@implementation YYPlaceHolderView


/** 单例*/
+ (instancetype)sharedPlaceHolderView{
    static dispatch_once_t once;
    static YYPlaceHolderView *placeHolder;
    dispatch_once(&once, ^ { placeHolder = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return placeHolder;
}


/**
 *  签到成功的提示跳转商城占位图
 */
+ (void)showSignSuccessPlaceHolderWithIntegration:(NSString *)integration clickAction:(void (^)())click {
    
    YYPlaceHolderView *placeHolder = [self sharedPlaceHolderView];
    
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake((kSCREENWIDTH-180)/2, (kSCREENHEIGHT-190)/2, 180, 190)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.layer.cornerRadius = 10;
    whiteBgView.layer.masksToBounds = YES;
    [placeHolder addSubview:whiteBgView];
    
    
    UILabel *top = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, MAXFLOAT, 20)];
    top.yy_centerX = whiteBgView.yy_centerX;
    top.text = @"签到成功";
    top.font = sysFont(17);
    top.textColor = ThemeColor;
    top.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:top];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(whiteBgView.yy_width-40, 10, 30, 30);
    [close setImage:imageNamed(@"searchdelete_44x44") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:close];
    
    
    
    UILabel *middle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(top.frame)+10, MAXFLOAT, 20)];
    middle.yy_centerX = whiteBgView.yy_centerX;
    middle.text = @"签到成功";
    middle.font = sysFont(13);
    middle.textColor = UnenableTitleColor;
    middle.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:middle];
    
    UIImageView *money = [[UIImageView alloc] initWithImage:imageNamed(@"signsuccessTip_25x25_")];
    money.yy_centerX = whiteBgView.yy_centerX;
    money.yy_y = CGRectGetMaxY(middle.frame)+10;
    [whiteBgView addSubview:money];
    
    UILabel *integrationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(money.frame)+10, MAXFLOAT, 20)];
    integrationLabel.yy_centerX = whiteBgView.yy_centerX;
    integrationLabel.text = [integration stringByAppendingString:@"积分"];
    integrationLabel.font = sysFont(14);
    integrationLabel.textColor = ThemeColor;
    integrationLabel.textAlignment = NSTextAlignmentCenter;
    [whiteBgView addSubview:integrationLabel];
    
    UIButton *go = [UIButton buttonWithType:UIButtonTypeCustom];
    go.backgroundColor = [UIColor redColor];
    [go setTitle:@"积分兑换" forState:UIControlStateNormal];
    go.frame = CGRectMake(0, CGRectGetMaxY(integrationLabel.frame)+10, 100, 25);
    go.yy_centerX = whiteBgView.yy_centerX;
    [go addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:go];
    
    whiteBgView.yy_height = CGRectGetMaxY(go.frame)+15;
}



/**
 显示在View上，并且带有点击事件，block
 
 @param view 显示在View上
 @param imageName 图片名
 @param click 点击回调
 @param dismissAuto 是否自动点击回调后移除还是外部刷新后自己调用dismiss方法
 */
+ (void)showInView:(UIView *)view image:(NSString *)imageName clickAction:(void (^)())click dismissAutomatically:(BOOL)dismissAuto {
    
    
    YYPlaceHolderView *placeHolder = [self sharedPlaceHolderView];
    if (!view) {
        view = kKeyWindow;
    }
    
    placeHolder.frame = view.frame;
    placeHolder.dismissAuto = dismissAuto;
    [view addSubview:placeHolder];
    
    if (click) {
        placeHolder.block = click;
    }
    
#warning 未赋值占位图片的名称
    UIImage *image = nil;
    if (imageName) {
        image = imageNamed(imageName);
    }else{
        image = imageNamed(@"yyfw_push_empty_112x94_");
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.size = CGSizeMake(60, 100);
    imageView.center = placeHolder.center;
    [placeHolder addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshClick)];
    [imageView addGestureRecognizer:tap];
}

+ (void)dismiss{
    
    [[self sharedPlaceHolderView] removeFromSuperview];
}

- (void)refreshClick{
    
    if (_dismissAuto) {
        [self removeFromSuperview];
    }
    self.block();
    //外部刷新后自己调用dismiss方法
}

@end
