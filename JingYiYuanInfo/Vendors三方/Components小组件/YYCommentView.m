//
//  YYCommentView.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentView.h"
#import "YYCommentTextView.h"

@interface YYCommentView()<UITextViewDelegate>

/** textView*/
@property (nonatomic, strong) YYCommentTextView *textView;

/** textViewContainer*/
@property (nonatomic, strong) UIView *textViewContainer;

/** send*/
@property (nonatomic, strong) UIButton *send;

/** cancel*/
@property (nonatomic, strong) UIButton *cancel;

/** title*/
@property (nonatomic, strong) UILabel *title;

@end

@implementation YYCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:kMainScreen.bounds];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
        [self addGestureRecognizer:tap];
        [kNotificationCenter addObserver:self selector:@selector(changeTextFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)configSubView {
    
    [self addSubview:self.textViewContainer];
}


- (void)show {
    
//    YYWeakSelf
    [YYHttpNetworkTool globalNetStatusNotice:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [SVProgressHUD showErrorWithStatus:@"当前无网络"];
            [SVProgressHUD dismissWithDelay:1];
            return;
        }else {
            
            [kKeyWindow addSubview:self];
            [self addSubview:self.textViewContainer];
            [self.textView becomeFirstResponder];
        }
    }];
    
    
}

/* 清除评论text*/
- (void)clearText {
    
    self.textView.text = nil;
}

/** 辞去第一响应者，自动移出输入框*/
- (void)resignResponder {
    
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}



/** 弹出评论框，写评论*/
- (void)write {
    
    
}


/** 改变输入框的位置*/
- (void)changeTextFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval boardAnimationDuration=[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardEndY = keyBoardFrame.origin.y;
    YYLog(@"frame:%@",NSStringFromCGRect(keyBoardFrame));
    
    YYWeakSelf
    [UIView animateWithDuration:boardAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = weakSelf.textViewContainer.frame;
        frame.origin.y = keyBoardEndY - 120;
        weakSelf.textViewContainer.frame = frame;
        YYLog(@"_textViewContainerframe:%@",NSStringFromCGRect(weakSelf.textViewContainer.frame));
    } completion:^(BOOL finished) {
        if (keyBoardEndY == kSCREENHEIGHT && finished) {
            [self resignResponder];
        }
    }];
    
}


/** 发送评论*/
- (void)sendComment {
    
    YYWeakSelf
    [YYHttpNetworkTool globalNetStatusNotice:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [SVProgressHUD showErrorWithStatus:@"当前无网络"];
            [SVProgressHUD dismissWithDelay:1];
            return;
        }
        
        NSString *text = weakSelf.textView.text;
        //判断输入框全是空格的思路 ：把空格和换行符全删除后剩余的字符长度不等于0，说明不全是空格
        NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString=[text stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0) {
            YYLog(@"当前输入框为空");
            [SVProgressHUD showImage:nil status:@"输入为空"];
            [SVProgressHUD dismissWithDelay:1];
            return;
        }
        
        if (weakSelf.commentBlock) {
            weakSelf.commentBlock(weakSelf.textView.text);
        }
        [weakSelf cancelSend];
    }];
    
}

- (void)cancelSend {
    
    [self resignResponder];
}

/**
 将评论框从俯视图中移除  否则一直占用着keywindow
 */
- (void)removeCommentView {
    
    [self resignResponder];
    _textViewContainer = nil;
}





#pragma mark ------- textView的代理方法  -------------------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.send.enabled = text.length ? YES : NO;
    return YES;
}



- (UIView *)textViewContainer{
    if (!_textViewContainer) {
        _textViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 140)];
        _textViewContainer.backgroundColor = GrayBackGroundColor;
        [_textViewContainer addSubview:self.title];
        [_textViewContainer addSubview:self.cancel];
        [_textViewContainer addSubview:self.send];
        [_textViewContainer addSubview:self.textView];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.textViewContainer);
            make.top.offset(YYInfoCellCommonMargin);
        }];
        [self.cancel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(YYInfoCellCommonMargin);
            make.centerY.equalTo(self.title);
        }];
        [self.send makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-YYInfoCellCommonMargin);
            make.centerY.equalTo(self.title);
        }];
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancel.left);
            make.right.equalTo(self.send.right);
            make.top.equalTo(self.title.bottom).offset(YYInfoCellCommonMargin);
            make.bottom.equalTo(-YYInfoCellCommonMargin*2);
        }];
    }
    return _textViewContainer;
}


- (YYCommentTextView *)textView{
    if (!_textView) {
        _textView = [[YYCommentTextView alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT, kSCREENWIDTH, 100) PlaceText:_placeHolder PlaceColor:[UIColor lightGrayColor]];
        _textView.font = SubTitleFont;
        _textView.delegate = self;
    }
    return _textView;
}


- (UIButton *)send{
    if (!_send) {
        _send = [UIButton buttonWithType:UIButtonTypeCustom];
        [_send setTitle:@"发送" forState:UIControlStateNormal];
        [_send setTitleColor:TitleColor forState:UIControlStateNormal];
        [_send setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _send.titleLabel.font = TitleFont;
        _send.enabled = NO;
        
        [_send addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _send;
}


- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:TitleColor forState:UIControlStateNormal];
        _cancel.titleLabel.font = TitleFont;
        [_cancel addTarget:self action:@selector(cancelSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"写评论";
        _title.font = NavTitleFont;
    }
    return _title;
}


@end
