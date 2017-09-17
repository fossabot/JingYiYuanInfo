//
//  ChannelCollectionReusableView.h
//  复杂tableviewcell搭建思路实现
//
//  Created by VINCENT on 2017/7/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreBlock)();

static NSString * const headerIdentifier = @"header";

@interface ChannelCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** block*/
@property (nonatomic, copy) MoreBlock moreBlock;

@end
