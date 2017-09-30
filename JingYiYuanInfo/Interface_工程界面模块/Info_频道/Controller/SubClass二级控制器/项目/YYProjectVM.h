//
//  YYProjectVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"

typedef void(^YYProjectCellSelectBlock)(NSIndexPath *indexPath, id data);

@interface YYProjectVM : YYBaseViewModel

/** cellSelectBlock*/
@property (nonatomic, copy) YYProjectCellSelectBlock cellSelectBlock;

@end
