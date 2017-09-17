//
//  YYTitleView.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);

@interface YYTitleView : UIView

- (instancetype)initWithTitles:(NSArray *)titles;

/** 选中item的回调*/
@property (nonatomic, copy) SelectedBlock selectedBlock;

@end
