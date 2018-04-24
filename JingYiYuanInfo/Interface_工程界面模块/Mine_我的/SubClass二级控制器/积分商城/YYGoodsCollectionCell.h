//
//  YYGoodsCollectionCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYEdgeLabel.h"

static NSString * const YYGoodsCollectionCellId = @"YYGoodsCollectionCell";

@interface YYGoodsCollectionCell : UICollectionViewCell

/** borderView*/
@property (nonatomic, strong) UIView *borderView;

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** tag*/
@property (nonatomic, strong) YYEdgeLabel *tagLabel;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** integration*/
@property (nonatomic, strong) UILabel *integration;

@end
