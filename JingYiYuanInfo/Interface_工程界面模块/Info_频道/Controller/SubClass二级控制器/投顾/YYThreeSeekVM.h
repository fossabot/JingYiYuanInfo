//
//  YYThreeSeekVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^YYThreeSeekCellSelectBlock)(NSIndexPath *indexPath, id data);

typedef void(^YYThreeSeekChangeBlock)();

@interface YYThreeSeekVM : NSObject<UITableViewDelegate,UITableViewDataSource>

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** fatherId*/
@property (nonatomic, assign) NSInteger fatherId;

/** cell select*/
@property (nonatomic, copy) YYThreeSeekCellSelectBlock cellSelectBlock;

/** 换一批 回调*/
@property (nonatomic, copy) YYThreeSeekChangeBlock changeBlock;

/**
 *  加载新数据
 */
- (void)fetchNewDataForThreeSeek:(NSInteger)fatherId completion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataForThreeSeek:(NSInteger)fatherId completion:(void(^)(BOOL success))completion;


@end
