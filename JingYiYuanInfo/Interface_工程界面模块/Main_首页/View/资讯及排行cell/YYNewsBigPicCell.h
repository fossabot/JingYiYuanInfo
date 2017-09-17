//
//  YYNewsBigPicCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  资讯新闻的cell  图片在底部是大图的

#import <UIKit/UIKit.h>

@class YYHotInfoModel;

static NSString * const YYNewsBigPicCellId = @"YYNewsBigPicCell";

@interface YYNewsBigPicCell : UITableViewCell

/** model*/
@property (nonatomic, strong) YYHotInfoModel *hotinfoModel;

@end
