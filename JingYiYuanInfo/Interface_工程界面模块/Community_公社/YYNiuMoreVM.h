//
//  YYNiuMoreVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"


typedef void(^NiuManCellSelectBlock)(id data, NSIndexPath *indexPath);

@interface YYNiuMoreVM : YYBaseViewModel

/** cell选中*/
@property (nonatomic, copy) NiuManCellSelectBlock cellSelectedBlock;

@end
