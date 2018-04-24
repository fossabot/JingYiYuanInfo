//
//  YYCommentCell.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/18.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCommentModel;
@class YYSecCommentModel;
@class YYCommentCell;

typedef void(^ZanBlock)(id data, YYCommentCell *cell, BOOL zanState);

typedef void(^FeedBackBlock)(id data);

static NSString * const YYCommentCellId = @"YYCommentCell";

@interface YYCommentCell : UITableViewCell

/** separatorView*/
@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, copy) ZanBlock zanBlock;

@property (nonatomic, copy) FeedBackBlock feedBackBlock;

@property (nonatomic, strong) YYCommentModel *model;

@property (nonatomic, strong) YYSecCommentModel *secModel;

@property (nonatomic, copy) NSString *fatherCommentUserName;

@end
