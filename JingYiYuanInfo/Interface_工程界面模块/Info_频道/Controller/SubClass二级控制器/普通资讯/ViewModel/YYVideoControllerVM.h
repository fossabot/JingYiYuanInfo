//
//  YYVideoControllerVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYVideoControllerVM : NSObject

/**
 *  加载推荐数据
 */
- (void)fetchRecommendDataCompletion:(void(^)(BOOL success))completion;


@end
