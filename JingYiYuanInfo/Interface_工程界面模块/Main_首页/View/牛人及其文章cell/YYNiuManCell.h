//
//  YYNiuManCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNiuManModel;

static NSString * const YYNiuManCellID = @"YYNiuManCell";

@interface YYNiuManCell : UITableViewCell

/** 牛人模型数据*/
@property (nonatomic, strong) YYNiuManModel *niuManModel;


- (void)setNiuManModel:(YYNiuManModel *)niuManModel  andIndex:(NSInteger)index;

@end
