//
//  YYVideoPlayerView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/19.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYVideoPlayerView.h"
#import "ZFPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface YYVideoPlayerView()<ZFPlayerDelegate>

@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;

/** imageView*/
@property (nonatomic, strong) UIImageView *videoImg;

/** play*/
@property (nonatomic, strong) UIButton *playBtn;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** subtitle*/
@property (nonatomic, strong) UILabel *subTitle;

@end

@implementation YYVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _seekTime = 0;
        self.userInteractionEnabled = YES;
        [self configSubView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_seekTime != 0) {
        
        [self.playerView autoPlayTheVideo];
        _seekTime = 0;
    }else {
        
        [self.playerView pause];
    }
}

/**
 *  配置子视图
 */
- (void)configSubView {
    
    UIImageView *videoImg = [[UIImageView alloc] init];
    videoImg.userInteractionEnabled = YES;
    [self addSubview:videoImg];
    self.videoImg = videoImg;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:imageNamed(@"YYPlayerView_play") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.videoImg addSubview:playBtn];
    self.playBtn = playBtn;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 0;
    [self addSubview:title];
    self.title = title;
    
//    UILabel *subTitle = [[UILabel alloc] init];
//    subTitle.font = UnenableTitleFont;
//    subTitle.textColor = UnenableTitleColor;
//    subTitle.numberOfLines = 0;
//    [self addSubview:subTitle];
//    self.subTitle = subTitle;
    
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.height.equalTo(kSCREENWIDTH*9/16);
    }];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.videoImg);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.left.offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
        make.bottom.offset(-YYInfoCellCommonMargin);
    }];
    
//    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
//        make.left.equalTo(self.title.left);
//        make.right.offset(-YYInfoCellCommonMargin);
//        make.bottom.offset(-YYInfoCellCommonMargin);
//    }];
    
}

/**
 *  切换视频
 */
- (void)changePlayItem {
    
    self.playerModel.title = self.videoTitle;
    self.playerModel.videoURL = self.videoURL;
    self.playerModel.placeholderImageURLString = self.placeHolderImageUrl;
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

/**
 *  播放视频
 */
- (void)play {
    
    [self.playerView play];
}

/** 当控制器推出其他界面，调用此方法暂停播放*/
- (void)pauseWhenPushOrPresent {
    
    if (self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

/** 当控制器从其他界面pop回来，调用此方法播放*/
- (void)playWhenPop {
    
    if (self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
}


#pragma mark -------  player delegate -----------------------------

/** 返回按钮点击事件*/
- (void)zf_playerBackAction {
    
    if (_backBlock) {
        _backBlock();
    }
}

/** 分享按钮回调*/
- (void)zf_playerShareVideo {
    if (_shareBlock) {
        _shareBlock();
    }
}

#pragma mark -------  setter -------------------------

- (void)setVideoTitle:(NSString *)videoTitle {
    _videoTitle = videoTitle;
    self.title.text = videoTitle;
    _playerModel.title = videoTitle;
}

- (void)setPlaceHolderImageUrl:(NSString *)placeHolderImageUrl {
    _placeHolderImageUrl = placeHolderImageUrl;
    _playerModel.placeholderImageURLString = placeHolderImageUrl;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:placeHolderImageUrl] placeholderImage:imageNamed(@"loading_bgView")];
}

- (void)setSeekTime:(NSInteger)seekTime {
    _seekTime = seekTime;
    self.playerModel.seekTime = seekTime;
    
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.videoTitle;
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImageURLString = self.placeHolderImageUrl;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView"];
        _playerModel.fatherView       = self.videoImg;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         */
        
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;

        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
//         _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        _playerView.hasShare = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}



@end
