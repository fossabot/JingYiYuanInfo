//
//  YYFastMsgTableViewCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainRollwordsCell.h"
#import "SDCycleScrollView.h"
#import "YYMainRollwordsModel.h"
#import "YYFastMsgController.h"
#import "YYMainFastMsgDetailController.h"
#import "UIView+YYParentController.h"

@interface YYMainRollwordsCell()<SDCycleScrollViewDelegate>

/** cycleScrollView*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** imageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** more*/
@property (nonatomic, strong) UIButton *moreButton;

/** bottomLine*/
@property (nonatomic, strong) UIView *bottomLine;

/** words*/
@property (nonatomic, strong) NSMutableArray *words;


/** urls*/
//@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation YYMainRollwordsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.cycleScrollView];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.bottomLine];
        [self configLayout];
        
    }
    return self;
}

- (void)setRollwordsModels:(NSArray<YYMainRollwordsModel *> *)rollwordsModels {
    _rollwordsModels = rollwordsModels;
    self.words = [NSMutableArray array];
//    self.urls = [NSMutableArray array];
    for (YYMainRollwordsModel *model in rollwordsModels) {
        [_words addObject:model.title];
//        [_urls addObject:model.wordslink];
    }
    _cycleScrollView.titlesGroup = _words;
}

- (void)configLayout {
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(YYInfoCellCommonMargin);
        make.bottom.equalTo(-YYInfoCellCommonMargin);
        make.width.equalTo(40);
        make.height.equalTo(30);
    }];
    
    [self.cycleScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.moreButton.left).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.moreButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(40);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(kSCREENWIDTH);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
}


//跳转到更多的推送消息页面
- (void)moreFastMsg:(UIButton *)moreBtn {
    
    YYFastMsgController *fastMsgVc = [[YYFastMsgController alloc] init];
    fastMsgVc.jz_wantsNavigationBarVisible = YES;
    [self.parentNavigationController pushViewController:fastMsgVc animated:YES];
}


#pragma mark -- SDCycleScrollView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YYLog(@"选中了%ld张图片",index);
//    if (_rollwordsBlock) {
//        
//        _rollwordsBlock(index, self);
//    }
    YYMainRollwordsModel *cellModel = _rollwordsModels[index];
    YYMainFastMsgDetailController *fastDetailVc = [[YYMainFastMsgDetailController alloc] init];
    fastDetailVc.wid = cellModel.wid;
    fastDetailVc.url = [NSString stringWithFormat:@"%@%@",fastMsgDetailUrl,cellModel.wid];
    fastDetailVc.jz_wantsNavigationBarVisible = YES;
    [self.parentNavigationController pushViewController:fastDetailVc animated:YES];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.titleLabelTextFont = sysFont(14);
        _cycleScrollView.titleLabelTextColor = SubTitleColor;
//        UIColorFromHex(0xeaeaea);
        _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        _cycleScrollView.delegate = self;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.backgroundColor = WhiteColor;
        _cycleScrollView.titleLabelBackgroundColor = WhiteColor;
    }
    return _cycleScrollView;
}


- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = imageNamed(@"yyfw_main_fastmessage_40x20_");
        _leftImageView.contentMode = UIViewContentModeCenter;
    }
    return _leftImageView;
}


- (UIButton *)moreButton{
    if (!_moreButton) {
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:imageNamed(@"moreRollMsg") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreFastMsg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromHex(0xeaeaea);
    }
    return _bottomLine;
}

@end
