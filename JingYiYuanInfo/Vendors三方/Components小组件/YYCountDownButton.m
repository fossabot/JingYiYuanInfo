//
//  YYCountDownButton.m
//  YYCountDownButton
//
//  Created by Mengjie.Wang on 2016/06/22.
//  Copyright © 2016年 王梦杰. All rights reserved.
//

#import "YYCountDownButton.h"
#import "UIImage+Category.h"

typedef void(^CountDownBlock)(YYCountDownButton *button);

@interface YYCountDownButton ()

@property (nonatomic, copy) CountDownBlock countDownBlock;

@end

@implementation YYCountDownButton
{
    NSInteger _startTime;
    NSString *_unitTitle;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startTime = 60;
        _unitTitle = @"s";
    }
    return self;
}
- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(void(^)(YYCountDownButton *countDownButton))completion {
    __weak typeof(self) weakSelf = self;
    __block NSInteger remainTime = startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.enabled = YES;
                weakSelf.layer.borderColor = ThemeColor.CGColor;
                completion(weakSelf);
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)remainTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,unitTitle] forState:UIControlStateDisabled];
                [weakSelf setTitleColor:UnenableTitleColor forState:UIControlStateDisabled];
//                [weakSelf setBackgroundImage:[UIImage imageWithColor:UnenableTitleColor] forState:UIControlStateDisabled];
                weakSelf.layer.borderColor = UnenableTitleColor.CGColor;
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}

- (void)resume {
    
    __weak typeof(self) weakSelf = self;
    __block NSInteger remainTime = _startTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.enabled = YES;
                weakSelf.layer.borderColor = ThemeColor.CGColor;
                CountDownBlock(weakSelf);
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)remainTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,_unitTitle] forState:UIControlStateDisabled];
                [weakSelf setTitleColor:UnenableTitleColor forState:UIControlStateDisabled];
                //                [weakSelf setBackgroundImage:[UIImage imageWithColor:UnenableTitleColor] forState:UIControlStateDisabled];
                weakSelf.layer.borderColor = UnenableTitleColor.CGColor;
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}

@end
