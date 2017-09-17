//
//  YYCommentTableViewCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/4/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *commentCellId = @"comment";

@class YYInfoCommentModel;
@interface YYCommentTableViewCell : UITableViewCell

/** 评论模型*/
@property (nonatomic, copy) YYInfoCommentModel *model;

@end
