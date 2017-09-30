//
//  YYCommunityMediaCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayBlock)();

static NSString * const YYCommunityMediaCellId = @"YYCommunityMediaCell";

@class YYCommunityMediaModel;

@interface YYCommunityMediaCell : UITableViewCell

/** 播放按钮回调*/
@property (nonatomic, copy) PlayBlock playBlock;

/** video模型*/
@property (nonatomic, strong) YYCommunityMediaModel *mediaModel;

/** 视频展示图片*/
@property (nonatomic, strong) UIImageView *videoImg;



@end
