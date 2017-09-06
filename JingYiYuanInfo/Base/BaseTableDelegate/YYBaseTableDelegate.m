//
//  YYBaseTableDelegate.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/2.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseTableDelegate.h"

@interface YYBaseTableDelegate()

/** datasources*/
@property (nonatomic, strong) NSMutableArray *items;

/** configureBlock*/
@property (nonatomic, copy) SelectedBlock selectedBlock;

/** reuseidentifier*/
@property (nonatomic, copy) NSString *reuseIdentifier;



@end

@implementation YYBaseTableDelegate

- (instancetype)initWithItems:(NSArray *)items selectedBlock:(SelectedBlock)selectedBlock {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
        self.selectedBlock = selectedBlock;
    }
    return self;
}


//- (void)setupModelOfCell:(id)cell atIndexPath:(NSIndexPath *) indexPath {
//    
//    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
//    //    cell.fd_enforceFrameLayout = NO;
//    cell.feed = self.items[indexPath.section][indexPath.row];
//    
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightBlock) {
        
        return self.heightBlock(indexPath);
    }
    return 0.f;
//    [tableView fd_heightForCellWithIdentifier:@"feedCell" cacheByIndexPath:indexPath configuration:^(XQFeedCell *cell) {
//        
//        // 在这个block中，重新cell配置数据源
//        [self setupModelOfCell:cell atIndexPath:indexPath];
//    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedBlock) {
        self.selectedBlock(indexPath);
    }
    
}

@end
