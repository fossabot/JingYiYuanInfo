//
//  YYProjectCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYProjectModel;

static NSString * const YYProjectCellId = @"YYProjectCell";

@interface YYProjectCell : UITableViewCell

/** projectModel*/
@property (nonatomic, strong) YYProjectModel *projectModel;

@end
