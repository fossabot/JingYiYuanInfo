//
//  YYProdutionVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YYProductionType) {
    YYProductionTypeVIP,
    YYProductionTypeNormal,
    YYProductionTypeCompany
};

typedef void(^YYProductionCellSelectBlock)(YYProductionType cellType, NSIndexPath *indexPath, id data);


@interface YYProductionVM : NSObject<UITableViewDelegate,UITableViewDataSource>

/** classid*/
@property (nonatomic, copy) NSString *classid;

/** cellSelect block*/
@property (nonatomic, copy) YYProductionCellSelectBlock productionSelectBlock;

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;


@end
