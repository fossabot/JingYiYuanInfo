//
//  YYEightBtn.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/5/8.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYEightBtn : UIControl

/** top*/
@property (nonatomic, copy) NSString *imageName;

/** title*/
@property (nonatomic, copy) NSString *title;

/** titleColor*/
@property (nonatomic, strong) UIColor *titleColor;

/** buttonFont*/
@property (nonatomic, assign) CGFloat buttonFont;

/** image和label之间的间距*/
@property (nonatomic, assign) CGFloat titleMargin;

/** contentMode*/
@property (nonatomic, assign) UIViewContentMode contentMode;

/** imageFrame*/
@property (nonatomic, assign) CGRect imageRect;

/** imageFrame*/
@property (nonatomic, assign) CGRect titleRect;

@end
