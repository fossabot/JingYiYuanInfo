//
//  YYNiuArticleCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuArticleCell.h"
#import "YYNiuArticleModel.h"
#import "LabelContainer.h"
#import "YYEdgeLabel.h"

@interface YYNiuArticleCell()

/** 左边的图片*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** 标题*/
@property (nonatomic, strong) UILabel *title;

/** 描述*/
@property (nonatomic, strong) UILabel *desc;

/** 时间*/
@property (nonatomic, strong) UILabel *time;

/** 标签*/
//@property (nonatomic, strong) LabelContainer *labelContainer;

/** tag标签*/
@property (nonatomic, strong) YYEdgeLabel *tagLabel1;

/** tag标签*/
@property (nonatomic, strong) YYEdgeLabel *tagLabel2;

/** cellSeparator*/
//@property (nonatomic, strong) UIView *cellSeparator;

@end

@implementation YYNiuArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //创建子控件
        [self createSubview];
        
        //添加约束
        [self configAutoLayout];
        
    }
    return self;
}

-(void)setNiuArtModel:(YYNiuArticleModel *)niuArtModel {
    _niuArtModel = niuArtModel;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:niuArtModel.picurl] placeholderImage:imageNamed(@"placeholder") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    _title.text = niuArtModel.title;
    _desc.text = niuArtModel.art_description;
    _time.text = niuArtModel.posttime;
    
    if (niuArtModel.keywords.length) {
        if ([niuArtModel.keywords containsString:@" "]) {
            NSArray *keywoeds = [niuArtModel.keywords componentsSeparatedByString:@" "];
            self.tagLabel1.text = keywoeds[0];
            self.tagLabel2.text = keywoeds[1];
        }else{
            
            self.tagLabel1.text = niuArtModel.keywords;
        }
    }

}


/**
 *  创建子控件
 */
- (void)createSubview {
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 2;
    [self.contentView addSubview:title];
    self.title = title;
    
//    UILabel *desc = [[UILabel alloc] init];
//    desc.font = SubTitleFont;
//    desc.textColor = SubTitleColor;
//    desc.numberOfLines = 2;
//    [self.contentView addSubview:desc];
//    self.desc = desc;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    [self.contentView addSubview:time];
    self.time = time;

//    YYEdgeLabel *tagLabel1 = [[YYEdgeLabel alloc] init];
//    tagLabel1.font = TagLabelFont;
//    tagLabel1.textColor = ThemeColor;
//    tagLabel1.layer.borderColor = ThemeColor.CGColor;
//    //    tagLabel1.layer.borderWidth = 0.5;
//    tagLabel1.layer.cornerRadius = 3;
//    [self.contentView addSubview:tagLabel1];
//    self.tagLabel1 = tagLabel1;
    
//    YYEdgeLabel *tagLabel2 = [[YYEdgeLabel alloc] init];
//    tagLabel2.font = TagLabelFont;
//    tagLabel2.textColor = ThemeColor;
//    tagLabel2.layer.borderColor = ThemeColor.CGColor;
//    //    tagLabel2.layer.borderWidth = 0.5;
//    tagLabel2.layer.cornerRadius = 3;
//    [self.contentView addSubview:tagLabel2];
//    self.tagLabel2 = tagLabel2;
    
//    UIView *cellSeparator = [[UIView alloc] init];
//    cellSeparator.backgroundColor = LightGraySeperatorColor;
//    [self.contentView addSubview:cellSeparator];
//    self.cellSeparator = cellSeparator;
    
}

/**
 *  添加约束
 */
- (void)configAutoLayout {
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(YYNewsCellTopMargin);
        make.left.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.height.equalTo(80);
        make.width.equalTo(110);
        make.bottom.equalTo(-YYNewsCellBottomMargin);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.top);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
    }];
    
//    [self.desc makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
//        make.left.equalTo(self.title.left);
//        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
//        make.bottom.equalTo(self.leftImageView.bottom);
//    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.leftImageView.bottom);
    }];
    
    
//    [self.tagLabel1 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellSubMargin);
//        make.bottom.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
//    }];

//    [self.tagLabel2 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tagLabel1.right).offset(YYInfoCellCommonMargin);
//        make.bottom.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
//    }];
    
    //底部分隔线的约束
//    [self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.bottom).offset(-0.5);
//        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
//        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
//        make.height.offset(0.5);
//    }];
    
}


@end





