//
//  YYLaunchViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/7/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYLaunchViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface YYLaunchViewController ()

/** viewPlayer*/
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

/** url*/
@property (nonatomic, strong) NSURL *videoUrl;

/** enterBtn*/
@property (nonatomic, strong) UIButton *enterBtn;

/** skipBtn*/
@property (nonatomic, strong) UIButton *skipBtn;

/** gifname*/
@property (nonatomic, copy) NSString *gifName;

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** gifs*/
@property (nonatomic, strong) NSArray *gifs;

@end

@implementation YYLaunchViewController

- (id)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _videoUrl = url;
    }
    return  self;
}


-(id)initWithGif:(NSString *)gifName {
    
    self = [super init];
    if (self) {
        _gifName = gifName;
    }
    return self;
}

- (id)initWithGifs:(NSArray *)gifNames{
    
    self = [super init];
    if (self) {
        _gifs = [NSArray arrayWithArray:gifNames];
    }
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSString *appVersion = kAppVersion;
        NSString *lastAppVersion = [kUserDefaults objectForKey:LASTAPPVERSION];
        if ([appVersion isEqualToString:lastAppVersion]) {
            //这不是第一次启动APP
            _autoRemoveSelf = YES;
            
        }else{
            //将最新版本的版本号写入用户偏好设置里
            [kUserDefaults setObject:appVersion forKey:LASTAPPVERSION];
            [kUserDefaults synchronize];
            //这是第一次启动APP
            _autoRemoveSelf = NO;
        }
        
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_videoUrl) {
    
    [self.view addSubview:self.moviePlayer.view];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:coverView];
    //监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinsihed) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
    }else if (_gifName) { //如果有GIF图的名字，及说明
        CGRect frame = CGRectMake(50,340,[UIScreen mainScreen].bounds.size.width / 2,[UIScreen mainScreen].bounds.size.height / 2);
        frame.size = [UIImage imageNamed:@"640gif.gif"].size;
        // 读取gif图片数据
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"640gif" ofType:@"gif"]];
        // view生成
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.userInteractionEnabled = NO;//用户不可交互
        [webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:nil];
        [self.view addSubview:webView];
    }else if (_gifs.count) {
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
   
    if (_videoUrl) {
    
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer play];
        
    } else if(_gifName) {
        
    }
    
    if (_autoRemoveSelf) {
        [self.view addSubview:self.skipBtn];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:self.enterBtn];
            [self.view bringSubviewToFront:self.enterBtn];
            [UIView animateWithDuration:1 animations:^{
                self.enterBtn.alpha = 1;
            }];
        });
    }
    
}


/**
 播放完毕的通知回调
 */
- (void)playFinsihed {
    
    //如果设置了自动隐藏自己的话，那就回调进入主程序的函数，如果没设置
    if (_autoRemoveSelf == YES && _enterMainBlock) {
        [self removeSelf];
    }
    
}

/**
 进入应用首页，其实是隐藏自己，remove掉，自动展示后面的根视图
 */
- (void)enterMain {
    
    if (_enterMainBlock) {
        _enterMainBlock();
    }
}

/**
 进入应用首页，其实是隐藏自己，remove掉，自动展示后面的根视图
 */
- (void)removeSelf {
    
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    if (_enterMainBlock) {
        //去根控制器，将其持有的YYLaunchViewController对象销毁，nil
        _enterMainBlock();
    }
}


- (MPMoviePlayerController *)moviePlayer{
    
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_videoUrl];
        [_moviePlayer.view setFrame:self.view.bounds];
        _moviePlayer.shouldAutoplay = YES;
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        _moviePlayer.repeatMode = _autoRemoveSelf ? MPMovieRepeatModeNone : MPMovieRepeatModeOne;
        _moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    }
    return _moviePlayer; 
}


- (UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _enterBtn.backgroundColor = [UIColor clearColor];
        _enterBtn.size = CGSizeMake(150, 40);
        _enterBtn.centerX = self.view.centerX;
        _enterBtn.centerY = self.view.bounds.size.height - 80;
        _enterBtn.layer.masksToBounds = YES;
        _enterBtn.layer.cornerRadius = 5;
        _enterBtn.layer.borderWidth = 1;
        [_enterBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.alpha = 0;
    }
    return _enterBtn;
}

- (UIButton *)skipBtn{
    
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(self.view.bounds.size.width - 60, 30, 40, 20);
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.cornerRadius = 10;
        _skipBtn.layer.borderWidth = 1;
        _skipBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    }
    
    return _skipBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
