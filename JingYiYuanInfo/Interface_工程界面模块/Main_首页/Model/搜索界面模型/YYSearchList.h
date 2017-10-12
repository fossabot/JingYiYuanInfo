//
//  YYSearchList.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYSearchModel;

@interface YYSearchList : NSObject


/** 资讯文章*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *art_arr;

/** 视频*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *vid_arr;

/** 演出*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *sh_arr;

/** 牛人文章*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *nar_arr;

/** 项目*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *sm_arr;

/** 三找*/
@property (nonatomic, strong) NSArray<YYSearchModel *> *sa_arr;



@end
