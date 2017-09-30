//
//  YYCommunityMediaVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityMediaVM.h"
#import "YYCommunityMediaCell.h"
#import "YYCommunityMediaModel.h"

#import <MJExtension/MJExtension.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFPlayer.h"


@interface YYCommunityMediaVM()

/** lastid*/
@property (nonatomic, copy)   NSString       *lastid;

/** rankDataSource*/
@property (nonatomic, strong) NSMutableArray *mediaDataSource;

/** ZFPlayerView*/
@property (nonatomic, strong) ZFPlayerView   *playerView;

/** playerModel*/
@property (nonatomic, strong) ZFPlayerModel  *playerModel;


@end
@implementation YYCommunityMediaVM


/**
 *  重置播放器
 */
- (void)resetPlayer {
    
    if (_playerView.state == ZFPlayerStatePlaying) {
        
        [_playerView resetPlayer];
    }
}

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    //banner接口
    NSDictionary *bannerPara = [NSDictionary dictionaryWithObjectsAndKeys:@"cvideo", @"act", nil];
    [PPNetworkHelper GET:communityUrl parameters:bannerPara responseCache:^(id responseCache) {
        
        if (!self.mediaDataSource.count && responseCache) {
            self.mediaDataSource = [YYCommunityMediaModel mj_objectArrayWithKeyValuesArray:responseCache[@"v_arr"]];
            self.lastid = responseCache[@"lastid"];
            completion(YES);
        }else{
            completion(NO);
        }
        
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.mediaDataSource = [YYCommunityMediaModel mj_objectArrayWithKeyValuesArray:responseObject[@"v_arr"]];
            self.lastid = responseObject[@"lastid"];
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"cvideomore",@"act",self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            
            [self.mediaDataSource addObjectsFromArray:[YYCommunityMediaModel mj_objectArrayWithKeyValuesArray:response[@"v_arr"]]];
            self.lastid = response[@"lastid"];
            completion(YES);
        }else {
            
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}


#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mediaDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommunityMediaModel *model = self.mediaDataSource[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:YYCommunityMediaCellId cacheByIndexPath:indexPath configuration:^(YYCommunityMediaCell *cell) {
        cell.mediaModel = model;
    }];

}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YYCommunityMediaCell * cell = [tableView dequeueReusableCellWithIdentifier:YYCommunityMediaCellId];
    YYCommunityMediaModel *model = self.mediaDataSource[indexPath.row];
    [cell setMediaModel:model];
    __block NSIndexPath *weakIndexPath = indexPath;
    __block YYCommunityMediaCell *weakCell = cell;
    
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:model.v_url];
    YYWeakSelf
    // 点击播放的回调
    cell.playBlock = ^{
        
        YYStrongSelf
        strongSelf.playerModel.title            = model.v_name;
        strongSelf.playerModel.videoURL         = videoURL;
        strongSelf.playerModel.placeholderImage = imageNamed(@"loading_bgView");
        strongSelf.playerModel.placeholderImageURLString = model.v_picture;
        strongSelf.playerModel.scrollView       = tableView;
        strongSelf.playerModel.indexPath        = weakIndexPath;
        // player的父视图tag
        strongSelf.playerModel.fatherViewTag    = weakCell.videoImg.tag;
        // 设置播放控制层和model
        [strongSelf.playerView playerControlView:nil playerModel:strongSelf.playerModel];
        // 下载功能
        strongSelf.playerView.hasDownload = NO;
        strongSelf.playerView.hasPreviewView = NO;
        // 自动播放
        [strongSelf.playerView autoPlayTheVideo];
        
    };

    return cell;
}

@end
