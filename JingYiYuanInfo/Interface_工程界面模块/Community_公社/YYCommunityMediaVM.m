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
#import <MJRefresh/MJRefresh.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFPlayer.h"
#import "YYUser.h"

@interface YYCommunityMediaVM()<ZFPlayerDelegate>

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
    NSDictionary *videoPara = [NSDictionary dictionaryWithObjectsAndKeys:@"cvideo", @"act", nil];
    [PPNetworkHelper GET:communityUrl parameters:videoPara responseCache:^(id responseCache) {
        
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


/** 弹框提示流量播放*/
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)(BOOL permit))permition {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *permit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        permition(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        permition(NO);
    }];
    
    [alert addAction:permit];
    [alert addAction:cancel];
    [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 隐藏尾部刷新控件
    tableView.mj_footer.hidden = (self.mediaDataSource.count%10 != 0) || self.mediaDataSource.count == 0;
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

    YYUser *user = [YYUser shareUser];
    YYCommunityMediaCell * cell = [tableView dequeueReusableCellWithIdentifier:YYCommunityMediaCellId];
    YYCommunityMediaModel *model = self.mediaDataSource[indexPath.row];
    [cell setMediaModel:model];
    __weak typeof(tableView) weakTableView = tableView;
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
        strongSelf.playerModel.scrollView       = weakTableView;
        strongSelf.playerModel.indexPath        = weakIndexPath;
        // player的父视图tag
        strongSelf.playerModel.fatherViewTag    = weakCell.videoImg.tag;
        // 设置播放控制层和model
        [strongSelf.playerView playerControlView:nil playerModel:strongSelf.playerModel];
        // 下载功能
        strongSelf.playerView.hasDownload = NO;
        strongSelf.playerView.hasPreviewView = YES;

        switch (user.netStatus) {
            case YYHttpNetStatusUnreachable:
                [weakSelf showAlertWithTitle:@"无法播放视频" message:@"暂无网络链接" completion:^(BOOL permit) {
                    
                }];
                break;
                
            case YYHttpNetStatusWIFI:
                // 自动播放
                [strongSelf.playerView autoPlayTheVideo];
                break;
                
            case YYHttpNetStatusWWAN:{
             
                if (user.onlyWIFIPlay) {
                    
                    [weakSelf showAlertWithTitle:@"即将使用流量播放视频" message:@"如需关闭提醒，请到设置中关闭仅WiFi下播放视频" completion:^(BOOL permit) {
                        
                        if (permit) {
                            
                            // 自动播放
                            [strongSelf.playerView autoPlayTheVideo];
                        }
                    }];
                }else {
                    // 自动播放
                    [strongSelf.playerView autoPlayTheVideo];
                }
            }
                break;
                
            default:
                break;
        }
        
    };

    return cell;
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
         _playerView.stopPlayWhileCellNotVisable = YES;
        
    }
    return _playerView;
}

- (ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        _playerModel = [[ZFPlayerModel alloc] init];
        
        
    }
    return _playerModel;
}


@end
