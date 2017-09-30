//
//  YYCommunityPersonVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"
#import <SDCycleScrollView/SDCycleScrollView.h>


typedef void(^NiuNewsCellSelectBlock)(id data, NSIndexPath *indexPath);
typedef void(^NiuBannerSelectBlock)(NSString *imgUrl, NSString *link);
typedef void(^NiuManListBlock)();

@interface YYCommunityPersonVM : YYBaseViewModel<SDCycleScrollViewDelegate>

/** 牛人轮播数据源*/
@property (nonatomic, strong) NSMutableArray *niuBannerDataSource;


/** cell选中*/
@property (nonatomic, copy) NiuNewsCellSelectBlock cellSelectedBlock;

/** banner选中*/
@property (nonatomic, copy) NiuBannerSelectBlock bannerSelectedBlock;

/** 查看更多牛人列表*/
@property (nonatomic, copy) NiuManListBlock niuManListBlock;



@end
