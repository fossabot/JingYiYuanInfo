//
//  YYCommentCell.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/18.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommentCell.h"
#import "YYCommentModel.h"
#import "YYSecCommentModel.h"
#import "YYUser.h"
#import "UIView+YYCategory.h"
#import "UIImage+Category.h"

@interface YYCommentCell()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *feedBack;
@property (nonatomic, strong) UIButton *zan;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UILabel *time;

@end


@implementation YYCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];
    }
    return self;
}

/* 配置子控件*/
- (void)configSubView {
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = GraySeperatorColor;
    [self.contentView addSubview:separatorView];
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:imageNamed(placeHolderAvatar)];
    self.avatar = avatar;
    [self.contentView addSubview:avatar];
    
    UILabel *name = [[UILabel alloc] init];
    name.textColor = UnenableTitleColor;
    name.font = SubTitleFont;
    self.name = name;
    [self.contentView addSubview:name];
    
    UIButton *zan = [UIButton buttonWithType:UIButtonTypeCustom];
    zan.titleLabel.font = UnenableTitleFont;
    [zan setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [zan setImage:imageNamed(@"article_ comment_ praise_normal_20x20_") forState:UIControlStateNormal];
    [zan setImage:imageNamed(@"article_ comment_ praise_highlighted_20x20_") forState:UIControlStateHighlighted];
    [zan setImage:imageNamed(@"article_ comment_ praise_selected_20x20_") forState:UIControlStateSelected];
    [zan setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
    [zan setTitleColor:UnenableTitleColor forState:UIControlStateSelected];
    [zan addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    self.zan = zan;
    [self.contentView addSubview:zan];
    
    
    UIButton *feedBack = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBack.titleLabel.font = UnenableTitleFont;
    [feedBack setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
    [feedBack setTitle:@"回复" forState:UIControlStateNormal];
    [feedBack addTarget:self action:@selector(feedBackOther:) forControlEvents:UIControlEventTouchUpInside];
    self.feedBack = feedBack;
    [self.contentView addSubview:feedBack];
    
    UILabel *comment = [[UILabel alloc] init];
    comment.textColor = SubTitleColor;
    comment.font = TitleFont;
    comment.numberOfLines = 0;
    self.comment = comment;
    [self.contentView addSubview:comment];
    
    UILabel *time = [[UILabel alloc] init];
    time.textColor = UnenableTitleColor;
    time.font = UnenableTitleFont;
    self.time = time;
    [self.contentView addSubview:time];
    
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-1);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(0.5);
    }];
    
    [self.avatar makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.width.height.equalTo(30);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatar.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.avatar);
    }];
    
    [self.zan makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.avatar);
    }];
    
    [self.feedBack makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.zan.left).offset(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.zan);
    }];
    
    [self.comment makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatar.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.name);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.top.equalTo(self.comment.bottom).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
//    [self.contentView layoutIfNeeded];
//    [self.avatar cutRoundView];
    
}




- (void)setModel:(YYCommentModel *)model {
    
    _model = model;
//    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:imageNamed(placeHolderAvatar)];
    YYWeakSelf
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:imageNamed(placeHolderAvatar) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
     
        if (image == nil) return;
        
//        CGSize size = CGSizeMake(30, 30);
        // NO透明
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
        
        // 获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 添加一个圆
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextAddEllipseInRect(ctx, rect);
        
        // 裁剪
        CGContextClip(ctx);
        
        // 将图片画上去
//        weakSelf.avatar 
        [image drawInRect:rect];
        
        UIImage *image0 = UIGraphicsGetImageFromCurrentImageContext();
        weakSelf.avatar.image = image0;
        //结束上下文
        UIGraphicsEndImageContext();
    }];
    
    self.name.text = model.username;
    [self.zan setTitle:model.zan_count forState:UIControlStateNormal];
    self.zan.selected = [model.flag integerValue];
    self.comment.text = model.reply_msg;
    self.time.text = model.create_date;
    
//    [self.contentView layoutIfNeeded];
//    [self.avatar cutRoundView];
}

- (void)setSecModel:(YYSecCommentModel *)secModel {
    
    _secModel = secModel;
    YYWeakSelf
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:secModel.from_user_avatar] placeholderImage:imageNamed(placeHolderAvatar) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image == nil) return;
        
        //        CGSize size = CGSizeMake(30, 30);
        // NO透明
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
        
        // 获得上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 添加一个圆
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextAddEllipseInRect(ctx, rect);
        
        // 裁剪
        CGContextClip(ctx);
        
        // 将图片画上去
        //        weakSelf.avatar
        [image drawInRect:rect];
        
        UIImage *image0 = UIGraphicsGetImageFromCurrentImageContext();
        weakSelf.avatar.image = image0;
        //结束上下文
        UIGraphicsEndImageContext();
    }];
    
    if ([_secModel.to_user_name isEqualToString:_fatherCommentUserName]) {
        
        self.name.text = secModel.from_user_name;
    }else {
        self.name.text = secModel.name;
    }
    [self.zan setTitle:secModel.zan_count forState:UIControlStateNormal];
    self.zan.selected = [secModel.flag integerValue];
    self.comment.text = secModel.reply_msg;
    self.time.text = secModel.create_date;
    
//    [self.contentView layoutIfNeeded];
//    [self.avatar cutRoundView];
}

/*  点赞*/
- (void)likeComment:(UIButton *)sender {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账号"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    if (_zanBlock) {
        if (_model) {
            
            _zanBlock(_model, self, !sender.selected);
        }else if (_secModel) {
            
            _zanBlock(_secModel, self, !sender.selected);
        }
    }
    
    NSInteger zanCount = [_model.zan_count integerValue];
    if (sender.selected) {//取消点赞  -1
        
        _model.zan_count = [NSString stringWithFormat:@"%ld",zanCount-1];
        _model.flag = @"0";
        
    }else {//点赞  +1
        
        _model.zan_count = [NSString stringWithFormat:@"%ld",zanCount+1];
        _model.flag = @"1";
        
    }
    
    [sender setTitle:_model.zan_count forState:UIControlStateNormal];
    [sender setTitle:_model.zan_count forState:UIControlStateSelected];
    
    sender.selected = !sender.selected;
    
}

/* 回复按钮点击事件*/
- (void)feedBackOther:(UIButton *)sender {

    YYLogFunc
    if (_feedBackBlock) {
        if (_model) {
            
            _feedBackBlock(_model);
        }else if (_secModel) {
            
            _feedBackBlock(_secModel);
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.avatar cutRoundView];
}

//
//- (void)layoutSublayersOfLayer:(CALayer *)layer {
//    
//    [self.avatar cutRoundView];
//}


@end
