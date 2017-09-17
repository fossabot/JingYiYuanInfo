//
//  YYHotHeader.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//换一批的block
typedef void(^ChangeBlock)();

//切换标签的block
typedef void(^ChangeTagBlock)(NSInteger);

@interface YYHotHeader : UIView

/** 换一批block*/
@property (nonatomic, copy) ChangeBlock changeBlock;

/** 切换标签的block*/
@property (nonatomic, copy) ChangeTagBlock changeTagBlock;

/** datas*/
@property (nonatomic, strong) NSArray *datas;


- (instancetype)initWithDatas:(NSArray *)datas;



@end
