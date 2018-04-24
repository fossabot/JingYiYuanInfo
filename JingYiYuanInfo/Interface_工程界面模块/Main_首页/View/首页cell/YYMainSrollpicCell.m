//
//  YYMainSrollpicCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainSrollpicCell.h"
#import "SDCycleScrollView.h"
#import "YYMainSrollpicModel.h"
#import "YYMainScrollPicDetailController.h"

#import "UIView+YYParentController.h"

@interface YYMainSrollpicCell()<SDCycleScrollViewDelegate>

/** cycleScrollView*/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

/** images*/
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation YYMainSrollpicCell

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
        make.height.equalTo(kSCREENWIDTH*0.2);
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setSrollpicModels:(NSArray<YYMainSrollpicModel *> *)srollpicModels {
    _srollpicModels = srollpicModels;
    self.images = [NSMutableArray array];
    for (YYMainSrollpicModel *model in srollpicModels) {
        [self.images addObject:model.picurl];
    }
    _cycleScrollView.imageURLStringsGroup = self.images;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _cycleScrollView.bounds = self.contentView.bounds;
}



#pragma mark -- SDCycleScrollView delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    YYLog(@"选中了%ld张图片",index);
//    if (_srollpicBlock) {
//        
//        _srollpicBlock(index, self);
//    }
    YYMainScrollPicDetailController *detailVc = [[YYMainScrollPicDetailController alloc] init];
    detailVc.jz_wantsNavigationBarVisible = YES;
    detailVc.url = self.srollpicModels[index].piclink;
    detailVc.shareImgUrl = self.srollpicModels[index].picurl;
    [self.parentNavigationController pushViewController:detailVc animated:YES];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.placeholderImage = imageNamed(placeHolderMini);
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.delegate = self;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
}

@end
