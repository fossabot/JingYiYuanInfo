//
//  YYBaseTableDataSource.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfigureBlock)(id cell, NSIndexPath *indexPath, id model);

@interface YYBaseTableDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items configureBlock:(ConfigureBlock)configureBlock;

@end
