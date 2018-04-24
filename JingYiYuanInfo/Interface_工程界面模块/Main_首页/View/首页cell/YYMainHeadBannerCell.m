//
//  YYMainHeadBannerCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainHeadBannerCell.h"
#import "SDCycleScrollView.h"
#import "YYMainHeadBannerModel.h"
#import "YYMainCycleWebviewController.h"
#import "UIView+YYParentController.h"

@interface YYMainHeadBannerCell()<SDCycleScrollViewDelegate>

/** cycleScrollView*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

/** words*/
@property (nonatomic, strong) NSMutableArray *images;

/** urls*/
//@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation YYMainHeadBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.cycleScrollView];
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self.cycleScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(kSCREENWIDTH*0.5);
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setHeadBannerModels:(NSArray *)headBannerModels {
    _headBannerModels = headBannerModels;
    self.images = [NSMutableArray array];
//    self.urls = [NSMutableArray array];
    for (YYMainHeadBannerModel *model in headBannerModels) {
        [_images addObject:model.picurl];
    }
    _cycleScrollView.imageURLStringsGroup = _images;
}

#pragma mark -- SDCycleScrollView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YYLog(@"选中了%ld张图片",index);
//    if (_bannerBlock) {
//        _bannerBlock(index);
//    }

    YYMainCycleWebviewController *cycleWeb = [[YYMainCycleWebviewController alloc] init];
    cycleWeb.url = self.headBannerModels[index].piclink;
    cycleWeb.imgUrl = self.headBannerModels[index].picurl;
    cycleWeb.jz_wantsNavigationBarVisible = YES;
    YYLog(@"url : %@",cycleWeb.url);
    [[self parentNavigationController] pushViewController:cycleWeb animated:YES];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.placeholderImage = imageNamed(placeHolderMini);
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
}



@end
