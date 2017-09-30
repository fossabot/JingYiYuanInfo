//
//  UITableView+YYEmptyData.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YYEmptyData)

/* 占位图 */
@property (nonatomic, strong) UIView *placeHolderView;

- (void)tableViewDisplayWitMsg:(NSString *)message image:(NSString *)image ifNecessaryForRowCount:(NSUInteger)rowCount;


@end
