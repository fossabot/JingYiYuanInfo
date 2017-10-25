//
//  YYCommunityMediaCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "YYCommunityMediaCell.h"
#import "YYEdgeLabel.h"
#import "ShareView.h"
#import "YYCommunityMediaModel.h"
#import "YYUser.h"

@interface YYCommunityMediaCell()

/** title*/
@property (nonatomic, strong) UIButton *title;

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
@implementation YYCommunityMediaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self configMasonry];
    }
    return self;
}

- (void)configSubView {
    
    UIImageView *videoImg = [[UIImageView alloc] init];
    videoImg.tag = 1001;
    videoImg.userInteractionEnabled = YES;
    [self.contentView addSubview:videoImg];
    self.videoImg = videoImg;
    
    UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
    title.userInteractionEnabled = NO;
    title.titleLabel.font = TitleFont;
    [title setTitleColor:WhiteColor forState:UIControlStateNormal];
    [title setBackgroundImage:imageNamed(@"YYPlayer_top_shadow") forState:UIControlStateNormal];
//    title.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    title.titleLabel.numberOfLines = 0;
    [title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [title setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, -5, 5)];
    [self.videoImg addSubview:title];
    self.title = title;
    
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
    
    
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(YYInfoCellCommonMargin);
        make.right.offset(-YYInfoCellCommonMargin);
        make.height.equalTo((kSCREENWIDTH-20)*9/16);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.videoImg);
    }];

    
    [self.play makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.videoImg);
        make.width.height.equalTo(60);
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
        make.centerY.equalTo(self.share);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.share);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag2.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.share);
    }];
    
    
}


- (void)setMediaModel:(YYCommunityMediaModel *)mediaModel {
    
    _mediaModel = mediaModel;
    [self.title setTitle:mediaModel.v_name forState:UIControlStateNormal];
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:mediaModel.v_picture] placeholderImage:imageNamed(@"loading_bgView")];
    self.playCount.text = mediaModel.v_hits;
    self.time.text = mediaModel.v_time;
    
    if ([mediaModel.v_tag containsString:@" "]) {
        
        NSArray *tags = [mediaModel.v_tag componentsSeparatedByString:@" "];
        self.tag1.text = tags[0];
        self.tag2.text = tags[1];
    }else if ([mediaModel.v_tag containsString:@"，"]){
        
        NSArray *tags = [mediaModel.v_tag componentsSeparatedByString:@"，"];
        self.tag1.text = tags[0];
        self.tag2.text = tags[1];
    }else if (mediaModel.v_tag){
        
        self.tag1.text = mediaModel.v_tag;
        [self.tag2 updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(0);
            make.left.equalTo(self.tag1.right);
        }];
    }

    self.source.text = mediaModel.v_source;
    
    
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
    
    [ShareView shareWithTitle:self.mediaModel.v_name subTitle:@"" webUrl:self.mediaModel.v_sharUrl imageUrl:self.mediaModel.v_picture isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog | ShareViewTypeCopyLink shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}




@end
