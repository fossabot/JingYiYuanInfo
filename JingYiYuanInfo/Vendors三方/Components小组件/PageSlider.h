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
