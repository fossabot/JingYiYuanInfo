//
//  YYBaseInfoViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  频道普通资讯的控制器

#import "YYBaseInfoViewController.h"
#import "YYBaseRankListController.h"
#import "YYBaseRankDetailController.h"
#import "YYBaseInfoDetailController.h"
#import "YYVideoDetailController.h"
#import "YYShowLikeDetailController.h"
#import "YYPicsDetailController.h"

#import "THBaseTableView.h"
#import "YYPhotoBrowser.h"
#import "YYChannelShowBannerView.h"
#import "YYMusicPlayerView.h"

#import "YYHotTableViewCell.h"

#import "YYNewsLeftPicCell.h"
#import "YYNewsBigPicCell.h"
#import "YYNewsThreePicCell.h"
#import "YYNewsPicturesCell.h"

#import "YYChannelVideoCell.h"
#import "YYChannelMusicCell.h"
#import "YYChannelShowRecommendCell.h"
#import "YYChannelShowLikeCell.h"

#import "YYBaseInfoVM.h"

#import "YYBaseVideoModel.h"
#import "YYBaseMusicModel.h"
#import "YYHotInfoModel.h"

#import "YYRefresh.h"

@interface YYBaseInfoViewController ()

/** tableview*/
@property (nonatomic,strong)  THBaseTableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYBaseInfoVM *viewModel;

/** musicView*/
@property (nonatomic, strong) YYMusicPlayerView *musicPlayerView;

@end

@implementation YYBaseInfoViewController


#pragma mark -- lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YYLog(@"name:%@",self.yp_tabItemTitle);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    
    if ([_classid isEqualToString:@"22"]) {//音乐
        
        self.tableView.contentInset = UIEdgeInsetsMake(105, 0, 0, 0);
        self.tableView.mj_header = nil;
        [self.view addSubview:self.musicPlayerView];
        [kNotificationCenter addObserver:self selector:@selector(resetMusicPlayer) name:YYInfoMusicResetPlayerNotification object:nil];
    }else if ([_classid isEqualToString:@"20"]) {//视频
        
        [kNotificationCenter addObserver:self selector:@selector(resetVideoPlayer) name:YYInfoVideoResetPlayerNotification object:nil];
    }
    //加载最新数据
    [self loadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重置播放器的播放进度
    [self.viewModel resetSeekTime];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([_classid isEqualToString:@"20"]) {
        
        [self resetVideoPlayer];
    }else if ([_classid isEqualToString:@"22"]) {
        
        [self resetMusicPlayer];
    }
}

- (void)dealloc {
    
    YYLogFunc
    
    [kNotificationCenter removeObserver:self];
//    [kNotificationCenter removeObserver:self name:YYInfoVideoResetPlayerNotification object:nil];
//    [kNotificationCenter removeObserver:self name:YYInfoMusicResetPlayerNotification object:nil];
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 加载最新数据*/
- (void)loadNewData {
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    YYWeakSelf
    [self.viewModel fetchNewDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        if (success) {
            if ([strongSelf.classid isEqualToString:@"23"]) {//演出
                
                YYChannelShowBannerView *view = [[YYChannelShowBannerView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENWIDTH*0.5)];
                view.dataSource = strongSelf.viewModel.bannerDataSource;
                strongSelf.tableView.tableHeaderView = nil;
                strongSelf.tableView.tableHeaderView = view;
            }else if ([strongSelf.classid isEqualToString:@"22"]) {//音乐
                
                YYBaseMusicModel *musicModel = strongSelf.viewModel.infoDataSource[0];
                [strongSelf.musicPlayerView setMusicModel:musicModel];
                [strongSelf.musicPlayerView forcePlayerPause];
            }
            
            [strongSelf.tableView reloadData];
        }
    }];
    
}

/** 加载更多数据*/
- (void)loadMoreData {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    YYWeakSelf
    [self.viewModel fetchMoreDataCompletion:^(BOOL success) {
        
        YYStrongSelf
        [strongSelf.tableView.mj_footer endRefreshing];
        if (success) {
            [strongSelf.tableView reloadData];
        }
    }];
}


/** 重置视频播放器，暂停播放*/
- (void)resetVideoPlayer {
    
    [self.viewModel resetPlayer];
}

/** 重置音乐播放器，暂停播放*/
- (void)resetMusicPlayer {
    
    [self.musicPlayerView playerPause];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (THBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-40-YYTopNaviHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        
        [_tableView registerClass:[YYHotTableViewCell class] forCellReuseIdentifier:YYHotTableViewCellId];
        
        [_tableView registerClass:[YYNewsLeftPicCell class] forCellReuseIdentifier:YYNewsLeftPicCellId];
        [_tableView registerClass:[YYNewsBigPicCell class] forCellReuseIdentifier:YYNewsBigPicCellId];
        [_tableView registerClass:[YYNewsThreePicCell class] forCellReuseIdentifier:YYNewsThreePicCellId];
        [_tableView registerClass:[YYNewsPicturesCell class] forCellReuseIdentifier:YYNewsPicturesCellId];
        
        [_tableView registerClass:[YYChannelVideoCell class] forCellReuseIdentifier:YYChannelVideoCellId];
        [_tableView registerClass:[YYChannelMusicCell class] forCellReuseIdentifier:YYChannelMusicCellId];
        [_tableView registerClass:[YYChannelShowRecommendCell class] forCellReuseIdentifier:YYChannelShowRecommendCellId];
        [_tableView registerClass:[YYChannelShowLikeCell class] forCellReuseIdentifier:YYChannelShowLikeCellId];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YYWeakSelf
        _tableView.mj_header = [YYStateHeader headerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadNewData];
        }];
        
        YYBackNormalFooter *stateFooter = [YYBackNormalFooter footerWithRefreshingBlock:^{
            
            YYStrongSelf
            [strongSelf loadMoreData];
        }];
        _tableView.mj_footer = stateFooter;

        
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无数据,点此重新加载";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        configer.emptyViewDidAppear = ^{
            weakSelf.tableView.mj_footer.hidden = YES;
        };
        [_tableView emptyViewConfiger:configer];
        
    }
    return _tableView;
}


- (YYBaseInfoVM *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYBaseInfoVM alloc] init];
        _viewModel.classid = self.classid;
        YYWeakSelf
        _viewModel.cellSelectedBlock = ^(YYBaseInfoType cellType, NSIndexPath *indexPath, id data){
            YYStrongSelf
            switch (cellType) {// 根据celltype不同跳转相应的控制器
                case YYBaseInfoTypeRank:{
                    //排行
                    YYBaseRankDetailController *detail = [[YYBaseRankDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                    
                case YYBaseInfoTypeNews:{
                    //普通新闻资讯
                    YYBaseInfoDetailController *detail = [[YYBaseInfoDetailController alloc] init];
                    YYHotInfoModel *hotInfoModel = (YYHotInfoModel *)data;
                    detail.url = hotInfoModel.webUrl;
                    detail.shareUrl = hotInfoModel.shareUrl;
                    detail.shareImgUrl = hotInfoModel.picurl;
                    detail.subTitle = hotInfoModel.infodescription;
                    detail.newsId = hotInfoModel.infoid;
                    __weak typeof(indexPath) weakIndex = indexPath;
                    detail.dislikeBlock = ^(NSString *newsId) {
                        
                        [strongSelf.viewModel deleteRow:weakIndex.row];
                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:weakIndex.section] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                
                case YYBaseInfoTypeNewsPics:{
                    //多图新闻
                    YYPicsDetailController *detail = [[YYPicsDetailController alloc] init];
                    YYHotInfoModel *model = (YYHotInfoModel *)data;
                    detail.picsModels = model.picarr;
                    detail.shareTitle = model.title;
                    detail.shareImageUrl = model.picurl;
                    detail.shareSubTitle = model.infodescription;
                    detail.picsId = model.infoid;
                    detail.jz_wantsNavigationBarVisible = NO;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                    
                case YYBaseInfoTypeShow:{
                    //演出
                    YYShowLikeDetailController *detail = [[YYShowLikeDetailController alloc] init];
                    detail.url = data;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                
                case YYBaseInfoTypeVideo:{
                    //视频
                    NSDictionary *dic = (NSDictionary *)data;
                    YYVideoDetailController *detail = [[YYVideoDetailController alloc] init];
                    YYBaseVideoModel *videoModel = [dic objectForKey:@"data"];
                    NSNumber *seekTime = [dic objectForKey:@"seekTime"];
                    detail.videoId = videoModel.videoId;
                    detail.videoURL = [NSURL URLWithString:videoModel.v_url];
                    detail.seekTime = [seekTime integerValue];
                    detail.videoTitle = videoModel.v_name;
                    detail.placeHolderImageUrl = videoModel.v_picture;
                    detail.jz_wantsNavigationBarVisible = NO;
                    [strongSelf.navigationController pushViewController:detail animated:YES];
                }
                    break;
                    
                case YYBaseInfoTypeMusic:{
                    //音乐
                    YYLog(@"点击了音乐cell");
                    YYBaseMusicModel *musicModel = (YYBaseMusicModel *)data;
                    [strongSelf.musicPlayerView setMusicModel:musicModel];
                }
                    break;
                
                default:
                    break;
            }
        };
        
        _viewModel.moreBlock = ^(NSString *lastid, NSString *classid){ //跳转更多排行的界面
            YYStrongSelf
            YYBaseRankListController *list = [[YYBaseRankListController alloc] init];
            list.lastid = lastid;
            list.classid = classid;
            [strongSelf.navigationController pushViewController:list animated:YES];
        };
    }
    return _viewModel;
}

- (YYMusicPlayerView *)musicPlayerView {
    if (!_musicPlayerView) {
        _musicPlayerView = [[YYMusicPlayerView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 100)];
    }
    return _musicPlayerView;
}

@end
