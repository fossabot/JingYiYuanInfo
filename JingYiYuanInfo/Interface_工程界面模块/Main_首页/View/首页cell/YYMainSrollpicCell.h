//
//  YYMainSrollpicCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMainSrollpicCell;
@class YYMainSrollpicModel;

typedef void(^SrollpicBlock)(NSInteger index, YYMainSrollpicCell *cell);

static NSString * const YYMainSrollpicCellID = @"YYMainSrollpicCell";

@interface YYMainSrollpicCell : UITableViewCell

/** srollpicModels*/
@property (nonatomic, strong) NSArray<YYMainSrollpicModel *> *srollpicModels;

/** bannerBlock*/
@property (nonatomic, copy) SrollpicBlock srollpicBlock;


@end
