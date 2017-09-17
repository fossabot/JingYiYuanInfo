//
//  LabelContainer.h
//
//  Created by VINCENT on 2017/6/19.
//  根据传入的文字数组，固定宽带或者高度，初始化内类的标签 标签从左至右排列，距父控件左边缘labelmargin，依次排列，超出固定宽度时自动换行，若是固定高度，一直向右排列，延展

#import <UIKit/UIKit.h>

@protocol LabelContainerClickDelegate <NSObject>

/** 当点击了label时调用该代理*/
- (void)labelContainerDidClickAtIndex:(NSInteger)index  labelTitle:(NSString *)title;

@end


typedef NS_ENUM(NSInteger, LabelContainerStableEdge){
    
    LabelContainerStableEdgeWidth = 0,  //固定宽度，label从左往右排布，越界换行
    LabelContainerStableEdgeHeight = 1  //固定高度，宽度不固定，从左往右排布，不存在越界

};

@interface LabelContainer : UIView

/** 固定边*/
@property (nonatomic, assign) LabelContainerStableEdge stableEdge;

/** titles*/
@property (nonatomic,strong) NSArray *titles;

/** 设置label标签的内边距*/
@property (nonatomic, assign) UIEdgeInsets labelEdgeInset;

/** 设置label之间的间距*/
@property (nonatomic, assign) CGFloat labelMargin;

/** 行间距*/
@property (nonatomic, assign) CGFloat rowMargin;

/** 设置标签文字的颜色*/
@property (nonatomic, strong) UIColor *labelTitleColor;

/** 设置边框的颜色*/
@property (nonatomic, strong) UIColor *labelBorderColor;

/** 标签边框的宽度*/
@property (nonatomic, assign) CGFloat labelBorderWidth;

/** 设置标签字号*/
@property (nonatomic, assign) CGFloat fontSize;

/** 标签是否有圆角*/
@property (nonatomic, assign) BOOL labelMaskToBounds;

/** 标签的圆角大小*/
@property (nonatomic, assign) CGFloat labelCornerRadius;

/** LabelContainerClickDelegate*/
@property (nonatomic, weak) id<LabelContainerClickDelegate> delegate;


/** label 内容的数组*/
+ (instancetype)labelContainerWithTitles:(NSArray *)titles andFrame:(CGRect)frame labelContainerStableEdge:(LabelContainerStableEdge)stableEdge delegate:(id<LabelContainerClickDelegate>)delegate;

- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame labelContainerStableEdge:(LabelContainerStableEdge)stableEdge delegate:(id<LabelContainerClickDelegate>)delegate;


@end
