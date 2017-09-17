//
//  YYShowVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YYBaseInfoCellSelectBlock)(NSIndexPath *indexPath, NSString *url);


@interface YYShowVM : NSObject<UITableViewDelegate,UITableViewDataSource>

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** cell选中*/
@property (nonatomic, copy) YYBaseInfoCellSelectBlock cellSelectedBlock;


/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;



@end
