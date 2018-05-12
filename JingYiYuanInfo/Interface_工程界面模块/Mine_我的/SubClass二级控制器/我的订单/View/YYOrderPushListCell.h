//
//  YYOrderPushListCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/30.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const YYOrderPushListCellId = @"YYOrderPushListCell";

typedef void(^YanbaoBlock)();

typedef void(^RecordBlock)(id data);

@interface YYOrderPushListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

@property (nonatomic, copy) NSString *yanbaoUrl;

@property (nonatomic, copy) YanbaoBlock yanbaoBlock;

@property (nonatomic, copy) RecordBlock recordDetailBlock;

@end
