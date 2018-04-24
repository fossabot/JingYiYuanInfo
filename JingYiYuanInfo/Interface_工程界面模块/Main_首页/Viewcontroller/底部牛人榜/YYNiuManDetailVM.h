//
//  YYNiuManDetailVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"

typedef void(^NiuNewsCellSelectBlock)(id data, NSIndexPath *indexPath);

typedef void(^HiddenHeaderBlock)(BOOL hidden);

@interface YYNiuManDetailVM : YYBaseViewModel

/** cell选中*/
@property (nonatomic, copy) NiuNewsCellSelectBlock cellSelectedBlock;

@property (nonatomic, copy) HiddenHeaderBlock hiddenHeaderBlock;

/** niuid*/
@property (nonatomic, copy) NSString *niuid;

/** aid*/
@property (nonatomic, copy) NSString *aid;

@end
