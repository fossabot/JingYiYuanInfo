//
//  YYEmptyView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYEmptyView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img title:(NSString *)title viewClick:(void(^)())clickBlock;

@end
