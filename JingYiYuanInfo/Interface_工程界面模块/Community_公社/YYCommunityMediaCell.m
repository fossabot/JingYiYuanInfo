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
#import "YYTagView.h"

@interface YYCommunityMediaCell()

/** cover*/
@property (nonatomic, strong) UIImageView *coverTop;
@property (nonatomic, strong) UIImageView *coverBottom;

/** title*/
@property (nonatomic, strong) UILabel *title;

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

/** 标签1*/
@property (nonatomic, strong) YYTagView *tagView1;

/** 标签2*/
@property (nonatomic, strong) YYTagView *tagView2;


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
    
    UIImageView *coverTop = [[UIImageView alloc] init];
    coverTop.image = imageNamed(@"videoCellCoverTop");
//    cover.image = [coverImage stretchableImageWithLeftCapWidth:100 topCapHeight:60];
//    cover.alpha = 0.5;
    coverTop.userInteractionEnabled = YES;
    [self.videoImg addSubview:coverTop];
    self.coverTop = coverTop;
    
    UIImageView *coverBottom = [[UIImageView alloc] init];
    coverBottom.image = imageNamed(@"videoCellCoverBottom");
//    cover.image = [coverImage stretchableImageWithLeftCapWidth:100 topCapHeight:60];
//    coverBottom.alpha = 0.5;
    coverBottom.userInteractionEnabled = YES;
    [self.videoImg addSubview:coverBottom];
    self.coverBottom = coverBottom;
    
    UILabel *title = [[UILabel alloc] init];
    [title setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    [title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    title.font = NavTitleFont;
    title.textColor = WhiteColor;
    title.numberOfLines = 0;
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
    playCount.font = TagLabelFont;
    [self.videoImg addSubview:playCount];
    self.playCount = playCount;
    
    YYEdgeLabel *time = [[YYEdgeLabel alloc] init];
    time.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    time.layer.cornerRadius = 6.0;
    time.layer.masksToBounds = YES;
    time.edgeInsets = UIEdgeInsetsMake(2, 3, 2, 3);
    time.textColor = [UIColor whiteColor];
    time.font = TagLabelFont;
    [self.videoImg addSubview:time];
    self.time = time;
    
    YYTagView *tagView1 = [[YYTagView alloc] init];
    tagView1.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tagView1];
    self.tagView1 = tagView1;
    
    YYTagView *tagView2 = [[YYTagView alloc] init];
    tagView2.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tagView2];
    self.tagView2 = tagView2;
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    [self.contentView addSubview:source];
    self.source = source;
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [share setImage:imageNamed(@"niuVideoshare_20x20") forState:UIControlStateNormal];
    //share_gray_32x32
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
    
    [self.coverTop makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.videoImg);
    }];
    [self.coverBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.videoImg);
        make.height.equalTo(30);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.videoImg).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.videoImg).offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.coverTop.bottom).offset(-YYInfoCellCommonMargin);
    }];

    [self.play makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.videoImg);
        make.width.height.equalTo(60);
    }];
    
    [self.playCount makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(YYInfoCellSubMargin);
        make.bottom.offset(-YYInfoCellSubMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYInfoCellSubMargin);
        make.bottom.offset(-YYInfoCellSubMargin);
    }];
    
    [self.share makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.videoImg);
        make.width.equalTo(45);
        make.height.equalTo(39);
        make.top.equalTo(self.videoImg.bottom);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.tagView1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.videoImg.left);
        make.centerY.equalTo(self.share);
    }];
    
    [self.tagView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagView1.right);
        make.centerY.equalTo(self.share);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagView2.right);
        make.centerY.equalTo(self.share);
    }];
}



- (void)setMediaModel:(YYCommunityMediaModel *)mediaModel {
    
    _mediaModel = mediaModel;
    self.title.text = mediaModel.v_name;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:mediaModel.v_picture] placeholderImage:imageNamed(@"loading_bgView")];
    self.playCount.text = mediaModel.v_hits;
    self.time.text = mediaModel.v_time;
    
    if ([mediaModel.v_tag isEqualToString:@""]) {
        YYLog(@"mediaModel.v_tag ---- isEqualToString:@""");
    }
    
    if ([mediaModel.v_tag isKindOfClass:[NSNull class]]) {
        YYLog(@"mediaModel.v_tag ---- isKindOfClass:null");
    }
    
    if (mediaModel.v_tag == nil) {
        YYLog(@"mediaModel.v_tag ---- isnil");
    }
    
    if ([mediaModel.v_tag containsString:@" "]) {
        
        NSArray *tags = [mediaModel.v_tag componentsSeparatedByString:@" "];
        self.tagView1.title = tags[0];
        self.tagView2.title = tags[1];
    }else if ([mediaModel.v_tag containsString:@","]){
        
        NSArray *tags = [mediaModel.v_tag componentsSeparatedByString:@","];
        self.tagView1.title = tags[0];
        self.tagView2.title = tags[1];
    }else if (![mediaModel.v_tag isEqualToString:@""] && ![mediaModel.v_tag isKindOfClass:[NSNull class]] && mediaModel.v_tag != nil) {
        
        self.tagView1.title = mediaModel.v_tag;
        self.tagView2.title = @"";
    }else {
        self.tagView1.title = @"";
        self.tagView2.title = @"";
    }

    [self.tagView1 setNeedsLayout];
    [self.tagView2 setNeedsLayout];
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
    
    [ShareView shareWithTitle:self.mediaModel.v_name subTitle:@"" webUrl:[NSString stringWithFormat:@"%@%@",shareNiuVideoJointUrl,self.mediaModel.mediaId] imageUrl:self.mediaModel.v_picture isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
}




@end
