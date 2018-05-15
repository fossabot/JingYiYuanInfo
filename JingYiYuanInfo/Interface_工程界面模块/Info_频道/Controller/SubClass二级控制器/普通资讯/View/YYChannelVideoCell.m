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
#import "YYTagView.h"
#import "ShareView.h"
#import "YYBaseVideoModel.h"

@interface YYChannelVideoCell()

/** title*/
@property (nonatomic, strong) UILabel *title;

/** 视频展示图片*/
//@property (nonatomic, strong) UIImageView *videoImg;
/** cellSeparator*/
@property (nonatomic, strong) UIView *cellSeparator;

/** 播放按钮*/
@property (nonatomic, strong) UIButton *play;

/** 播放量*/
@property (nonatomic, strong) YYEdgeLabel *playCount;

/** 时长*/
@property (nonatomic, strong) YYEdgeLabel *time;

/** 标签1*/
@property (nonatomic, strong) YYTagView *tag1;

/** 标签2*/
@property (nonatomic, strong) YYTagView *tag2;

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
    
    UIView *cellSeparator = [[UIView alloc] init];
    cellSeparator.backgroundColor = GraySeperatorColor;
    [self.contentView addSubview:cellSeparator];
    self.cellSeparator = cellSeparator;
    
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
    playCount.font = TagLabelFont;
    [self.videoImg addSubview:playCount];
    self.playCount = playCount;
    
    YYEdgeLabel *time = [[YYEdgeLabel alloc] init];
    time.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    time.layer.cornerRadius = 6.0;
    time.layer.masksToBounds = YES;
    time.edgeInsets = UIEdgeInsetsMake(2, 3, 2, 3);
    time.textColor = [UIColor whiteColor];
//    time.layer.borderColor = [UIColor blackColor].CGColor;
    time.font = TagLabelFont;
    [self.videoImg addSubview:time];
    self.time = time;
    
    
    YYTagView *tag1 = [[YYTagView alloc] init];
    tag1.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tag1];
    self.tag1 = tag1;
    
    YYTagView *tag2 = [[YYTagView alloc] init];
    tag2.rightMargin = YYInfoCellSubMargin;
    [self.contentView addSubview:tag2];
    self.tag2 = tag2;
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    [self.contentView addSubview:source];
    self.source = source;
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [share setImage:imageNamed(@"share_gray_32x32") forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:share];
    self.share = share;
    
}


- (void)configMasonry {
    
    //底部分隔线的约束
    [self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-0.5);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(0.5);
    }];
    
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
        make.height.equalTo(35);
        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.cellSeparator).offset(-YYInfoCellSubMargin);
    }];

    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.videoImg);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag1.right);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];

    [self.source makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tag2.right);
//        make.top.equalTo(self.videoImg.bottom).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.share);
    }];
    

}


- (void)setVideoModel:(YYBaseVideoModel *)videoModel {
    
    _videoModel = videoModel;
    self.title.text = videoModel.v_name;
    self.title.textColor = videoModel.selected ? UnenableTitleColor : TitleColor;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:videoModel.v_picture] placeholderImage:imageNamed(@"loading_bgView")];
    self.playCount.text = videoModel.v_hits;
    self.time.text = videoModel.v_time;
    
    if ([videoModel.v_tag containsString:@" "]) {
       
        NSArray *tags = [videoModel.v_tag componentsSeparatedByString:@" "];
        self.tag1.title = tags[0];
        self.tag2.title = tags[1];
    }else if ([videoModel.v_tag containsString:@","]){
        
        NSArray *tags = [videoModel.v_tag componentsSeparatedByString:@","];
        self.tag1.title = tags[0];
        self.tag2.title = tags[1];
    }else if (![videoModel.v_tag isEqualToString:@""] ) {
        
        self.tag1.title = videoModel.v_tag;
        self.tag2.title = @"";
//        [self.source updateConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.tag1.right).offset(YYInfoCellCommonMargin);
//        }];
    }else {
//        [self.source updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.videoImg.left);
//        }];
        self.tag1.title = @"";
        self.tag2.title = @"";
    }
    
    [self.tag1 setNeedsLayout];
    [self.tag2 setNeedsLayout];
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
    
    [ShareView shareWithTitle:self.videoModel.v_name subTitle:@"" webUrl:[NSString stringWithFormat:@"%@%@",shareVideoJointUrl,self.videoModel.videoId] imageUrl:self.videoModel.v_picture isCollected:NO shareViewContain:ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog shareContentType:ShareContentTypeWeb finished:^(ShareViewType shareViewType, BOOL isFavor) {
        
    }];
    
}




@end
