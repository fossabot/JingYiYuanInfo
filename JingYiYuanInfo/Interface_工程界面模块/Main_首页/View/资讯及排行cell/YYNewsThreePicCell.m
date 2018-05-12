//
//  YYNewsThreePicCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNewsThreePicCell.h"
#import "YYHotInfoModel.h"
#import "YYTagView.h"
#import "YYHotPicsModel.h"

#define imgWidth ((kSCREENWIDTH-30)/3)

@interface YYNewsThreePicCell()

/** cell对应的新闻的id  留着给记录阅读状态使用*/
@property (nonatomic, copy) NSString *infoid;

/** cellSeparator*/
@property (nonatomic, strong) UIView *cellSeparator;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic1;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic2;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic3;

/** tag标签*/
@property (nonatomic, strong) YYTagView *tagLabel1;

/** tag标签*/
@property (nonatomic, strong) YYTagView *tagLabel2;

/** source来源*/
@property (nonatomic, strong) UILabel *source;

/** time时间*/
@property (nonatomic, strong) UILabel *time;


@end

@implementation YYNewsThreePicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubview];
        
        [self configSubviews];
    }
    return self;
}

- (void)setHotinfoModel:(YYHotInfoModel *)hotinfoModel {
    _hotinfoModel = hotinfoModel;
    _infoid = hotinfoModel.infoid;
    _title.text = hotinfoModel.title;
    
    YYWeakSelf
//    NSArray *images = @[weakSelf.newsPic1, weakSelf.newsPic2, weakSelf.newsPic3];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    NSArray *tempArr = hotinfoModel.picarr;
    if (tempArr.count == 0) {
        YYHotPicsModel *model = [[YYHotPicsModel alloc] init];
        model.img = @"";
        model.desc = @"";
        tempArr = [NSArray arrayWithObjects:model,model,model, nil];
    }
    YYHotPicsModel *model1 = tempArr[0];
    NSURL *imageUrl = [NSURL URLWithString:model1.img];
    [_newsPic1 sd_setImageWithURL:imageUrl placeholderImage:imageNamed(placeHolderMini) options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [manager diskImageExistsForURL:imageURL completion:^(BOOL isInCache) {
            if (isInCache) {
                return;//缓存中有，不再加载
            }
            //imageView的淡入效果
            weakSelf.newsPic1.alpha = 0.0;
            [UIView transitionWithView:weakSelf.newsPic1
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakSelf.newsPic1.alpha = 1.0;
                            } completion:nil];
        }];
    }];

    YYHotPicsModel *model2 = tempArr[1];
    NSURL *imageUrl2 = [NSURL URLWithString:model2.img];
    [_newsPic2 sd_setImageWithURL:imageUrl2 placeholderImage:imageNamed(placeHolderMini) options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [manager diskImageExistsForURL:imageURL completion:^(BOOL isInCache) {
            if (isInCache) {
                return;//缓存中有，不再加载
            }
            //imageView的淡入效果
            weakSelf.newsPic2.alpha = 0.0;
            [UIView transitionWithView:weakSelf.newsPic2
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakSelf.newsPic2.alpha = 1.0;
                            } completion:nil];
        }];
    }];
    
    YYHotPicsModel *model3 = tempArr[2];
    NSURL *imageUrl3 = [NSURL URLWithString:model3.img];
    [_newsPic3 sd_setImageWithURL:imageUrl3 placeholderImage:imageNamed(placeHolderMini) options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [manager diskImageExistsForURL:imageURL completion:^(BOOL isInCache) {
            if (isInCache) {
                return;//缓存中有，不再加载
            }
            //imageView的淡入效果
            weakSelf.newsPic3.alpha = 0.0;
            [UIView transitionWithView:weakSelf.newsPic3
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakSelf.newsPic3.alpha = 1.0;
                            } completion:nil];
        }];
    }];
    
//    int index = 0;
//    for (UIImageView *iamgeView in images) {
//        YYHotPicsModel *model;
//        NSURL *imageUrl;
//        if (hotinfoModel.picarr.count) {
//            
//            model = hotinfoModel.picarr[index];
//            imageUrl = [NSURL URLWithString:model.img];
//        }else {
//            imageUrl = [NSURL URLWithString:@"http://www.baidu.png"];
//        }
//        
////        YYLog(@"picarr  >>>>>>  %@",model.img);
//        
//        [iamgeView sd_setImageWithURL:imageUrl placeholderImage:imageNamed(@"placeholder") options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            [manager diskImageExistsForURL:imageURL completion:^(BOOL isInCache) {
//                if (isInCache) {
//                    return;//缓存中有，不再加载
//                }
//                //imageView的淡入效果
//                iamgeView.alpha = 0.0;
//                [UIView transitionWithView:iamgeView
//                                  duration:0.3
//                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                animations:^{
//                                    iamgeView.alpha = 1.0;
//                                } completion:nil];
//            }];
//        }];
//        index++;
//    }
    
    _time.text = hotinfoModel.posttime;
    _source.text = hotinfoModel.source;
    
    if (![hotinfoModel.keywords isEqualToString:@""] ) {
        if ([hotinfoModel.keywords containsString:@" "]) {
            NSArray *keywoeds = [hotinfoModel.keywords componentsSeparatedByString:@" "];
            self.tagLabel1.title = keywoeds[0];
            self.tagLabel2.title = keywoeds[1];
        }else if ([hotinfoModel.keywords containsString:@","]){
            
            NSArray *keywoeds = [hotinfoModel.keywords componentsSeparatedByString:@","];
            self.tagLabel1.title = keywoeds[0];
            self.tagLabel2.title = keywoeds[1];
        }else{
            
            self.tagLabel1.title = hotinfoModel.keywords;
            self.tagLabel2.title = @"";
//            [self.source updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.tagLabel1.right).offset(YYInfoCellSubMargin);
//            }];
        }
    }else{
        self.tagLabel1.title = @"";
        self.tagLabel2.title = @"";
//        [self.source updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
//        }];
    }
    
    [self.tagLabel1 setNeedsLayout];
    [self.tagLabel2 setNeedsLayout];
}


/**
 *  创建子控件
 */
- (void)createSubview {
    
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
    
    UIImageView *newsPic1 = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic1];
    self.newsPic1 = newsPic1;
    
    UIImageView *newsPic2 = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic2];
    self.newsPic2 = newsPic2;
    
    UIImageView *newsPic3 = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic3];
    self.newsPic3 = newsPic3;
        
    YYTagView *tagLabel1 = [[YYTagView alloc] init];
    tagLabel1.rightMargin = YYInfoCellSubMargin;
//    tagLabel1.font = TagLabelFont;
//    tagLabel1.textColor = ThemeColor;
//    tagLabel1.layer.borderColor = ThemeColor.CGColor;
//    tagLabel1.layer.borderWidth = 0.5;
//    tagLabel1.layer.cornerRadius = 3;
    [self.contentView addSubview:tagLabel1];
    self.tagLabel1 = tagLabel1;
    
    YYTagView *tagLabel2 = [[YYTagView alloc] init];
    tagLabel2.rightMargin = YYInfoCellSubMargin;
//    tagLabel2.font = TagLabelFont;
//    tagLabel2.textColor = ThemeColor;
//    tagLabel2.layer.borderColor = ThemeColor.CGColor;
//    tagLabel2.layer.borderWidth = 0.5;
//    tagLabel2.layer.cornerRadius = 3;
    [self.contentView addSubview:tagLabel2];
    self.tagLabel2 = tagLabel2;
    
    UILabel *source = [[UILabel alloc] init];
    source.font = UnenableTitleFont;
    source.textColor = UnenableTitleColor;
    [self.contentView addSubview:source];
    self.source = source;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = UnenableTitleFont;
    time.textColor = UnenableTitleColor;
    [self.contentView addSubview:time];
    self.time = time;
    
}

/**
 配置子控件的约束（根据celltype来确定cell样式）
 */
- (void)configSubviews {
    
    //底部分隔线的约束
    [self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-0.5);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(0.5);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(YYNewsCellTopMargin);
        make.left.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
    }];
    
    
    NSArray *arr = @[_newsPic1,_newsPic2,_newsPic3];
//    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:YYInfoCellSubMargin leadSpacing:YYInfoCellCommonMargin tailSpacing:YYInfoCellCommonMargin];
//    [arr makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
////        make.bottom.equalTo(self.contentView.bottom).offset(-YYInfoCellCommonMargin);
//        make.height.equalTo((9/16)*(kSCREENWIDTH-30)/3);
//    }];
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    
    [arr makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.bottom).offset(YYInfoCellCommonMargin);
        make.height.equalTo(imgWidth*7/11);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-YYNewsCellBottomMargin);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        make.top.equalTo(self.newsPic1.bottom).offset(YYInfoCellCommonMargin);
    }];

    
    [self.tagLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.time);
    }];
    
    [self.tagLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel1.right);
        make.centerY.equalTo(self.time);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {//来源label的约束
        make.left.equalTo(self.tagLabel2.right);
        make.top.equalTo(self.time.top);
    }];
    
    
}

@end
