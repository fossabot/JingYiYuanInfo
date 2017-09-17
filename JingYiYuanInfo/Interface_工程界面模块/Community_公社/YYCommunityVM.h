//
//  YYCommunityVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

typedef void(^NiuViewCellSelectBlock)(id cell, NSIndexPath *indexPath);
typedef void(^NiuBannerSelectBlock)(NSString *imgUrl, NSString *link);
typedef void(^NiuManListBlock)();
@interface YYCommunityVM : NSObject<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

/** 牛人轮播数据源*/
@property (nonatomic, strong) NSMutableArray *niuBannerDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

/** cell选中*/
@property (nonatomic, copy) NiuViewCellSelectBlock cellSelectedBlock;

/** banner选中*/
@property (nonatomic, copy) NiuBannerSelectBlock bannerSelectedBlock;

/** 查看更多牛人列表*/
@property (nonatomic, copy) NiuManListBlock niuManListBlock;

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;



@end
