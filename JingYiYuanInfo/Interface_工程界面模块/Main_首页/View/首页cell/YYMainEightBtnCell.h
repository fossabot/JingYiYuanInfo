//
//  YYMainEightBtnCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMainEightBtnCell;

typedef void(^EightBtnBlock)(NSInteger, YYMainEightBtnCell *cell);

static NSString * const YYMainEightBtnCellID = @"YYMainEightBtnCell";

@interface YYMainEightBtnCell : UITableViewCell

/** eightBlock*/
@property (nonatomic, copy) EightBtnBlock eightBtnBlock;
    
@end
