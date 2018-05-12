//
//  YYWebviewImageScanView.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PanDistance)(CGFloat distance);

@interface YYWebviewImageScanView : UIView

+ (void)showImages:(NSArray *)images selectedUrl:(NSString *)url;

@end

@interface ScanCell : UICollectionViewCell

/** imgUrl*/
@property (nonatomic, copy) NSString *imgUrl;

/** 手势滑动的距离*/
@property (nonatomic, copy) PanDistance distance;

@end
