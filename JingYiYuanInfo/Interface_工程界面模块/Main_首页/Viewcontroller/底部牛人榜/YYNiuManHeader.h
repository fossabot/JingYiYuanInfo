//
//  YYNiuManHeader.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/11.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OpenOrCloseBlock)(BOOL selected, CGFloat height);

@interface YYNiuManHeader : UIView

+ (instancetype)headerView;

/** iconName*/
@property (nonatomic, copy) NSString *icon;
/** name*/
@property (nonatomic, copy) NSString *name;
/** hotVlaue*/
@property (nonatomic, copy) NSString *hotVlaue;
/** introduce*/
@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) OpenOrCloseBlock openOrCloseBlock;

@end
