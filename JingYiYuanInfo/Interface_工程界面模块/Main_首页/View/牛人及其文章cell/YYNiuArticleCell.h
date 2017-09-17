//
//  YYNiuArticleCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNiuArticleModel;

static NSString * const YYNiuArticleCellID = @"YYNiuArticleCell";

@interface YYNiuArticleCell : UITableViewCell

/** 牛人文章的model*/
@property (nonatomic, strong) YYNiuArticleModel *niuArtModel;

@end
