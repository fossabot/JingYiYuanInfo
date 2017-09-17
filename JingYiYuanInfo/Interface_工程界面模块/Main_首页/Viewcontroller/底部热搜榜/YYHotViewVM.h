//
//  YYHotViewVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YYHotViewCellSelectBlock)(NSInteger picstate, id data, NSIndexPath *indexPath);

@interface YYHotViewVM : NSObject<UITableViewDelegate,UITableViewDataSource>

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** 当前的urlkey*/
@property (nonatomic, assign) NSInteger urlKey;

/** headerDataSource*/
@property (nonatomic, strong) NSMutableArray *headerDataSource;

/** cell选中*/
@property (nonatomic, copy) YYHotViewCellSelectBlock selectedBlock;

@property (nonatomic, assign) BOOL canScroll;

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;

/**
 *  切换tag时，重新加载该标签的数据
 */
- (void)selectedTag:(NSInteger)tag completion:(void(^)(BOOL success))completion;

/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;



@end
