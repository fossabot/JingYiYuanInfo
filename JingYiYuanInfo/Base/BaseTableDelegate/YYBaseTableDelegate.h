//
//  YYBaseTableDelegate.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSIndexPath *indexPath);

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath);

@interface YYBaseTableDelegate : NSObject<UITableViewDelegate>

/** 高度block ，返回给FD调用*/
@property (nonatomic, copy) HeightBlock heightBlock;


- (instancetype)initWithItems:(NSArray *)items selectedBlock:(SelectedBlock)selectedBlock;

@end
