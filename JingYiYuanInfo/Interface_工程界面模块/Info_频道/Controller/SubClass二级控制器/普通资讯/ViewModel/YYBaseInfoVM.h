//
//  YYBaseInfoVM.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YYBaseInfoType) { //资讯里的cell数据类型
    YYBaseInfoTypeRank,     //排行
    YYBaseInfoTypeNews,     //普通新闻资讯
    YYBaseInfoTypeNewsPics, //多图新闻
    YYBaseInfoTypeVideo,    //视频
    YYBaseInfoTypeMusic,    //音乐
    YYBaseInfoTypeShow      //演出
};


typedef void(^YYBaseInfoCellSelectBlock)(YYBaseInfoType cellType, NSIndexPath *indexPath, id data);
typedef void(^YYBaseInfoMoreBlock)(NSString *lastid, NSString *classid);

@interface YYBaseInfoVM : NSObject<UITableViewDelegate,UITableViewDataSource>


/** classid*/
@property (nonatomic, copy) NSString *classid;

/** bannerDataSource*/
@property (nonatomic, strong) NSMutableArray *bannerDataSource;

/** infoDataSource*/
@property (nonatomic, strong) NSMutableArray *infoDataSource;

/** cell选中*/
@property (nonatomic, copy) YYBaseInfoCellSelectBlock cellSelectedBlock;

/** 查看更多排行*/
@property (nonatomic, copy) YYBaseInfoMoreBlock moreBlock;



/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion;


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion;

/**
 *  重置播放器
 */
- (void)resetPlayer;

/**
 *  重置播放时间
 */
- (void)resetSeekTime;

/**
 *  删除不喜欢的资讯的模型
 */
- (void)deleteRow:(NSInteger)row;

@end
