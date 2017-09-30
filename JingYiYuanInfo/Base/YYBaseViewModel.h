//
//  YYBaseViewModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBaseViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/** classid*/
@property (nonatomic, copy) NSString *classid;


/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;



@end
