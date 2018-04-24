//
//  YYReasonView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReasonBlock)(BOOL selected);

@interface YYReasonView : UIView

/** title*/
@property (nonatomic, strong) UILabel *title;

/** selected*/
@property (nonatomic, assign) BOOL selected;


@property (nonatomic, copy) ReasonBlock reasonBlock;

@end
