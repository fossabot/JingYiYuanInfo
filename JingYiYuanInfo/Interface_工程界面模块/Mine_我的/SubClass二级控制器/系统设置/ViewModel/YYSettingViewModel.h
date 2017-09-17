//
//  YYSettingViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CellSelectBlock)(NSIndexPath *indexPath);

@interface YYSettingViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/** cellSelectBlock*/
@property (nonatomic, copy) CellSelectBlock cellSelectBlock;


/**
 改变cell的值

 @param indexPath IndexPath
 */
- (void)changeCellModelAtIndexPath:(NSIndexPath *)indexPath;

@end
