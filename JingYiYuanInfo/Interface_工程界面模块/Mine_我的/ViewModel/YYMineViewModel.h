//
//  YYMineViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYMineModel;

typedef void(^CellSelectBlock)(NSIndexPath *, NSString *, UIAlertController *);

@interface YYMineViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (YYMineModel *)modelOfIndexPath:(NSIndexPath *)indexPath;

/** cell点击事件的回调*/
@property (nonatomic, copy) CellSelectBlock cellSelecteBlock;

@end
