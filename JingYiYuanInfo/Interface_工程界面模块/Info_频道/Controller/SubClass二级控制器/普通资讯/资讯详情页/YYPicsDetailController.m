//
//  YYPicsDetailController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPicsDetailController.h"
#import "YYPhotoBrowser.h"
#import "DismissAnimation.h"

@interface YYPicsDetailController ()<UIViewControllerTransitioningDelegate>


@end

@implementation YYPicsDetailController
{
    DismissAnimation *_dismissAnimation;
    YYPhotoBrowser *photo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dismissAnimation = [[DismissAnimation alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    YYWeakSelf
    photo = [[YYPhotoBrowser alloc] initWithFrame:self.view.bounds];
    
    photo.dismissBlock = ^{
        YYStrongSelf
        [strongSelf dismiss];
//        [strongSelf pop];
    };
    [self.view addSubview:photo];
    [photo setPicsModels:_picsModels];
}

- (void)setPicsModels:(NSArray<YYHotPicsModel *> *)picsModels {
    
    _picsModels = picsModels;
    
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _dismissAnimation;
}


@end
