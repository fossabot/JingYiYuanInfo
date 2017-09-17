//
//  YYDetailToolBar.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  各种详情页的底部工具条（包括工具有，写评论，评论数量，收藏按钮，分享按钮，打赏按钮）可随意增删，block回调点击事件，初始化收藏按钮带状态

#import "YYDetailToolBar.h"
#import "YYCommentTextView.h"

@interface YYDetailToolBar()<UITextViewDelegate>

/** 写评论按钮*/
@property (nonatomic, strong) UIButton *writeButton;

/** leftView*/
@property (nonatomic, strong) UIView *leftView;

/** 评论列表按钮*/
@property (nonatomic, strong) UIButton *commentButton;

/** 收藏按钮*/
@property (nonatomic, strong) UIButton *favorButton;

/** 打赏按钮*/
@property (nonatomic, strong) UIButton *rewardButton;

/** 分享按钮*/
@property (nonatomic, strong) UIButton *shareButton;

/** container*/
@property (nonatomic, strong) UIView *container;

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

@implementation YYDetailToolBar
{
    UIView *coverView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _placeHolder = @"写评论";
        _toolBarType = DetailToolBarTypeWriteComment;
        _isFavor = NO;
        self.container = [[UIView alloc] init];
        [self addSubview:self.container];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setToolBarType:(DetailToolBarType)toolBarType {
    
    _toolBarType = toolBarType;
    
    if (toolBarType & DetailToolBarTypeWriteComment) {
        [self addSubview:self.leftView];
        
    }
    
    if (toolBarType & DetailToolBarTypeReward) {
        [self.container addSubview:self.rewardButton];
        
    }
    
    if (toolBarType & DetailToolBarTypeComment) {
        [self.container addSubview:self.commentButton];
        
    }
    
    if (toolBarType & DetailToolBarTypeFavor) {
        [self.container addSubview:self.favorButton];
        
    }
    
    if (toolBarType & DetailToolBarTypeShare) {
        [self.container addSubview:self.shareButton];
        
    }
    
}


- (void)layoutSubviews {

    [self.container.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    [self.container.subviews makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.container.top).offset(2);
        make.bottom.equalTo(self.container.bottom).offset(-2);
        make.width.equalTo(40);
    }];
    
    [self.container makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.top.bottom.equalTo(self);
    }];
    
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.top).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self.container.left);
    }];
    
    [self.writeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(5);
        make.centerY.equalTo(self.leftView);
    }];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)changeTextFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval boardAnimationDuration=[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardEndY = keyBoardFrame.origin.y;
    NSLog(@"frame:%@",NSStringFromCGRect(keyBoardFrame));
    
    [UIView animateWithDuration:boardAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _textViewContainer.frame;
        frame.origin.y = keyBoardEndY - 100;
        _textViewContainer.frame = frame;
        NSLog(@"_textViewContainerframe:%@",NSStringFromCGRect(_textViewContainer.frame));
    } completion:nil];
    
}


/** 辞去第一响应者，自动移出输入框*/
- (void)resignResponder {
    
    [self.textView resignFirstResponder];
    [coverView removeFromSuperview];
}

/** 弹出评论框，写评论*/
- (void)write {
    
    BOOL isConnect = [YYHttpNetworkTool globalNetStatusNotice];
    if (!isConnect) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return;
    }
    
    coverView = [[UIView alloc] initWithFrame:self.superview.bounds];
    [self.superview addSubview:coverView];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [coverView addGestureRecognizer:tap];
    
    [self.superview addSubview:self.textViewContainer];
    [self.textView becomeFirstResponder];
    
}

/** 跳转评论页*/
- (void)comment {
    
    BOOL isConnect = [YYHttpNetworkTool globalNetStatusNotice];
    if (!isConnect) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return;
    }
    if (_selectBlock) {
        _selectBlock(DetailToolBarTypeComment);
    }
}

/** 收藏*/
- (void)favor {
    
    BOOL isConnect = [YYHttpNetworkTool globalNetStatusNotice];
    if (!isConnect) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return;
    }
    if (_selectBlock) {
        _selectBlock(DetailToolBarTypeFavor);
    }
}

/** 打赏*/
- (void)reward {
    
    BOOL isConnect = [YYHttpNetworkTool globalNetStatusNotice];
    if (!isConnect) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return;
    }
    if (_selectBlock) {
        _selectBlock(DetailToolBarTypeReward);
    }
}

/** 分享*/
- (void)share {
    
    if (_selectBlock) {
        _selectBlock(DetailToolBarTypeShare);
    }
}

/** 发送评论*/
- (void)sendComment {
    
    BOOL isConnect = [YYHttpNetworkTool globalNetStatusNotice];
    if (!isConnect) {
        //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
        return;
    }
    if (_sendCommentBlock) {
        _sendCommentBlock(self.textView.text);
    }
    
}

- (void)cancelSend {
    
    [self resignResponder];
}

#pragma mark ------- textView的代理方法  -------------------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.send.enabled = textView.text.length ? YES : NO;
    
    return YES;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.layer.cornerRadius = 15;
        _leftView.layer.masksToBounds = YES;
        _leftView.backgroundColor = [UIColor orangeColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(write)];
        [_leftView addGestureRecognizer:tap];
        [_leftView addSubview:self.writeButton];
    }
    return _leftView;
}

- (UIButton *)writeButton{
    if (!_writeButton) {
        _writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeButton addTarget:self action:@selector(write) forControlEvents:UIControlEventTouchUpInside];
        [_writeButton setImage:imageNamed(@"article_write_20x20_") forState:UIControlStateNormal];
        [_writeButton setTitle:@"写评论" forState:UIControlStateNormal];
        _writeButton.titleLabel.font = TitleFont;
        [_writeButton setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
    }
    return _writeButton;
}

- (UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:imageNamed(@"article_comment_22x22_") forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)rewardButton{
    if (!_rewardButton) {
        _rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rewardButton setImage:imageNamed(@"article_reward_22x22_") forState:UIControlStateNormal];
        [_rewardButton addTarget:self action:@selector(reward) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rewardButton;
}

- (UIButton *)favorButton{
    if (!_favorButton) {
        _favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favorButton setImage:imageNamed(@"article_collection_unselected_22x22_") forState:UIControlStateNormal];
        [_favorButton setImage:imageNamed(@"article_collection_selected_22x22_") forState:UIControlStateSelected];
        [_favorButton addTarget:self action:@selector(favor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorButton;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:imageNamed(@"article_share_22x22_") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}


- (UIView *)textViewContainer{
    if (!_textViewContainer) {
        _textViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 100)];
        _textViewContainer.backgroundColor = GrayBackGroundColor;
        [_textViewContainer addSubview:self.title];
        [_textViewContainer addSubview:self.cancel];
        [_textViewContainer addSubview:self.send];
        [_textViewContainer addSubview:self.textView];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.textViewContainer);
            make.top.offset(YYInfoCellSubMargin);
        }];
        [self.cancel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(YYInfoCellCommonMargin);
            make.top.offset(YYInfoCellSubMargin);
        }];
        [self.send makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-YYInfoCellCommonMargin);
            make.top.offset(YYInfoCellSubMargin);
        }];
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancel.left);
            make.right.equalTo(self.send.right);
            make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
            make.bottom.offset(-YYInfoCellCommonMargin);
        }];
    }
    return _textViewContainer;
}


- (YYCommentTextView *)textView{
    if (!_textView) {
        _textView = [[YYCommentTextView alloc] initWithFrame:CGRectMake(0, kSCREENHEIGHT, kSCREENWIDTH, 100) PlaceText:_placeHolder PlaceColor:[UIColor lightGrayColor]];
        _textView.delegate = self;
    }
    return _textView;
}


- (UIButton *)send{
    if (!_send) {
        _send = [UIButton buttonWithType:UIButtonTypeCustom];
        [_send setTitle:@"发送" forState:UIControlStateNormal];
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
