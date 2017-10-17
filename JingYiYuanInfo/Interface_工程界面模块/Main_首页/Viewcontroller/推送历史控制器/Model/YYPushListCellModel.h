//
//  YYPushListCellModel.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPushListCellModel : NSObject

/** pushId*/
@property (nonatomic, copy) NSString *pushId;

/** keyword1  早餐早评。。。*/
@property (nonatomic, copy) NSString *keyword1;

/** remark 普通推送消息的主体内容*/
@property (nonatomic, copy) NSString *remark;

/** fxtime 分享时间*/
@property (nonatomic, copy) NSString *fxtime;

/** dmname代码名称*/
@property (nonatomic, copy) NSString *dmname;

/** fxcontent分享理由*/
@property (nonatomic, copy) NSString *fxcontent;

/** Section介入区间*/
@property (nonatomic, copy) NSString *Section;

/** fxmoney分享时价格*/
@property (nonatomic, copy) NSString *fxmoney;

/** zsmoney止损价格*/
@property (nonatomic, copy) NSString *zsmoney;

/** mention温馨提示*/
@property (nonatomic, copy) NSString *mention;

/** checktime 推送的时间*/
@property (nonatomic, copy) NSString *checktime;

/** extendState展开状态  默认是NO*/
@property (nonatomic, assign) BOOL extendState;

/** 是否有展开按钮*/
@property (nonatomic, assign) BOOL isHaveExtendBtn;

@property (nonatomic, assign) NSInteger lines;

/**
 *  获取内容的属性字符串
 */
- (NSString *)pushAttributedString;

/**
 *  cell的高度
 */
- (CGFloat)cellHeight;

@end
