//
//  PageSlider.m
//  CustomSliderDemo
//
//  Created by VINCENT on 2017/7/20.
//  Copyright © 2017年 gongwenkai. All rights reserved.
//

#import "PageSlider.h"
#import "UISlider+Touch.h"

#import "YYUser.h"

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

static NSString * const title = @"文字大小";

@interface PageSlider()

/** 底部的container*/
@property (nonatomic, strong) Container *container;

@end


@interface Container()

/** slider*/
@property (nonatomic, strong) UISlider *slider;

/** slider所有对应的value（几分之一）*/
@property (nonatomic, strong) NSMutableArray *sliderValues;

/** block返回的数据数组*/
@property (nonatomic, strong) NSArray *outputValues;

- (void)configSubviews;

@end

@implementation PageSlider

+ (void)showPageSliderWithTotalPoint:(NSInteger)totalPoint currentPoint:(NSInteger)currentPoint pointNames:(NSArray *)pointNames fontChanged:(FontChangedBlock)fontChanged {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    PageSlider *pageSlider = [[PageSlider alloc] init];
    
    [keyWindow addSubview:pageSlider];
    
    pageSlider.container.totalPoint = totalPoint;
    pageSlider.container.currentPoint = currentPoint;
    pageSlider.container.pointNames = pointNames;
    pageSlider.container.fontChangedBlock = fontChanged;
    [pageSlider.container configSubviews];
    [pageSlider addSubview:pageSlider.container];
    [UIView animateWithDuration:1.0 animations:^{
        pageSlider.container.transform = CGAffineTransformMakeTranslation(0, -140);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _totalPoint = 4;
        _currentPoint = 1;
        _pointNames = @[@"标准",@"大",@"极大",@"超级大"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    YYLog(@"点击window");
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.container.transform = CGAffineTransformMakeTranslation(0, 140);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}


/** 底部容器*/
- (Container *)container{
    if (!_container) {
        _container = [[Container alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lalalal)];
        [_container addGestureRecognizer:tap];
    }
    return _container;
}

- (void)lalalal{
    YYLog(@"点击container");
}



@end


@implementation Container

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, SCREENH, SCREENW, 140)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configSubviews {
    [self addSubview:self.slider];
    [self bringSubviewToFront:self.slider];
}


- (UISlider *)slider {
    if (!_slider) {
        
        _slider = [[UISlider alloc] init];
        CGFloat x = 40;
        CGFloat y = CGRectGetHeight(self.frame) - 45 - 15;
        CGFloat w = CGRectGetWidth(self.frame) - 2*x;
        _slider.frame = CGRectMake(x, y, w, 30);
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.tintColor = [UIColor clearColor];
        _slider.backgroundColor = [UIColor clearColor];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [_slider setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateHighlighted];
        _slider.value = (float)(_currentPoint-1)/(_totalPoint-1);
        _slider.continuous = NO;
        [_slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTapGestureWithTarget:self action:@selector(sliderValueDidChanged:)];
        
    }
    return _slider;
}

- (NSMutableArray *)sliderValues{
    if (!_sliderValues) {
        _sliderValues = [NSMutableArray array];
        for (int i=0; i<=self.totalPoint; i++) {
            [_sliderValues addObject:@((float)i/(self.totalPoint-1))];
        }
    }
    return _sliderValues;
}

/** 选中字号返回的数字*/
- (NSArray *)outputValues {
    if (!_outputValues) {
        _outputValues = [NSArray arrayWithObjects:@1.0,@1.2,@1.5,@2.0, nil];
    }
    return _outputValues;
}



/**
 *设置最近的那个节点数值为slider的value
 */
- (void)sliderValueDidChanged:(UISlider *)slider {
    
    slider.value = [self getNearestValue:slider.value];
    //将slider的值置为节点后，应该返回一个block回调，去改变字体大小
    if (_fontChangedBlock) {
        NSUInteger index = [self.sliderValues indexOfObject:@(slider.value)];
        CGFloat outputValue = [[self.outputValues objectAtIndex:index] floatValue];
        YYUser *user = [YYUser shareUser];
        [user setWebfont:outputValue];
        _fontChangedBlock(outputValue);
    }
}


/**
 *根据已知的数值去slider数组对比出最接近的value，并将value返回
 */
- (CGFloat)getNearestValue:(CGFloat)value {
    
    CGFloat nearestValue = 1.0;
    CGFloat difference = 1.0;
    for (NSNumber *temp in self.sliderValues) {
        if(difference > fabs(value - [temp floatValue])){
            difference = fabs(value - [temp floatValue]);
            nearestValue = [temp floatValue];
        }
    }
    return nearestValue;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self darwWidgetsWithContext:context];
    
}


- (void)darwWidgetsWithContext:(CGContextRef)context {
    UIColor *titleColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:1.0];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:titleColor};
    CGSize titleSize = [title sizeWithAttributes:attributes];
    CGFloat x = self.bounds.size.width/2 - titleSize.width/2;
    CGFloat y = 5;
    
    [title drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
//    [title drawInRect:CGRectMake(x, y, titleSize.width, titleSize.height) withAttributes:attributes];
    
    CGContextMoveToPoint(context, 30, titleSize.height + 10);
    CGContextAddLineToPoint(context, self.bounds.size.width-30, titleSize.height + 10);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.8);
    
    CGFloat margin = 8;
    CGFloat lineY = self.slider.frame.origin.y+margin;
    CGFloat sliderW = self.slider.bounds.size.width-30;
    CGFloat sliderH = self.slider.bounds.size.height;
    CGFloat startP = 0.0;
    CGFloat endP = 0.0;
    NSDictionary *pointAttribute = @{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    for (int i=0; i<_totalPoint; i++) {
        
        //画线
        CGFloat lineX = 55 + i*(sliderW/(self.totalPoint-1));
        
        CGContextMoveToPoint(context, lineX, lineY);
        CGContextAddLineToPoint(context, lineX, sliderH + lineY-margin);
        CGContextSetLineWidth(context, 0.8);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextStrokePath(context);
        
        if (i == 0) {
            startP = lineX;
        }else if (i == _totalPoint - 1) {
            endP = lineX;
            CGContextMoveToPoint(context, startP, lineY + sliderH/2);
            CGContextAddLineToPoint(context, endP, lineY + sliderH/2);
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(context, 0.8);
            CGContextStrokePath(context);
        }
        
        
        CGSize pointNameSize = [_pointNames[i] sizeWithAttributes:pointAttribute];
        CGFloat pointX = lineX - pointNameSize.width/2;
        CGFloat pointY = lineY - pointNameSize.height - 2 - margin;
        
        //画文字
        [_pointNames[i] drawInRect:CGRectMake(pointX, pointY, pointNameSize.width, pointNameSize.height) withAttributes:pointAttribute];
        
    }
    
    
}



@end



