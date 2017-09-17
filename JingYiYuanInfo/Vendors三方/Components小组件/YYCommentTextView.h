//
//  YYCommentTextView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCommentTextView : UITextView<UITextViewDelegate>

@property (nonatomic,strong) NSString *placeText;
@property (nonatomic,strong) UIColor *placeColor;
@property (nonatomic,assign) BOOL Textnil;//输入框是否为空

-(instancetype)initWithFrame:(CGRect)frame PlaceText:(NSString *)placeText PlaceColor:(UIColor *)placeColor;

@end
