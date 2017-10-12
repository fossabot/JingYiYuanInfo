//
//  YYNewsPicturesCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNewsPicturesCell.h"
#import "YYHotInfoModel.h"
#import "YYEdgeLabel.h"
#import "YYHotPicsModel.h"

@interface YYNewsPicturesCell()

/** cell对应的新闻的id  留着给记录阅读状态使用*/
@property (nonatomic, copy) NSString *infoid;

/** cellSeparator*/
@property (nonatomic, strong) UIView *cellSeparator;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic;

/** images图片数量*/
@property (nonatomic, strong) UIButton *imageCount;

/** tag标签*/
@property (nonatomic, strong) UILabel *tagLabel1;

/** tag标签*/
@property (nonatomic, strong) UILabel *tagLabel2;

/** source来源*/
@property (nonatomic, strong) UILabel *source;

/** time时间*/
@property (nonatomic, strong) UILabel *time;

@end


@implementation YYNewsPicturesCell

- (void)dealloc {
    
    YYLogFunc
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子控件
        [self createSubview];
        
        //添加约束
        [self configSubviews];
        
    }
    return self;
}

- (void)setHotinfoModel:(YYHotInfoModel *)hotinfoModel {
    _hotinfoModel = hotinfoModel;
    _infoid = hotinfoModel.infoid;
    _title.text = hotinfoModel.title;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageUrl = nil;
    if (hotinfoModel.picarr.count) {
        YYHotPicsModel *model = hotinfoModel.picarr[0];
        if (model.img) {
            
            imageUrl = [NSURL URLWithString:model.img];
        }else {
            imageUrl = [NSURL URLWithString:@"http://www.baidu.png"];
        }
        YYLog(@"imageurl %@ ",model.img);
    }
    YYWeakSelf
    [_newsPic sd_setImageWithURL:imageUrl placeholderImage:imageNamed(@"placeholder") options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [manager diskImageExistsForURL:imageURL completion:^(BOOL isInCache) {
            if (isInCache) {
                return;//缓存中有，不再加载
            }
            //imageView的淡入效果
            weakSelf.newsPic.alpha = 0.0;
            [UIView transitionWithView:weakSelf.newsPic
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakSelf.newsPic.alpha = 1.0;
                            } completion:nil];
        }];
    }];
    
    [_imageCount setTitle:[NSString stringWithFormat:@"%ld图",hotinfoModel.picarr.count] forState:UIControlStateNormal];
    
    _time.text = hotinfoModel.posttime;
    _source.text = hotinfoModel.source;
    
    if (hotinfoModel.keywords.length) {
        if ([hotinfoModel.keywords containsString:@" "]) {
            NSArray *keywoeds = [hotinfoModel.keywords componentsSeparatedByString:@" "];
            self.tagLabel1.text = keywoeds[0];
            self.tagLabel2.text = keywoeds[1];
        }else if ([hotinfoModel.keywords containsString:@"，"]){
            
            NSArray *keywoeds = [hotinfoModel.keywords componentsSeparatedByString:@"，"];
            self.tagLabel1.text = keywoeds[0];
            self.tagLabel2.text = keywoeds[1];
        }else{
            
            self.tagLabel1.text = hotinfoModel.keywords;
            [self.source updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.tagLabel1.right).offset(YYInfoCellSubMargin);
            }];
        }
    }else{
        [self.source updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.newsPic);
        }];
    }
    
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
    
    UIImageView *newsPic = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic];
    self.newsPic = newsPic;
    
    //    UILabel *subTitle = [[UILabel alloc] init];
    //    subTitle.font = SubTitleFont;
    //    subTitle.textColor = SubTitleColor;
    //    [self.contentView addSubview:title];
    //    self.subTitle = subTitle;
   
    UIButton *imageCount = [UIButton buttonWithType:UIButtonTypeCustom];
    imageCount.titleLabel.font = UnenableTitleFont;
    [imageCount setTitleColor:WhiteColor forState:UIControlStateNormal];
    imageCount.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [imageCount setImage:imageNamed(@"pics") forState:UIControlStateNormal];
    imageCount.layer.masksToBounds = YES;
    imageCount.layer.cornerRadius = 5;
    imageCount.userInteractionEnabled = NO;
    [self.newsPic addSubview:imageCount];
    self.imageCount = imageCount;
    
    
    YYEdgeLabel *tagLabel1 = [[YYEdgeLabel alloc] init];
    tagLabel1.font = UnenableTitleFont;
    tagLabel1.textColor = UnenableTitleColor;
    tagLabel1.layer.borderColor = ThemeColor.CGColor;
    [self.contentView addSubview:tagLabel1];
    self.tagLabel1 = tagLabel1;
    
    YYEdgeLabel *tagLabel2 = [[YYEdgeLabel alloc] init];
    tagLabel2.font = UnenableTitleFont;
    tagLabel2.textColor = UnenableTitleColor;
    tagLabel2.layer.borderColor = ThemeColor.CGColor;
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
 配置子控件的约束
 */
- (void)configSubviews {
    //底部分隔线的约束
    [self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-1);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(0.5);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {//设置第一个cell的标题label约束
        
        make.left.top.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        
    }];
    
    [self.newsPic makeConstraints:^(MASConstraintMaker *make) {//图片的约束
        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo((kSCREENWIDTH-20)*0.6);
    }];
    
    [self.imageCount makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(-YYInfoCellSubMargin);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        make.top.equalTo(self.newsPic.bottom).offset(YYInfoCellSubMargin);
    }];
    
//    [self.container makeConstraints:^(MASConstraintMaker *make) {//点击量label的约束
//        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
//        make.top.equalTo(self.newsPic.bottom).offset(YYInfoCellSubMargin);
//    }];
    
    [self.tagLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsPic);
        make.centerY.equalTo(self.time);
    }];
    
    [self.tagLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel1.right).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.time);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {//来源label的约束
        make.left.equalTo(self.tagLabel2.right).offset(YYInfoCellSubMargin);
        make.top.equalTo(self.time.top);
    }];
    
    
}

@end
