//
//  YYChannelVideoCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "YYEdgeLabel.h"
#import "ShareView.h"
#import "YYBaseVideoModel.h"

@interface YYChannelVideoCell()

/** title*/
@property (nonatomic, strong) UILabel *title;

/** 视频展示图片*/
//@property (nonatomic, strong) UIImageView *videoImg;

/** 播放按钮*/
@property (nonatomic, strong) UIButton *play;

/** 播放量*/
@property (nonatomic, strong) YYEdgeLabel *playCount;

/** 时长*/
@property (nonatomic, strong) YYEdgeLabel *time;

/** 标签1*/
@property (nonatomic, strong) YYEdgeLabel *tag1;

/** 标签2*/
@property (nonatomic, strong) YYEdgeLabel *tag2;

/** 来源*/
@property (nonatomic, strong) UILabel *source;

/** 分享按钮*/
@property (nonatomic, strong) UIButton *share;


@end

@implementation YYChannelVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self configSubView];
        [self configMasonry];
    }
    return self;
}


- (void)configSubView {
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 0;
    [self.contentView addSubview:title];
    self.title = title;
    
    UIImageView *videoImg = [[UIImageView alloc] init];
    videoImg.tag = 101;
    videoImg.userInteractionEnabled = YES;
    [self.contentView addSubview:videoImg];
    self.videoImg = videoImg;
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    [play setImage:imageNamed(@"yyfw_community_wemedia_play_40x40_") forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.videoImg addSubview:play];
    self.play = play;
    
    YYEdgeLabel *playCount = [[YYEdgeLabel alloc] init];
    playCount.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    playCount.layer.cornerRadius = 6.0;
    playCount.layer.masksToBounds = YES;
    playCount.edgeInsets = UIEdgeInsetsMake(2, 3, 2, 3);
    playCount.textColor = [UIColor whiteColor];
//    playCount.layer.borderColor = [UIColor blackColor].CGColor;
    playCount.font = UnenableTitleFont;
    [self.videoImg addSubview:playCount];
    self.playCount = playCount;
    
    YYEdgeLabel *time = [[YYEdgeLabel alloc] init];
    time.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    time.layer.cornerRadius = 6.0;
    time.layer.masksToBounds = YES;
    time.edgeInsets = UIEdgeInsetsMake(2, 3, 2, 3);
    time.textColor = [UIColor whiteColor];
//    time.layer.borderColor = [UIColor blackColor].CGColor;
    time.font = UnenableTitleFont;
    [self.videoImg addSubview:time];
    self.time = time;
    
    
    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.font = UnenableTitleFont;
    tag1.textColor = ThemeColor;
    tag1.layer.borderColor = ThemeColor.CGColor;
    tag1.layer.cornerRadius = 3.0;
    tag1.layer.masksToBounds = YES;
    [self.contentView addSubview:tag1];
    self.tag1 = tag1;
    
    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
    tag2.font = UnenableTitleFont;
    tag2.textColor = ThemeColor;
    tag2.layer.borderColor = ThemeColor.CGColor;
    tag2.layer.cornerRadius = 3.0;
    tag2.layer.masksToBounds = YES;
    [self.contentView addSubview:tag2];
    self.tag2 = tag2;
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    [self.contentView addSubview:source];
    self.source = source;
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:imageNamed(@"share_gray_32x32") forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:share];
    self.share = share;
    
}


- (void)configMasonry {
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
    }];
    
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom).offset(YYInfoCellCommonMargin);
        make.left.offset(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
        make.height.equalTo((kSCREENWIDTH-20)*9/16);
    }];
    
    [self.play makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.videoImg);
    }];
    
    [self.playCount makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(YYInfoCellCommonMargin);
        make.bottom.offset(-YYInfoCellSubMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYInfoCellCommonMargin);
        make.bottom.offset(-YYInfoCellSubMargin);
    }];
    
    [self.share makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.videoImg).offset(-YYInfoCellSubMargin);
        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
    }];

    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.videoImg);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right).offset(YYInfoCellCommonMargin);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];

    [self.source makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag2.right).offset(YYInfoCellCommonMargin);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];
    

}


- (void)setVideoModel:(YYBaseVideoModel *)videoModel {
    
    _videoModel = videoModel;
    self.title.text = videoModel.v_name;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:videoModel.v_picture] placeholderImage:imageNamed(@"loading_bgView")];
    self.playCount.text = videoModel.v_hits;
    self.time.text = videoModel.v_time;
    
    if ([videoModel.v_tag containsString:@" "]) {
       
        NSArray *tags = [videoModel.v_tag componentsSeparatedByString:@" "];
        self.tag1.text = tags[0];
        self.tag2.text = tags[1];
    }else if ([videoModel.v_tag containsString:@"，"]){
        
        NSArray *tags = [videoModel.v_tag componentsSeparatedByString:@"，"];
        self.tag1.text = tags[0];
        self.tag2.text = tags[1];
    }else {
        
        self.tag1.text = videoModel.v_tag;
    }
    
    self.source.text = videoModel.v_source;
    
    
}


/**
 *  播放视频
 */
- (void)playVideo {
    
    if (_playBlock) {
        _playBlock();
    }
}

/**
 *  分享视频
 */
- (void)shareVideo {
    
    [ShareView shareWithTitle:self.videoModel.v_name subTitle:@"" webUrl:self.videoModel.v_sharUrl imageUrl:self.videoModel.v_picture isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}




@end
