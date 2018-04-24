//
//  YYCommentTextView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentTextView.h"

@interface  YYCommentTextView()

@property (strong,nonatomic) UILabel *placeTextLab;

@end


@implementation YYCommentTextView

-(instancetype)initWithFrame:(CGRect)frame PlaceText:(NSString *)placeText PlaceColor:(UIColor *)placeColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _placeText = placeText;
        _placeColor = placeColor;
        _Textnil = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setTextnil:(BOOL)Textnil {
    _Textnil = Textnil;
    if (!Textnil) {
        
        [[self viewWithTag:999] setAlpha:0];
    }
}

#pragma mark 隐藏或显示placeText
-(void)TextChange:(NSNotification *)notification{
    if (self.text.length==0) {
        _Textnil=YES;
    }else{
        _Textnil=NO;
    }
    
    if (self.placeText.length==0) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (_Textnil) {
            [[self viewWithTag:999] setAlpha:1.0];
        }else{
            [[self viewWithTag:999] setAlpha:0];
        }
        
    }];
    
}

#pragma mark 重写drawRect
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self PlaceTextLabel];
}

#pragma mark 初始化placetext
-(void)PlaceTextLabel{
    if (self.placeText.length>0) {
        if (!_placeTextLab) {
            CGRect frame = CGRectMake(3,8, self.bounds.size.width-16, 0);
            _placeTextLab = [[UILabel alloc]initWithFrame:frame];
            _placeTextLab.font = self.font;
            _placeTextLab.backgroundColor = [UIColor clearColor];
            _placeTextLab.textColor = self.placeColor;
            _placeTextLab.tag = 999;
            _placeTextLab.alpha = 0;
            _placeTextLab.lineBreakMode = NSLineBreakByWordWrapping;
            _placeTextLab.numberOfLines = 0;
            [self addSubview:_placeTextLab];
        }
        
        _placeTextLab.text = self.placeText;
        [_placeTextLab sizeToFit];
        [_placeTextLab setFrame:CGRectMake(3, 8, CGRectGetWidth(self.bounds)-16, CGRectGetHeight(_placeTextLab.frame))];
    }
    if (self.text.length == 0 && self.placeText.length>0) {
        [[self viewWithTag:999]setAlpha:1.0];
    }
}


-(void)setPlaceText:(NSString *)placeText{
    _placeText = placeText;
    _placeTextLab.text = placeText;
    [self TextChange:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
