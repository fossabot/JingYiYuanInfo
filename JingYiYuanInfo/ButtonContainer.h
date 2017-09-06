//
//  ButtonContainer.h
//
//  Created by VINCENT on 2017/6/23.
//  根据传入的文字数组，固定宽带或者高度，初始化内类的标签 标签从左至右排列，距父控件左边缘labelmargin，依次排列，超出固定宽度时自动换行，若是固定高度，一直向右排列，延展



#import <UIKit/UIKit.h>

@protocol ButtonContainerClickDelegate <NSObject>


/**
 button选中的回调

 @param index button序号
 @param title button的标题
 */
- (void)buttonContainerDidClickAtIndex:(NSInteger)index andTitle:(NSString *)title;

@end

//typedef NS_ENUM(NSInteger, ButtonContainerStableEdge){
//    
//    ButtonContainerStableEdgeWidth = 0,  //固定宽度，label从左往右排布，越界换行
//    ButtonContainerStableEdgeHeight = 1  //固定高度，宽度不固定，从左往右排布，不存在越界
//    
//};


@interface ButtonContainer : UIView

/** titles*/
@property (nonatomic, strong) NSArray *titles;

/** 设置button之间的间距*/
@property (nonatomic, assign) CGFloat buttonMargin;

/** 行间距*/
@property (nonatomic, assign) CGFloat rowMargin;

/** 设置标签文字的颜色*/
@property (nonatomic, strong) UIColor *buttonTitleColor;

/** 标签文字选中时颜色*/
@property (nonatomic, strong) UIColor *selectedTitleColor;

/** 标签北京选中时的颜色*/
@property (nonatomic, strong) UIColor *selectedBackColor;

/** 设置边框的颜色*/
@property (nonatomic, strong) UIColor *buttonBorderColor;

/** 标签边框的宽度*/
@property (nonatomic, assign) CGFloat buttonBorderWidth;

/** 设置标签字号*/
@property (nonatomic, assign) CGFloat fontSize;

/** 标签是否有圆角*/
@property (nonatomic, assign) BOOL buttonMaskToBounds;

/** 标签的圆角大小*/
@property (nonatomic, assign) CGFloat buttonCornerRadius;

///** 默认选中的button*/
//@property (nonatomic, strong) UIButton *selectedButton;

/** delegate*/
@property (nonatomic, weak) id<ButtonContainerClickDelegate> delegate;

/** button 内容的数组*/
+ (instancetype)buttonContainerWithTitles:(NSArray *)titles andFrame:(CGRect)frame delegate:(id<ButtonContainerClickDelegate>)delegate;

- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame delegate:(id<ButtonContainerClickDelegate>)delegate;


@end

@interface TagButton : UIButton

@end

