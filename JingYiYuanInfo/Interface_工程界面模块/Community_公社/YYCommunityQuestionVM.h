//
//  YYCommunityQuestionVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseViewModel.h"

typedef void(^CommunityCellSelectBlock)(id data, NSIndexPath *indexPath);

@interface YYCommunityQuestionVM : YYBaseViewModel

/** CommunityCellSelectBlock*/
@property (nonatomic, copy) CommunityCellSelectBlock cellSelectedBlock;

@end
