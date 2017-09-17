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

@interface YYMainRollwordsCell()<SDCycleScrollViewDelegate>

/** cycleScrollView*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** imageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

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
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
    }];
}


#pragma mark -- SDCycleScrollView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YYLog(@"选中了%ld张图片",index);
    if (_rollwordsBlock) {
        
        _rollwordsBlock(index, self);
    }
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.titleLabelTextFont = sysFont(14);
        _cycleScrollView.titleLabelTextColor = TitleColor;
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

@end
