//
//  ButtonContainer.m
//
//  Created by VINCENT on 2017/6/23.
//

#import "ButtonContainer.h"
#import "UIImage+Category.h"

@interface ButtonContainer()



/** selectedButton*/
@property (nonatomic, strong) UIButton *selectedButton;

/** 固定边*/
//@property (nonatomic, assign) ButtonContainerStableEdge stableEdge;

@end


@interface TagButton()

+ (instancetype)tagButtonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                 selectedBackColor:(UIColor *)selectedBackColor
                selectedTitleColor:(UIColor *)selectedTitleColor
                       borderColor:(UIColor *)borderColor
                       borderWidth:(CGFloat)borderWidth
                          fontSize:(CGFloat)fontSize
                      maskToBounds:(BOOL)maskToBounds
                      cornerRadius:(CGFloat)cornerRadius;


@end



@implementation ButtonContainer


+ (instancetype)buttonContainerWithTitles:(NSArray *)titles andFrame:(CGRect)frame delegate:(id)delegate{
    
    ButtonContainer *buttonContainer = [[ButtonContainer alloc] initWithFrame:frame];
    
    buttonContainer.titles = titles;
//    buttonContainer.stableEdge = stableEdge;
    buttonContainer.delegate = delegate;
    
    [buttonContainer creatSubViews];
    
    return buttonContainer;
    
}

- (instancetype)initWithTitles:(NSArray *)titles andFrame:(CGRect)frame delegate:(id)delegate{
    
    self = [[ButtonContainer alloc] initWithFrame:frame];
    
    self.titles = titles;
    self.delegate = delegate;
    [self creatSubViews];
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化默认值
        _buttonMargin = 10;
        _rowMargin = 10;
        
        _buttonTitleColor = SubTitleColor;
        _selectedTitleColor = WhiteColor;
        _selectedBackColor = ThemeColor;
        _buttonBorderColor = UnenableTitleColor;
        _buttonBorderWidth = 1;
        _fontSize = 15;
        _buttonMaskToBounds = NO;
        _buttonCornerRadius = 5;
    
    }
    return self;
    
}

/** 调用settitles方法，可在原始的初始化方法后直接更改内容，不用再次初始化*/
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self creatSubViews];
}

/**
 创建子控件
 */
- (void)creatSubViews {
    
    if (self.subviews) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    int i = 0;
    
    CGFloat x = _buttonMargin;
    CGFloat y = _rowMargin;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    for (NSString *title in self.titles) {
        
        TagButton *tagButton = [TagButton tagButtonWithTitle:title
                                                  titleColor:_buttonTitleColor
                                           selectedBackColor:_selectedBackColor
                                          selectedTitleColor:_selectedTitleColor
                                                 borderColor:_buttonBorderColor
                                                 borderWidth:_buttonBorderWidth
                                                    fontSize:_fontSize
                                                maskToBounds:_buttonMaskToBounds
                                                cornerRadius:_buttonCornerRadius];
        
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        width = tagButton.bounds.size.width;
        height = tagButton.bounds.size.height;
        
        tagButton.frame = CGRectMake(x, y, width, height);
        
        //判断当前添加到视图上的label是不是超出视图宽度了，如果超出，重新复制frame，最后addsubview
        if( x + width + _buttonMargin > self.bounds.size.width){//当label超出父视图了，则说明要换行了
            y = y + height + _rowMargin;
            NSLog(@"button Container  y ---- %f",y);
            x = _buttonMargin;
            tagButton.frame = CGRectMake(x, y, width, height);
        }
        //计算下一个label的其实x值
        x += width + _buttonMargin;
        
        [self addSubview:tagButton];
        
        [self setSelfHeight:y + height + _rowMargin];
        
        if (i == 0) {
            tagButton.selected = YES;
            self.selectedButton = tagButton;
            tagButton.layer.borderColor = [UIColor whiteColor].CGColor;
        }
       
        i++;
    }
}

/**
 重置自身的尺寸

 @param height 高度
 */
- (void)setSelfHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

- (void)tagButtonClick:(TagButton *)button {
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectedButton.selected = NO;
    self.selectedButton.layer.borderColor = YYRGBCOLOR_HEX(0x626262).CGColor;
    button.selected = YES;
    self.selectedButton = button;
    
    if ([self.delegate respondsToSelector:@selector(buttonContainerDidClickAtIndex: andTitle:)]) {
        NSInteger index = [self.titles indexOfObject:button.currentTitle];
        [self.delegate buttonContainerDidClickAtIndex:index andTitle:button.currentTitle];
    }
    
}


@end


@implementation TagButton

+ (instancetype)tagButtonWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                 selectedBackColor:(UIColor *)selectedBackColor
                selectedTitleColor:(UIColor *)selectedTitleColor
                       borderColor:(UIColor *)borderColor
                       borderWidth:(CGFloat)borderWidth
                          fontSize:(CGFloat)fontSize
                      maskToBounds:(BOOL)maskToBounds
                      cornerRadius:(CGFloat)cornerRadius {
    
    TagButton *btn = [[TagButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:selectedBackColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = borderWidth;
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    btn.layer.masksToBounds = maskToBounds;
    btn.layer.cornerRadius = cornerRadius;
    btn.clipsToBounds = YES;
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    btn.bounds = CGRectMake(0, 0, size.width+10, size.height+6);
    
    return btn;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
