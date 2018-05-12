//
//  YYNiuManHeader.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/11.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OpenOrCloseBlock)(BOOL selected, CGFloat height);

typedef void(^FocusChangedBlock)(NSString *focusCount); //关注或取消关注回调

@interface YYNiuManHeader : UIView

+ (instancetype)headerView;


@property (nonatomic, copy) NSString *niu_id;

/** iconName*/
@property (nonatomic, copy) NSString *icon;
/** name*/
@property (nonatomic, copy) NSString *name;
/** followVlaue*/
@property (nonatomic, copy) NSString *followVlaue;
/** hotVlaue*/
@property (nonatomic, copy) NSString *hotVlaue;
/** introduce*/
@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) OpenOrCloseBlock openOrCloseBlock;

@property (nonatomic, copy) FocusChangedBlock focusChangedBlock;

//检查关注牛人状态
- (void)checkFollowState;

@end
