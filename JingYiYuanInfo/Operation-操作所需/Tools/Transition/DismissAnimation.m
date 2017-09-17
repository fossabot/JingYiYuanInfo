//
//  DismissAnimation.m
//  CustomModalTransitionAnimation
//
//  Created by Baoqin Huang on 2017/6/25.
//  Copyright © 2017年 Baoqin Huang. All rights reserved.
//

#import "DismissAnimation.h"

@implementation DismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect targetFrame = [transitionContext initialFrameForViewController:fromVC];
    targetFrame = CGRectOffset(targetFrame, CGRectGetWidth(targetFrame), 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
