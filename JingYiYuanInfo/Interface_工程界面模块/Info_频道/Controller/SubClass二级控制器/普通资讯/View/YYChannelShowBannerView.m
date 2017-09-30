//
//  YYChannelShowBannerCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelShowBannerView.h"
#import "YYShowOtherDetailController.h"
#import "UIView+YYParentController.h"
#import "YYShowBannerModel.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface YYChannelShowBannerView()<SDCycleScrollViewDelegate>

/** banner*/
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@end

@implementation YYChannelShowBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubView];
    }
    return self;
}

/**
 *  加载子控件
 */
- (void)configSubView {
    
    [self addSubview:self.sdCycleScrollView];
    [self.sdCycleScrollView makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self);
        make.height.equalTo(kSCREENWIDTH*0.6);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark -------  轮播组件的代理方法 -------------------------------

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    YYShowOtherDetailController *otherDetail = [[YYShowOtherDetailController alloc] init];
    YYShowBannerModel *bannerModel = self.dataSource[index];
    otherDetail.url = bannerModel.piclink;
    otherDetail.shareImgUrl = bannerModel.picurl;
    [self.parentNavigationController pushViewController:otherDetail animated:YES];
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (SDCycleScrollView *)sdCycleScrollView{
    if (!_sdCycleScrollView) {
        _sdCycleScrollView = [[SDCycleScrollView alloc] init];
        _sdCycleScrollView.delegate = self;
        _sdCycleScrollView.placeholderImage = imageNamed(@"placeholder");
    }
    return _sdCycleScrollView;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (YYShowBannerModel *model in dataSource) {
        [arr addObject:model.picurl];
    }
    [self.sdCycleScrollView setImageURLStringsGroup:arr];
    
}


@end
