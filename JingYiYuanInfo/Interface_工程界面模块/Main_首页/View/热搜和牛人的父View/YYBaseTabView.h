//
//  YYBaseTabView.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THBaseTableView.h"


@interface YYBaseTabView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat YYContentInsetBottom;
}
@property (nonatomic, strong) THBaseTableView *tableView;
@property (nonatomic, assign) BOOL canScroll;


@end
