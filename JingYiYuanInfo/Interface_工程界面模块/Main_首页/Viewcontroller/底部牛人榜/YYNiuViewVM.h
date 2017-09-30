//
//  YYNiuViewVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YYNiuViewCellSelectBlock)(id data, NSIndexPath *indexPath);

@interface YYNiuViewVM : NSObject<UITableViewDelegate,UITableViewDataSource>

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

/** cell选中*/
@property (nonatomic, copy) YYNiuViewCellSelectBlock selectedBlock;

@property (nonatomic, assign) BOOL canScroll;

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;

@end
