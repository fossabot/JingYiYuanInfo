//
//  YYVideoDetailCell.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/12.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYVideoDetailCell.h"
#import "YYTagView.h"
#import "YYBaseVideoModel.h"

@interface YYVideoDetailCell()

//视频图片
@property (nonatomic, strong) UIImageView *videoImageView;

//标题
@property (nonatomic, strong) UILabel *title;

//标签
@property (nonatomic, strong) YYTagView *tagLabel;

//来源
@property (nonatomic, strong) UILabel *source;

//播放量
@property (nonatomic, strong) UILabel *hits;

@end



@implementation YYVideoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self configSubView];
    }
    return self;
}


- (void)configSubView {
    
    UIImageView *videoImageView = [[UIImageView alloc] init];
    self.videoImageView = videoImageView;
    [self.contentView addSubview:videoImageView];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = TitleColor;
    title.font = TitleFont;
    title.numberOfLines = 2;
    self.title = title;
    [self.contentView addSubview:title];
    
    YYTagView *tagLabel = [[YYTagView alloc] init];
    tagLabel.rightMargin = YYInfoCellSubMargin;
    self.tagLabel = tagLabel;
    [self.contentView addSubview:tagLabel];
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    self.source = source;
    [self.contentView addSubview:source];
    
    UILabel *hits = [[UILabel alloc] init];
    hits.font = UnenableTitleFont;
    hits.textColor = UnenableTitleColor;
    self.hits = hits;
    [self.contentView addSubview:hits];
    
    [self.videoImageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(YYCommonCellTopMargin);
        make.left.equalTo(YYCommonCellLeftMargin);
        make.width.equalTo(100);
        make.height.equalTo(70);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.videoImageView.right).offset(YYInfoCellCommonMargin);
        make.top.equalTo(self.videoImageView);
        make.right.equalTo(-YYCommonCellRightMargin);
    }];
    
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.videoImageView);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagLabel.right);
        make.centerY.equalTo(self.tagLabel);
    }];
    
    [self.hits makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(-YYCommonCellRightMargin);
        make.bottom.equalTo(self.videoImageView);
    }];
    
    
}


- (void)setModel:(YYBaseVideoModel *)model {
    _model = model;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.v_picture] placeholderImage:imageNamed(placeHolderMini)];
    self.title.text = model.v_name;
    self.tagLabel.title = model.v_tag;
//    if (![model.v_tag isEqualToString:@""] ) {
//
//        self.tagLabel.text = model.v_tag;
//    }else {
//        self.tagLabel.text = @"";
//        [self.source updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.title.left);
//        }];
//    }
    [self.tagLabel setNeedsLayout];
    self.source.text = model.v_source;
    self.hits.text = model.v_hits;

}



@end
