//
//  YYFastMsgTableViewCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMainRollwordsCell;
@class YYMainRollwordsModel;

typedef void(^RollwordsBlock)(NSInteger,YYMainRollwordsCell *cell);

static NSString * const YYMainRollwordsCellID = @"YYMainRollwordsCell";

@interface YYMainRollwordsCell : UITableViewCell

/** RollwordsModels*/
@property (nonatomic, strong) NSArray<YYMainRollwordsModel *> *rollwordsModels;

/** bannerBlock*/
@property (nonatomic, copy) RollwordsBlock rollwordsBlock;


@end
