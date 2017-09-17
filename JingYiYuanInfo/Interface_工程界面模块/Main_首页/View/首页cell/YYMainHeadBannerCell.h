//
//  YYMainHeadBannerCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMainHeadBannerCell;
@class YYMainHeadBannerModel;

typedef void(^BannerBlock)(NSInteger);

static NSString * const YYMainHeadBannerCellID = @"YYMainHeadBannerCell";

@interface YYMainHeadBannerCell : UITableViewCell

/** headBannerModels模型数组*/
@property (nonatomic, strong) NSArray<YYMainHeadBannerModel *> *headBannerModels;

/** bannerBlock*/
@property (nonatomic, copy) BannerBlock bannerBlock;

@end
