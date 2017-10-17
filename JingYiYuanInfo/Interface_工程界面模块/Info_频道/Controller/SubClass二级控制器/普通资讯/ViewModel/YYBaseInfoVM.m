//
//  YYBaseInfoVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseInfoVM.h"
#import <MJExtension/MJExtension.h>

#import "YYHotInfoModel.h"
#import "YYBaseInfoModel.h"
#import "YYBaseHotModel.h"
#import "YYBaseVideoListModel.h"
#import "YYBaseVideoModel.h"

#import "YYBaseMusicListModel.h"
#import "YYBaseMusicModel.h"

#import "YYBaseShowModel.h"
#import "YYShowBannerModel.h"
#import "YYShowRecommendModel.h"
#import "YYShowLikeModel.h"

#import "YYHotTableViewCell.h"

#import "YYNewsLeftPicCell.h"
#import "YYNewsBigPicCell.h"
#import "YYNewsThreePicCell.h"
#import "YYNewsPicturesCell.h"

#import "YYChannelVideoCell.h"
#import "YYChannelMusicCell.h"
#import "YYChannelShowBannerView.h"
#import "YYChannelShowRecommendCell.h"
#import "YYChannelShowLikeCell.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFPlayer.h"
#import "YYUser.h"

@interface YYBaseInfoVM()<ZFPlayerDelegate>

/** 是不是特殊资讯请求的控制器（视频，音乐，演出，他们请求的参数不需要加classid，直接是Videomore等）*/
@property (nonatomic, assign) BOOL isSpecial;

/** lastid*/
@property (nonatomic, copy)   NSString       *lastid;

/** rankDataSource*/
@property (nonatomic, strong) NSMutableArray *rankDataSource;

/** recommendDataSource*/
@property (nonatomic, strong) NSMutableArray *recommendDataSource;

/** ZFPlayerView*/
@property (nonatomic, strong) ZFPlayerView   *playerView;

/** playerModel*/
@property (nonatomic, strong) ZFPlayerModel  *playerModel;

@end

@implementation YYBaseInfoVM
{
    NSInteger _seekTime;
}

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
//    act=info   classid=
    NSDictionary *para = nil;
    if ([self isSpecial]) {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:[self act],@"act", nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:[self act],@"act",self.classid,@"classid", nil];
    }
    
    [PPNetworkHelper GET:channelNewsUrl parameters:para responseCache:^(id responseCache) {
        if (!self.infoDataSource.count && responseCache) {
            
            [self dispatchNewResponse:responseCache];
            if (completion) {
                completion(YES);
            }
        }
    } success:^(id responseObject) {
        
        [self dispatchNewResponse:responseObject];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error) {
        
        if (completion) {
            completion(NO);
        }
    }];
    
}


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = nil;
    if (self.isSpecial) {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:[self moreAct],@"act", self.lastid,@"lastid", nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:[self moreAct],@"act",self.classid,@"classid",self.lastid,@"lastid", nil];
    }
    
    [YYHttpNetworkTool GETRequestWithUrlstring:channelNewsUrl parameters:para success:^(id response) {
        
        [self dispatchMoreResponse:response];
        completion(YES);
    } failure:^(NSError *error) {
        completion(NO);
    } showSuccessMsg:nil];
    
}

/**
 *  重置videoPlayer
 */
- (void)resetPlayer {
    
    [self.playerView resetPlayer];
}

/**
 *  重置播放时间
 */
- (void)resetSeekTime {
    
    _seekTime = 0;
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  查看更多排行
 */
- (void)more:(UIButton *)sender {
    
    if (_moreBlock) {
        _moreBlock(_lastid, _classid);
    }
}


#pragma mark -------  ZFPlayer delegate  ----------------------

- (void)zf_playerCurrentTime:(NSInteger)currentTime {
    
    _seekTime = currentTime;
    YYLog(@"当前的播放进度  --  %lds",currentTime);
}


#pragma -- mark TableViewDelegate  -------------------------------

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.rankDataSource.count && section == 0) {
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        more.titleLabel.font = SubTitleFont;
        [more setTitle:@"查看更多" forState:UIControlStateNormal];
        [more setTitleColor:ThemeColor forState:UIControlStateNormal];
        more.frame = CGRectMake(0, 0, kSCREENWIDTH, 30);
        more.backgroundColor = WhiteColor;
        [more addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        return more;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.rankDataSource.count && section == 0 ) {
        
        return 30;
    }
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    if (self.rankDataSource.count) {
        return 2;
    }else if (self.bannerDataSource.count) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.rankDataSource.count && section == 0) {
        return self.rankDataSource.count;
    }else if (self.recommendDataSource.count && section == 0) {
        return 1;
    }
    return self.infoDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([self cellTypeAtIndexPath:indexPath]) {
        case YYBaseInfoTypeRank:{
            
            YYBaseHotModel *model = self.rankDataSource[indexPath.row];
            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYHotTableViewCellId cacheByIndexPath:indexPath configuration:^(YYHotTableViewCell *hotCell) {
                [hotCell setBaseModel:model andIndex:indexPath.row];
            }];
            return height;
        }
            break;
            
        case YYBaseInfoTypeNews:{
            
            YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
            NSInteger index = hotInfoModel.picstate;
            switch (index) {
                case 1:{//左图
                    CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsLeftPicCellId cacheByIndexPath:indexPath configuration:^(YYNewsLeftPicCell *leftCell) {
                        leftCell.hotinfoModel = hotInfoModel;
                    }];
                    return height;
                }
                    break;
        
                case 2:{//大图
                    CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsBigPicCellId cacheByIndexPath:indexPath configuration:^(YYNewsBigPicCell *bigCell) {
                        bigCell.hotinfoModel = hotInfoModel;
                    }];
                    return height;
                }
                    break;
        
                case 3:{//三图
                    CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsThreePicCellId cacheByIndexPath:indexPath configuration:^(YYNewsThreePicCell *threeCell) {
                        threeCell.hotinfoModel = hotInfoModel;
                    }];
                    return height;
                }
                    break;
            }
        }
            break;
        
        case YYBaseInfoTypeNewsPics:{
            
            YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsPicturesCellId cacheByIndexPath:indexPath configuration:^(YYNewsPicturesCell *picturesCell) {
                picturesCell.hotinfoModel = hotInfoModel;
            }];
            return height;
            
        }
            break;
            
        case YYBaseInfoTypeVideo:{
            
            YYBaseVideoModel *model = self.infoDataSource[indexPath.row];
            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYChannelVideoCellId cacheByIndexPath:indexPath configuration:^(YYChannelVideoCell *videoCell) {
                
                videoCell.videoModel = model;
            }];
            return height;
            
        }
            break;
            
        case YYBaseInfoTypeMusic:{
            
//            YYBaseMusicModel *model = self.infoDataSource[indexPath.row];
//            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYChannelMusicCellId cacheByIndexPath:indexPath configuration:^(YYChannelMusicCell *musicCell) {
//                
//                musicCell.musicModel = model;
//            }];
//            return height;
            return 50;
        }
            break;
            
        case YYBaseInfoTypeShow:{
            
            if (indexPath.section == 0) {
                
                return 110;
            }else {
                
                return 120;
            }
        }
            break;
            
        default:
            break;
    }

    
    return 0.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_cellSelectedBlock) {
        switch ([self cellTypeAtIndexPath:indexPath]) {
            case YYBaseInfoTypeRank:{
                
                YYBaseHotModel *model = self.rankDataSource[indexPath.row];
                _cellSelectedBlock(YYBaseInfoTypeRank, indexPath, model.self_link);
            }
                break;
            
            case YYBaseInfoTypeNews:{
                
                YYHotInfoModel *model = self.infoDataSource[indexPath.row];
                _cellSelectedBlock(YYBaseInfoTypeNews, indexPath, model);
            }
                break;
                
            case YYBaseInfoTypeNewsPics:{
                
                YYHotInfoModel *model = self.infoDataSource[indexPath.row];
                _cellSelectedBlock(YYBaseInfoTypeNewsPics, indexPath, model.picarr);
            }
                break;
                
            case YYBaseInfoTypeVideo:{

                YYBaseVideoModel *model = self.infoDataSource[indexPath.row];
                NSDictionary *dic = @{@"data":model,@"seekTime":@(_seekTime)};
                _cellSelectedBlock(YYBaseInfoTypeVideo, indexPath, dic);
            }
                break;
                
            case YYBaseInfoTypeMusic:{

                YYBaseMusicModel *model = self.infoDataSource[indexPath.row];
                _cellSelectedBlock(YYBaseInfoTypeMusic, indexPath, model);
            }
                break;
                
            case YYBaseInfoTypeShow:{
                
                YYShowLikeModel *model = self.infoDataSource[indexPath.row];
                _cellSelectedBlock(YYBaseInfoTypeShow, indexPath, model.webUrl);
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma -- mark TableViewDataSource ------------------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYUser *user = [YYUser shareUser];
    switch ([self cellTypeAtIndexPath:indexPath]) {
        case YYBaseInfoTypeRank:{
            
            YYBaseHotModel *model = self.rankDataSource[indexPath.row];
            YYHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YYHotTableViewCellId];
            [cell setBaseModel:model andIndex:indexPath.row];
            return cell;
            
        }
            break;
            
        case YYBaseInfoTypeNews:{
            
            YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
            switch (hotInfoModel.picstate) {
                    
                case 1:{//左图
                    YYNewsLeftPicCell *leftCell = [tableView dequeueReusableCellWithIdentifier:YYNewsLeftPicCellId];
                    leftCell.hotinfoModel = hotInfoModel;
                    return leftCell;
                }
                    break;
                    
                case 2:{//大图
                    YYNewsBigPicCell *bigCell = [tableView dequeueReusableCellWithIdentifier:YYNewsBigPicCellId];
                    bigCell.hotinfoModel = hotInfoModel;
                    return bigCell;
                }
                    break;
                    
                case 3:{//三图
                    YYNewsThreePicCell *threeCell = [tableView dequeueReusableCellWithIdentifier:YYNewsThreePicCellId];
                    threeCell.hotinfoModel = hotInfoModel;
                    return threeCell;
                }
                    break;
                    
                    default:
                        break;
            }

        }
            break;
            
        case YYBaseInfoTypeNewsPics:{
            
            YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
            YYNewsPicturesCell *picsCell = [tableView dequeueReusableCellWithIdentifier:YYNewsPicturesCellId];
            picsCell.hotinfoModel = hotInfoModel;
            return picsCell;
        }
            break;
            
        case YYBaseInfoTypeVideo:{
            
            YYBaseVideoModel *model = self.infoDataSource[indexPath.row];
            YYChannelVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:YYChannelVideoCellId];
            videoCell.videoModel = model;
            __block NSIndexPath *weakIndexPath = indexPath;
            __weak typeof(videoCell) weakCell = (YYChannelVideoCell *)videoCell;
            __weak typeof(tableView) weakTableView = tableView;
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:model.v_url];
            YYWeakSelf
            // 点击播放的回调
            videoCell.playBlock = ^{
                
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
                strongSelf.playerView.hasPreviewView = NO;
                
                if (user.onlyWIFIPlay) {
                    
                    [weakSelf showAlert:^(BOOL permit) {
                        
                        if (permit) {
                            
                            // 自动播放
                            [strongSelf.playerView autoPlayTheVideo];
                        }
                    }];
                }else {
                    // 自动播放
                    [strongSelf.playerView autoPlayTheVideo];
                }
                
                
            };
            return videoCell;
        }
            break;
            
        case YYBaseInfoTypeMusic:{
            
            YYBaseMusicModel *model = self.infoDataSource[indexPath.row];
            YYChannelMusicCell *musicCell = [tableView dequeueReusableCellWithIdentifier:YYChannelMusicCellId];
            musicCell.musicModel = model;
            return musicCell;
        }
            break;
            
        case YYBaseInfoTypeShow:{
            
            if (indexPath.section == 0) {
                
                YYChannelShowRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:YYChannelShowRecommendCellId];
                recommendCell.dataSource = self.recommendDataSource;
                return recommendCell;
            }else {
                
                YYShowLikeModel *model = self.infoDataSource[indexPath.row];
                YYChannelShowLikeCell *likeCell = [tableView dequeueReusableCellWithIdentifier:YYChannelShowLikeCellId];
                likeCell.likeModel = model;
                return likeCell;
            }
        }
            break;
            
        default:
            break;
    }


    return nil;

}


- (void)showAlert:(void(^)(BOOL permit))permition {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否使用流量播放视频" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *permit = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        permition(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        permition(NO);
    }];
    
    [alert addAction:permit];
    [alert addAction:cancel];
    [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}



#pragma mark -------  getter some paras -----------------------------------------

- (NSString *)act {
    if ([_classid isEqualToString:@"20"]) {
        return @"video";
    }else if ([_classid isEqualToString:@"22"]) {
        return @"music";
    }else if ([_classid isEqualToString:@"23"]) {
        return @"show";
    }else {
        return @"info";
    }
}

- (NSString *)moreAct {
    if ([_classid isEqualToString:@"20"]) {
        return @"videomore";
    }else if ([_classid isEqualToString:@"22"]) {
        return @"musicmore";
    }else if ([_classid isEqualToString:@"23"]) {
        return @"showmore";
    }else {
        return @"infomore";
    }
}

- (YYBaseInfoType)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_classid isEqualToString:@"20"]) {
        return YYBaseInfoTypeVideo;
    }else if ([_classid isEqualToString:@"22"]) {
        return YYBaseInfoTypeMusic;
    }else if ([_classid isEqualToString:@"23"]) {
        return YYBaseInfoTypeShow;
    }else {
        if (self.rankDataSource.count && indexPath.section == 0) {
            return YYBaseInfoTypeRank;
        }
        
        YYHotInfoModel *model = self.infoDataSource[indexPath.row];
        if (model.picstate == 4) {
            return YYBaseInfoTypeNewsPics;
        }
        return YYBaseInfoTypeNews;
    }
}

/**
 *  分发返回的新数据
 */
- (void)dispatchNewResponse:(id)response {
    
    if ([_classid isEqualToString:@"20"]) { //视频新数据
        
        YYBaseVideoListModel *videoListmodel = [YYBaseVideoListModel mj_objectWithKeyValues:response];
        self.infoDataSource = (NSMutableArray *)videoListmodel.v_arr;
        self.lastid = videoListmodel.lastid;
    }else if ([_classid isEqualToString:@"22"]) { //音乐新数据
        
        YYBaseMusicListModel *musicListModel = [YYBaseMusicListModel mj_objectWithKeyValues:response];
        self.infoDataSource = (NSMutableArray *)musicListModel.m_arr;
        self.lastid = musicListModel.lastid;
    }else if ([_classid isEqualToString:@"23"]) { //演出新数据
        
        YYBaseShowModel *showModel = [YYBaseShowModel mj_objectWithKeyValues:response];
        self.bannerDataSource = (NSMutableArray *)showModel.lb_arr;
        self.recommendDataSource = (NSMutableArray *)showModel.tj_arr;
        self.infoDataSource = (NSMutableArray *)showModel.xh_arr;
        self.lastid = showModel.lastid;
    }else { //普通资讯新数据
        
        YYBaseInfoModel *infoModel = [YYBaseInfoModel mj_objectWithKeyValues:response];
        self.rankDataSource = (NSMutableArray *)infoModel.rank_arr;
        self.infoDataSource = (NSMutableArray *)infoModel.hangqing;
        self.lastid = infoModel.lastid;
    }
}

/**
 *  分发返回的更多数据
 */
- (void)dispatchMoreResponse:(id)response {
    
    if ([_classid isEqualToString:@"20"]) { //视频更多数据
        
        YYBaseVideoListModel *videoListmodel = [YYBaseVideoListModel mj_objectWithKeyValues:response];
        [self.infoDataSource addObjectsFromArray:videoListmodel.v_arr];
        self.lastid = videoListmodel.lastid;
    }else if ([_classid isEqualToString:@"22"]) { //音乐更多数据
        
        YYBaseMusicListModel *musicListModel = [YYBaseMusicListModel mj_objectWithKeyValues:response];
        [self.infoDataSource addObjectsFromArray:musicListModel.m_arr];
        self.lastid = musicListModel.lastid;
    }else if ([_classid isEqualToString:@"23"]) { //演出更多数据
        
        YYBaseShowModel *showModel = [YYBaseShowModel mj_objectWithKeyValues:response];
        [self.infoDataSource addObjectsFromArray:showModel.xh_arr];
        self.lastid = showModel.lastid;
    }else { //普通资讯更多数据
        
        YYBaseInfoModel *infoModel = [YYBaseInfoModel mj_objectWithKeyValues:response];
        [self.infoDataSource addObjectsFromArray:infoModel.hangqing];
        self.lastid = infoModel.lastid;
    }
    
}

- (BOOL)isSpecial {
    if ([_classid isEqualToString:@"20"] || [_classid isEqualToString:@"22"] || [_classid isEqualToString:@"23"]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)rankDataSource{
    if (!_rankDataSource) {
        _rankDataSource = [NSMutableArray array];
    }
    return _rankDataSource;
}

- (NSMutableArray *)infoDataSource{
    if (!_infoDataSource) {
        _infoDataSource = [NSMutableArray array];
    }
    return _infoDataSource;
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
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
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
