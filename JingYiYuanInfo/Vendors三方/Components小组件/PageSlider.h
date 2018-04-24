//
//  PageSlider.h
//  CustomSliderDemo
//
//  Created by VINCENT on 2017/7/20.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontChangedBlock)(CGFloat rate);

@interface PageSlider : UIView

/** 节点数*/
@property (nonatomic, assign) NSInteger totalPoint;

/** 当前所处的节点*/
@property (nonatomic, assign) NSInteger currentPoint;

/** 节点对应的名称*/
@property (nonatomic, strong) NSArray *pointNames;

/** block倍率*/
@property (nonatomic, copy) FontChangedBlock fontChangedBlock;



/**
 弹起滑动选择框  输入总节点数和当前节点位置（1~···） 还有每个节点的文字（数组），根据我这个字体调节设置的字体变化的回调

 @param totalPoint 总节点
 @param currentPoint 当前节点
 @param pointNames 节点名称
 @param fontChanged 字体变化的回调
 */
+ (void)showPageSliderWithTotalPoint:(NSInteger)totalPoint currentPoint:(NSInteger)currentPoint pointNames:(NSArray *)pointNames fontChanged:(FontChangedBlock)fontChanged;


+ (void)showPageSliderWithCurrentPoint:(NSInteger)currentPoint fontChanged:(FontChangedBlock)fontChanged;

@end

@interface Container  : UIView

/** 节点数*/
@property (nonatomic, assign) NSInteger totalPoint;

/** 当前所处的节点*/
@property (nonatomic, assign) NSInteger currentPoint;

/** 节点对应的名称*/
@property (nonatomic, strong) NSArray *pointNames;

/** block倍率*/
@property (nonatomic, copy) FontChangedBlock fontChangedBlock;

@end
