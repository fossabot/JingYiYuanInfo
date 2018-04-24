//
//  YYNewsLeftPicCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNewsLeftPicCell.h"
#import "LabelContainer.h"
#import "YYHotInfoModel.h"
#import "YYTagView.h"

#define imgWidth ((kSCREENWIDTH-30)/3)

@interface YYNewsLeftPicCell()

/** cell对应的新闻的id  留着给记录阅读状态使用*/
@property (nonatomic, copy) NSString *infoid;

/** cellSeparator*/
@property (nonatomic, strong) UIView *cellSeparator;

/** title*/
@property (nonatomic, strong) UILabel *title;

/** newsPic*/
@property (nonatomic, strong) UIImageView *newsPic;

/** subTitle*/
@property (nonatomic, strong) UILabel *subTitle;

/** tag标签*/
@property (nonatomic, strong) LabelContainer *container;

/** tag标签*/
@property (nonatomic, strong) YYTagView *tagLabel1;

/** tag标签*/
@property (nonatomic, strong) YYTagView *tagLabel2;

/** source来源*/
@property (nonatomic, strong) UILabel *source;

/** time时间*/
@property (nonatomic, strong) UILabel *time;

@end


@implementation YYNewsLeftPicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建子控件
        [self configSubView];
        
        //添加约束
        [self masonrySubview];
    }
    return self;
}

- (void)setHotinfoModel:(YYHotInfoModel *)hotinfoModel {
    _hotinfoModel = hotinfoModel;
    _infoid = hotinfoModel.infoid;
    _title.text = hotinfoModel.title;
    _subTitle.text = hotinfoModel.infodescription;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSLog(@"picurl -- %@",hotinfoModel.picurl);
    NSURL *imageUrl = [NSURL URLWithString:hotinfoModel.picurl];
//    [_newsPic sd_setImageWithURL:imageUrl placeholderImage:imageNamed(@"placeholder")];
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

    _time.text = hotinfoModel.posttime;

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
//            make.left.equalTo(self.title);
//        }];
    }
    [self.tagLabel1 setNeedsLayout];
    [self.tagLabel2 setNeedsLayout];
    
    _source.text = hotinfoModel.source;
    
}


/**
 *  创建子控件
 */
- (void)configSubView {
    
    UIView *cellSeparator = [[UIView alloc] init];
    cellSeparator.backgroundColor = GraySeperatorColor;
    [self.contentView addSubview:cellSeparator];
    self.cellSeparator = cellSeparator;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    title.numberOfLines = 2;
    [self.contentView addSubview:title];
    self.title = title;
    
    UIImageView *newsPic = [[UIImageView alloc] init];
    [self.contentView addSubview:newsPic];
    self.newsPic = newsPic;
    
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
 配置子控件的约束
 */
- (void)masonrySubview {
    //底部分隔线的约束
    [self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-0.5);
        make.left.equalTo(self.contentView.left).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.height.equalTo(0.5);
    }];
    
    [self.newsPic makeConstraints:^(MASConstraintMaker *make) {//图片的约束
        make.top.equalTo(YYNewsCellTopMargin);
        make.left.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.width.equalTo(imgWidth);
        make.height.equalTo(imgWidth*7/11);
        make.bottom.equalTo(self.contentView.bottom).offset(-YYNewsCellBottomMargin);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {//设置第一个cell的标题label约束

        make.top.equalTo(self.newsPic);
        make.left.equalTo(self.newsPic.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
    }];
    
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {//时间label的约束
        make.right.equalTo(self.contentView.right).offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.newsPic.bottom);
        
    }];
    
    [self.tagLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsPic.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.time);
    }];
    
    [self.tagLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel1.right);
        make.centerY.equalTo(self.time);
    }];
    
    [self.source makeConstraints:^(MASConstraintMaker *make) {//来源label的约束
        make.left.equalTo(self.tagLabel2.right);
        make.bottom.equalTo(self.newsPic.bottom);
    }];
    
}


@end
