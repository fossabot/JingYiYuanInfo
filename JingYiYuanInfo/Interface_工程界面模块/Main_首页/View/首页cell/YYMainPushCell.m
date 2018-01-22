//
//  YYMainPushCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  推送消息cell  高度154

#import "YYMainPushCell.h"
//#import "BAButton.h"
#import "YYMainPostmsgModel.h"

#import "UIView+YYParentController.h"
#import "YYPushController.h"

@interface YYMainPushCell()

/** castImage*/
@property (nonatomic, strong) UIImageView *castImage;

/** castType推送类型 早餐 早评。。*/
@property (nonatomic, strong) UILabel *castType;

/** castTime推送时间*/
@property (nonatomic, strong) UILabel *castTime;

/** moreBtn更多按钮*/
@property (nonatomic, strong) UIButton *moreBtn;

/** generationView分隔线*/
@property (nonatomic, strong) UIView *generationView;

/** castTitle推送标题*/
@property (nonatomic, strong) UILabel *castTitle;

/** castDesc推送内容*/
@property (nonatomic, strong) UILabel *castDesc;

@end


@implementation YYMainPushCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubview];
    }
    return self;
}

- (void)setPostmsgmodel:(YYMainPostmsgModel *)postmsgmodel {
    _postmsgmodel = postmsgmodel;
    
    _castType.text = [self keyWord:postmsgmodel.keyword1];
    _castTime.text = postmsgmodel.addtime;
    _castTitle.text = postmsgmodel.title;
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 5;
    para.paragraphSpacing = 10;
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:postmsgmodel.remark attributes:@{NSParagraphStyleAttributeName : para                                                                                                                       }];
    _castDesc.attributedText = attr;
    
}

/**
 *  创建子控件
 */
- (void)createSubview {
    
    [self.contentView addSubview:self.castImage];
    [self.contentView addSubview:self.castType];
    [self.contentView addSubview:self.castTime];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.generationView];
    [self.contentView addSubview:self.castTitle];
    [self.contentView addSubview:self.castDesc];
    
    [self.castImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(YYInfoCellCommonMargin);
        make.left.equalTo(YYInfoCellCommonMargin);
        make.width.height.equalTo(20);
    }];
    
    [self.castType makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.castImage.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.castImage);
    }];

    [self.castTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.castType.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.castType);
    }];

    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.castTime);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];

    [self.generationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.castImage.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.castImage.left);
        make.right.equalTo(self.moreBtn.right);
        make.height.equalTo(0.8);
    }];

    [self.castTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.generationView.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(YYInfoCellCommonMargin);
        make.right.lessThanOrEqualTo(self.moreBtn.right);
    }];

    [self.castDesc makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.castTitle.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.castTitle);
        make.height.lessThanOrEqualTo(50);
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
    }];
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)more {
    
    YYPushController *push = [[YYPushController alloc] init];
    push.jz_wantsNavigationBarVisible = YES;
    push.pushId = self.postmsgmodel.postmsg_id;
    [[self parentNavigationController] pushViewController:push animated:YES];
}

#pragma mark -------  辅助方法  -------------------------

/** 返回keywords*/
- (NSString *)keyWord:(NSInteger)key {
    //keyword1:5 早餐,6早评,7上午分享,8午评,9下午分享,10收评,11夜宵,12即使通知
    switch (key) {
        case 5:
            return @"早餐";
            break;
            
        case 6:
            return @"早评";
            break;
            
        case 7:
            return @"上午分享";
            break;
            
        case 8:
            return @"午评";
            break;
            
        case 9:
            return @"下午分享";
            break;
            
        case 10:
            return @"收评";
            break;
            
        case 11:
            return @"夜宵";
            break;
            
        case 12:
            return @"即时通知";
            break;
            
        default:
            return @"即时通知";
            break;
    }
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIImageView *)castImage{
    if (!_castImage) {
        _castImage = [[UIImageView alloc] initWithImage:imageNamed(@"yyfw_main_cast_22x22_")];
    }
    return _castImage;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = SubTitleFont;
        [_moreBtn setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
        [_moreBtn setImage:imageNamed(@"more") forState:UIControlStateNormal];
//        _moreBtn.buttonPositionStyle = BAButtonPositionStyleRight;
        [_moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 16)];
        [_moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44, 0, -24)];
        [_moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)castType{
    if (!_castType) {
        _castType = [[UILabel alloc] init];
        _castType.textColor = TitleColor;
        _castType.font = TitleFont;
    }
    return _castType;
}

- (UILabel *)castTime{
    if (!_castTime) {
        _castTime = [[UILabel alloc] init];
        _castTime.textColor = SubTitleColor;
        _castTime.font = TitleFont;
    }
    return _castTime;
}

- (UILabel *)castTitle{
    if (!_castTitle) {
        _castTitle = [[UILabel alloc] init];
        _castTitle.textColor = TitleColor;
        _castTitle.font = TitleFont;
    }
    return _castTitle;
}

- (UILabel *)castDesc{
    if (!_castDesc) {
        _castDesc = [[UILabel alloc] init];
        _castDesc.textColor = SubTitleColor;
        _castDesc.font = SubTitleFont;
        _castDesc.numberOfLines = 3;
        _castDesc.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(more)];
        [_castDesc addGestureRecognizer:tap];
    }
    return _castDesc;
}

- (UIView *)generationView{
    if (!_generationView) {
        _generationView = [[UIView alloc] init];
        _generationView.backgroundColor = LightGraySeperatorColor;
    }
    return _generationView;
}

@end
