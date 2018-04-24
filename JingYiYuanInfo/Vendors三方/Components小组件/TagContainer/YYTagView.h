//
//  YYTagView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/23.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTagView : UIView

/** 标题*/
@property (nonatomic, copy) NSString *title;

/** rightMargin*/
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat bottomMargin;

@end
