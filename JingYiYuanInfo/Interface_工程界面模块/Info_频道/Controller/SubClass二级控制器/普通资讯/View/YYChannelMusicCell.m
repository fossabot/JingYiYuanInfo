//
//  YYChannelMusicCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/8.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelMusicCell.h"
#import "ShareView.h"
#import "YYBaseMusicModel.h"

@interface YYChannelMusicCell()

/** songName*/
@property (nonatomic, strong) UILabel *songName;

/** singerName*/
@property (nonatomic, strong) UILabel *singerName;

/** share*/
@property (nonatomic, strong) UIButton *share;

@end

@implementation YYChannelMusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubView];

    }
    return self;
}

- (void)configSubView {
    
    UILabel *songName = [[UILabel alloc] init];
    songName.font = TitleFont;
    songName.textColor = TitleColor;
    self.songName = songName;
    [self.contentView addSubview:songName];
    
    UILabel *singerName = [[UILabel alloc] init];
    singerName.font = UnenableTitleFont;
    singerName.textColor = SubTitleColor;
    self.singerName = singerName;
    [self.contentView addSubview:singerName];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:imageNamed(@"share_gray_32x32") forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareMusic) forControlEvents:UIControlEventTouchUpInside];
    self.share = share;
    [self.contentView addSubview:share];
    
    [self.share makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(32);
    }];
    
    [self.songName makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.share.left).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.singerName makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.songName.bottom);
        make.right.equalTo(self.share.left).offset(-YYInfoCellCommonMargin);
//        make.bottom.offset(-YYInfoCellCommonMargin);
    }];
    
    
}


- (void)setMusicModel:(YYBaseMusicModel *)musicModel {
    _musicModel = musicModel;
    self.songName.text = musicModel.sname;
    self.songName.textColor = musicModel.selected ? UnenableTitleColor : TitleColor;
    self.singerName.text = musicModel.singer;
    
}

/**
 *  分享音乐
 */
- (void)shareMusic {
    
    
//    [ShareView shareWithTitle:self.musicModel.sname subTitle:self.musicModel.singer webUrl:@"http:\/\/yyapp.1yuaninfo.com\/app\/houtai\/uploads\/media\/20180315\/1521088701.mp3" imageUrl:self.musicModel.picurl isCollected:NO shareViewContain:nil shareContentType:ShareContentTypeMusic finished:^(ShareViewType shareViewType, BOOL isFavor) {
    
//    }];
    [ShareView shareWithTitle:self.musicModel.sname subTitle:self.musicModel.singer webUrl:self.musicModel.URL imageUrl:self.musicModel.picurl isCollected:NO shareViewContain:nil shareContentType:ShareContentTypeMusic finished:^(ShareViewType shareViewType, BOOL isFavor) {
    
    }];
    
    
}

@end
