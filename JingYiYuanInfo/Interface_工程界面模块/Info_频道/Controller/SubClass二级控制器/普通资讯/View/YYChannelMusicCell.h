//
//  YYChannelMusicCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBaseMusicModel;

static NSString * const YYChannelMusicCellId = @"YYChannelMusicCell";

@interface YYChannelMusicCell : UITableViewCell

/** 音乐模型*/
@property (nonatomic, strong) YYBaseMusicModel *musicModel;

@end
