//
//  YYUserInfoViewModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYUserCommonCellModel.h"

static NSString * const UITableViewCellID = @"UITableViewCell";
static NSString * const UITableViewCommonCellID = @"UITableViewCommonCell";

@protocol YYUserInfoViewModelCellDidSelectedDelegate <NSObject>

//选中cell的代理方法回调，让controller跳转其他页面
- (void)didSelectedCellAtIndexPath:(NSIndexPath *)indexPath cellType:(YYUserInfoCellType)userCellType;

@end

@interface YYUserInfoViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>





/** delegate*/
@property (nonatomic, weak) id<YYUserInfoViewModelCellDidSelectedDelegate> delegate;

- (void)getUserInfo;

- (void)uploadIconToserver:(UIImage *)image completion:(void(^)(BOOL success))completion;

- (void)changeModelAtIndexPath:(NSIndexPath *)indexPath;

@end
