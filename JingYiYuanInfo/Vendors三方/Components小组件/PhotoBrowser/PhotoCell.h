//
//  PhotoCell.h
//  PhotoBrowser
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const cellId = @"photo";

typedef void(^Tap)();

@interface PhotoCell : UICollectionViewCell


- (void)setImgUrl:(NSString *)imgUrl total:(NSInteger)total index:(NSInteger)index;

/** tapblock*/
@property (nonatomic, copy) Tap tap;

@end
