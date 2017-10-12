//
//  YYSearchViewHeader.h
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


//切换标签的block
typedef void(^ChangeTagBlock)(NSInteger);

@interface YYSearchViewHeader : UIView

/** 切换标签的block*/
@property (nonatomic, copy) ChangeTagBlock changeTagBlock;

/** datas*/
@property (nonatomic, strong) NSArray *datas;


- (instancetype)initWithDatas:(NSArray *)datas;


@end
