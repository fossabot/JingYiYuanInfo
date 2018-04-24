//
//  YYNiuManDetailViewController.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void(^FocusChangedBlock)();

@interface YYNiuManDetailViewController : THBaseViewController

/** imgUrl*/
@property (nonatomic, copy) NSString *imgUrl;

/** niuid*/
@property (nonatomic, copy) NSString *niuid;

/** aid 加载文章时候用的*/
@property (nonatomic, copy) NSString *aid;

/** niuName*/
@property (nonatomic, copy) NSString *niuName;
/** hotValue*/
@property (nonatomic, copy) NSString *hotValue;
/** introduce*/
@property (nonatomic, copy) NSString *introduce;


@property (nonatomic, copy) FocusChangedBlock focusChangedBlock;


@end
