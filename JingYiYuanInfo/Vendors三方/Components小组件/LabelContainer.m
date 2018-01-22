//
//  LabelContainer.m
//
//  Created by VINCENT on 2017/6/19.
//

#import "LabelContainer.h"
#import "YYEdgeLabel.h"

@implementation LabelContainer

+ (instancetype)labelContainerWithTitles:(NSArray *)titles andFrame:(CGRect)frame labelContainerStableEdge:(LabelContainerStableEdge)stableEdge rowMargin:(CGFloat)rowMargin labelMargin:(CGFloat)labelMargin delegate:(id)delegate{

    LabelContainer *labelContainer = [[LabelContainer alloc] initWithFrame:frame];
    labelContainer.titles = titles;
    labelContainer.stableEdge = stableEdge;
    labelContainer.rowMargin = rowMargin;
    labelContainer.labelMargin = labelMargin;
    labelContainer.delegate = delegate;
    
    [labelContainer creatSubviews];
    
    return labelContainer;
}


- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame labelContainerStableEdge:(LabelContainerStableEdge)stableEdge rowMargin:(CGFloat)rowMargin labelMargin:(CGFloat)labelMargin delegate:(id)delegate{
    
    self = [[LabelContainer alloc] initWithFrame:frame];
    _titles = titles;
    _stableEdge = stableEdge;
    _rowMargin = rowMargin;
    _labelMargin = labelMargin;
    _delegate = delegate;
    
    [self creatSubviews];
    return self;

}

/** 初始化带有labelinset属性的*/
- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame edgeInset:(UIEdgeInsets)edgeinset labelContainerStableEdge:(LabelContainerStableEdge)stableEdge rowMargin:(CGFloat)rowMargin labelMargin:(CGFloat)labelMargin delegate:(id<LabelContainerClickDelegate>)delegate {
    
    self = [[LabelContainer alloc] initWithFrame:frame];
    _titles = titles;
    _stableEdge = stableEdge;
    _rowMargin = rowMargin;
    _labelMargin = labelMargin;
    _delegate = delegate;
    _labelEdgeInset = edgeinset;
    
    [self creatSubviews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化属性的默认值
        
        _labelEdgeInset = UIEdgeInsetsMake(2, 5, 2, 5);
        _labelMargin = 5;
        _rowMargin = 10;
        _labelTitleColor = YYRGBCOLOR_HEX(0x222222);
        _labelBorderColor = YYRGBCOLOR_HEX(0x626262);
        _labelBorderWidth = 0.5;
        _fontSize = 15;
        _labelMaskToBounds = NO;
        _labelCornerRadius = 0;
        _stableEdge = LabelContainerStableEdgeWidth;
    
    }
    return self;
    
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self creatSubviews];
//    [self setNeedsLayout];
//    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (YYEdgeLabel *label in self.subviews) {
        
        label.layer.cornerRadius = _labelCornerRadius;
        label.layer.borderColor = _labelBorderColor.CGColor;
        label.layer.borderWidth = _labelBorderWidth;
        label.textColor = _labelTitleColor;
        label.font = [UIFont systemFontOfSize:_fontSize];
        label.layer.masksToBounds = _labelMaskToBounds;
        label.edgeInsets = _labelEdgeInset;
    }

}

/**
 创建子控件
 */
- (void)creatSubviews{
    
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (_titles == nil) {
        self.bounds = CGRectZero;
        return ;
    }
    
    CGFloat x = _labelMargin;
    CGFloat y = _rowMargin;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    
    for (NSString *title in _titles) {
        
        YYEdgeLabel *label = [YYEdgeLabel edgeInsetLabelWithTitle:title
                                                             titleColor:_labelTitleColor
                                                             edgeInsets:_labelEdgeInset
                                                            borderColor:_labelBorderColor
                                                            borderWidth:_labelBorderWidth
                                                               fontSize:_fontSize
                                                           maskToBounds:_labelMaskToBounds
                                                           cornerRadius:_labelCornerRadius];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [label addGestureRecognizer:tap];
        
        
        width = label.bounds.size.width;
        height = label.bounds.size.height;
        
        label.frame = CGRectMake(x, y, width, height);
        
        if (_stableEdge == LabelContainerStableEdgeWidth) {
            //判断当前添加到视图上的label是不是超出视图宽度了，如果超出，重新复制frame，最后addsubview
            if( x + width + _labelMargin > self.bounds.size.width){//当label超出父视图了，则说明要换行了
                y = y + height + _rowMargin;
                NSLog(@"label Container  y ---- %f",y);
                x = _labelMargin;
                label.frame = CGRectMake(x, y, width, height);
            }
            //计算下一个label的其实x值
            x += width + _labelMargin;
            
            [self addSubview:label];
            
            [self setSelfHeight:y + height + _rowMargin];
            
        }else if(_stableEdge == LabelContainerStableEdgeHeight){
            
            //计算下一个label的其实x值
            x += width + _labelMargin;

            [self setSelfWidth:x];
        }
        
    }
}


- (void)labelClick:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(labelContainerDidClickAtIndex:labelTitle:)]) {
        
        UILabel *label = (UILabel *)tap.view;
        NSInteger index = [_titles indexOfObject:label.text];
        [self.delegate labelContainerDidClickAtIndex:index labelTitle:label.text];
    
    }
}


- (void)setSelfHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;

}

- (void)setSelfWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
}

@end


