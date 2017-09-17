//
//  YYUserIconCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  YYUserIconCellID @"YYUserIconCell"

typedef void(^IconBlock)();

@interface YYUserIconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *icon;

/** iconBlock*/
@property (nonatomic, copy) IconBlock iconBlock;

@end
