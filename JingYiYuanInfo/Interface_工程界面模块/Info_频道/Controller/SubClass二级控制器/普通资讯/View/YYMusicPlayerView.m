//
//  YYMusicPlayerView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMusicPlayerView.h"
#import "YYBaseMusicModel.h"

@interface YYMusicPlayerView()

/** 头像*/
@property (nonatomic, strong) UIImageView *icon;

/** 歌名*/
@property (nonatomic, strong) UILabel *songName;

/** 歌手名*/
@property (nonatomic, strong) UILabel *singerName;

/** 进度条*/
@property (nonatomic, strong) UISlider *slider;

/** beginTimeLabel*/
@property (nonatomic, strong) UILabel *beginTimeLabel;

/** endTimeLabel*/
@property (nonatomic, strong) UILabel *endTimeLabel;

/** 播放暂停*/
@property (nonatomic, strong) UIButton *playBtn;

/** musicUrl*/
@property (nonatomic, copy) NSString *musicUrl;



@end

@implementation YYMusicPlayerView
{
    id _timeObserve;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _player = [[AVPlayer alloc] init];
        _isPlay = NO;
        [self addObserverToPlayer:_player];
        [self configSubView];
        [self masonrySubView];
    }
    return self;
}

- (void)dealloc {
    
    [self removeMusicTimeMake];
}

- (void)configSubView {
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self addSubview:icon];
    [self cutRoundView:icon];
    self.icon = icon;
    
    UILabel *songName = [[UILabel alloc] init];
    songName.font = TitleFont;
    songName.textColor = TitleColor;
    [self addSubview:songName];
    self.songName = songName;
    
    UILabel *singerName = [[UILabel alloc] init];
    singerName.font = SubTitleFont;
    singerName.textColor = SubTitleColor;
    [self addSubview:singerName];
    self.singerName = singerName;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.0;
    slider.minimumTrackTintColor = ThemeColor;
    slider.thumbTintColor = ThemeColor;
    [slider setThumbImage:imageNamed(@"sliderDot") forState:UIControlStateNormal];
    [self addSubview:slider];
    self.slider = slider;
    
    UILabel *beginTimeLabel = [[UILabel alloc] init];
    beginTimeLabel.font = UnenableTitleFont;
    beginTimeLabel.textColor = UnenableTitleColor;
    [self addSubview:beginTimeLabel];
    self.beginTimeLabel = beginTimeLabel;
    
    UILabel *endTimeLabel = [[UILabel alloc] init];
    endTimeLabel.font = UnenableTitleFont;
    endTimeLabel.textColor = UnenableTitleColor;
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:endTimeLabel];
    self.endTimeLabel = endTimeLabel;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:imageNamed(@"musicPlay_24x24") forState:UIControlStateNormal];
    [playBtn setImage:imageNamed(@"musicPause_24x24") forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    self.playBtn = playBtn;
}

- (void)masonrySubView {
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(YYInfoCellCommonMargin);
        make.width.height.equalTo(60);
    }];
    
    [self.songName makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.icon.right).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.icon);
    }];
    
    [self.singerName makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.songName);
        make.top.equalTo(self.songName.bottom).offset(2);
    }];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.icon);
    }];

    [self.slider makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.songName);
        make.bottom.equalTo(self.icon).offset(-YYInfoCellCommonMargin);
        make.right.equalTo(self.playBtn.left).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(10);
    }];
    
    [self.beginTimeLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.slider);
        make.top.equalTo(self.slider.bottom);
    }];
    [self.endTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.slider);
        make.top.equalTo(self.slider.bottom);
    }];
}


/** 给AVPlayer添加监控 */
-(void)addObserverToPlayer:(AVPlayer *)player{
    
    //监听时间变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicTimeInterval:) name:@"musicTimeInterval" object:nil];
    //监听，当音乐界面离开window后，暂停播放音乐
    [kNotificationCenter addObserver:self selector:@selector(playOrPause:) name:@"musicViewDidLeave" object:nil];
}

/** 通知 监听时间变化，设置时间 */
-(void)musicTimeInterval:(NSNotification *)notification{
    
    NSTimeInterval current = CMTimeGetSeconds([_player.currentItem currentTime]);
    NSTimeInterval duration = CMTimeGetSeconds([_player.currentItem duration]);
    
    [self updateProgressLabelCurrentTime:current duration:duration];
}

/** 监听并发送通知改变时间label及slider的进度*/
-(void)addMusicTimeMake{
    //监听
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicTimeInterval" object:nil userInfo:nil];//时间变化
    }];
}

-(void)removeMusicTimeMake{
    if (_timeObserve) {
        [_player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
}


/**
 *  监听播放歌曲结束的回调
 */
- (void)playbackFinished:(NSNotification *)notice {
    
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self playOrPause:self.playBtn];
}

// 切圆角
- (void)cutRoundView:(UIImageView *)imageView
{
    CGFloat corner = 30;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}

    
/**
 *  播放/暂停音乐
 */
- (void)playOrPause:(UIButton *)sender {
    if (sender && _isPlay == YES) {

        sender.selected = !sender.selected;
        [self playerPause];
    }else {
        
        self.playBtn.selected = YES;
        [self playerPlay];
    }
    
    
}

// 播放
- (void)playerPlay
{
    [_player play];
    _isPlay = YES;
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
}

- (void)playerPause
{
    [_player pause];
    _isPlay = NO;
}

//切换歌曲
- (void)replaceItemWithUrlString:(NSString *)urlString {
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self addMusicTimeMake];
    [self updateProgressLabelCurrentTime:CMTimeGetSeconds([_player.currentItem currentTime]) duration:CMTimeGetSeconds([_player.currentItem duration])];
//    [self playerPlay];
    
}

// 播放进度条拖动
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat {
    
    [self.player seekToTime:CMTimeMakeWithSeconds(progressFloat, 1) completionHandler:^(BOOL finished) {
        [self playerPlay];
    }];
}

//同步进度条及时间
/** 设置时间数据 */
- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    
    _beginTimeLabel.text = [self timeIntervalToMMSSFormat:currentTime];
    _endTimeLabel.text = [self timeIntervalToMMSSFormat:duration];

}


- (void)setMusicModel:(YYBaseMusicModel *)musicModel {
    if (_musicModel == musicModel) {
        if (_isPlay == YES) {
            
            return;
        }else {
            //去播放
            [self playOrPause:self.playBtn];
            return;
        }
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:musicModel.picurl] placeholderImage:imageNamed(@"placeholder")];
    self.songName.text = musicModel.sname;
    self.singerName.text = musicModel.singer;
    self.musicUrl = musicModel.URL;
    [self replaceItemWithUrlString:musicModel.URL];
    if (_musicModel) {
        //第一次赋值模型数据是控制器初始化设置的默认数据，不能自动播放，当永华收到赋值模型时，说明已存在之前的模型了，可以播放
        [self playOrPause:nil];
    }
    
    _musicModel = musicModel;
}


#pragma mark - 时间转化
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

@end
