//
//  YYPushCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYPushCellId = @"YYPushCell";

@class YYPushListCellModel;

typedef void(^YanBaoBlock)(NSString *yanBaoUrl);
typedef void(^ExtendBlock)(id cell, BOOL selected);

@interface YYPushCell : UITableViewCell

/** topRedLine*/
@property (nonatomic, strong) UIView *topRedLine;

/** bottomRedLine*/
@property (nonatomic, strong) UIView *bottomRedLine;

/** pushModel*/
@property (nonatomic, strong) YYPushListCellModel *pushModel;

/** ExtendBlock*/
@property (nonatomic, copy) ExtendBlock extendBlock;

/** 研报block*/
@property (nonatomic, copy) YanBaoBlock yanBaoBlock;

/** 展开cell或者闭合*/
- (void)extened;

- (void)isHaveYanBao;

@end
