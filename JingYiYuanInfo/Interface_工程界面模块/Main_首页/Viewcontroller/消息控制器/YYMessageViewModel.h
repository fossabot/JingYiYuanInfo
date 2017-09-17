//
//  YYMessageViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/9/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CellSelectBlock)(NSString *, NSString *);

@interface YYMessageViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/** cell点击回调*/
@property (nonatomic, copy) CellSelectBlock cellSelectBlock;

/**
 *  刷新数据
 */
- (void)loadNewDataCompletion:(void(^)(BOOL success))completion;

/**
 *  加载更多数据
 */
- (void)loadMoreDataCompletion:(void(^)(BOOL success))completion;

@end
