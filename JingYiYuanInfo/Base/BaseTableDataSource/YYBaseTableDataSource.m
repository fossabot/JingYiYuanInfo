//
//  YYBaseTableDataSource.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseTableDataSource.h"

@interface YYBaseTableDataSource()

/** datasources*/
@property (nonatomic, strong) NSMutableArray *items;

/** configureBlock*/
@property (nonatomic, copy) ConfigureBlock configureBlock;

/** reuseidentifier*/
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation YYBaseTableDataSource


- (instancetype)initWithItems:(NSArray *)items configureBlock:(ConfigureBlock)configureBlock {
    
    self = [super init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
        self.configureBlock = configureBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return _items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    _configureBlock(cell, indexPath, item);
    return cell;
}

@end
