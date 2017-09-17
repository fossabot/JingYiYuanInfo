//
//  YYMainPushCell.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMainPushCell;
@class YYMainPostmsgModel;

typedef void(^PostMsgBlock)();

static NSString * const YYMainPostMsgCellID = @"YYMainPostMsgCell";

@interface YYMainPushCell : UITableViewCell

/**
 "post_msg": {
 "id": "2",
 "keyword1": "5",
 "title": "安卓标题",
 "show_msg": "显示简介",
 "addtime": "2017-07-08 12:23:44"
 }
 */

/** images*/
@property (nonatomic, strong) YYMainPostmsgModel *postmsgmodel;

/** bannerBlock*/
@property (nonatomic, copy) PostMsgBlock postMsgBlock;


@end
