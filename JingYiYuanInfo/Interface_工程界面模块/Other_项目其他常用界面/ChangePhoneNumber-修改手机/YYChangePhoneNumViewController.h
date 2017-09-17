//
//  YYChangePhoneNumViewController.h
//  壹元服务
//
//  Created by VINCENT on 2017/4/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void(^Completion)();

@interface YYChangePhoneNumViewController : THBaseViewController

/** cell*/
@property (nonatomic, strong) UITableViewCell *phoneNumCell;

/** block*/
@property (nonatomic, copy) Completion completion;

@end

