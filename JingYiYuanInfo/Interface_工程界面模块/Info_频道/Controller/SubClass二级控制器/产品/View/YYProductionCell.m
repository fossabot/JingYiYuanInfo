//
//  YYProductionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProductionCell.h"
#import "YYEdgeLabel.h"
#import "YYProductionCommonModel.h"
#import "YYProductionVIPModel.h"


@interface YYProductionCell()

/** leftImageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** 产品图片上的标签*/
@property (nonatomic, strong) UILabel *imageTagLabel;

/** 产品标题*/
@property (nonatomic, strong) UILabel *title;

/** 产品描述*/
@property (nonatomic, strong) UILabel *subTitle;

/** 价格*/
@property (nonatomic, strong) UILabel *price;

/** 在售状态*/
@property (nonatomic, strong) YYEdgeLabel *status;

@end

@implementation YYProductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)configSubView {
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UILabel *imageTagLabel = [[UILabel alloc] init];
    imageTagLabel.textAlignment = NSTextAlignmentCenter;
    imageTagLabel.font = UnenableTitleFont;
    imageTagLabel.textColor = WhiteColor;
    imageTagLabel.backgroundColor = OrangeColor;
    [self.leftImageView addSubview:imageTagLabel];
    self.imageTagLabel = imageTagLabel;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = TitleFont;
    title.textColor = TitleColor;
    [self.contentView addSubview:title];
    self.title = title;
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.font = UnenableTitleFont;
    subTitle.textColor = SubTitleColor;
    subTitle.numberOfLines = 2;
    [self.contentView addSubview:subTitle];
    self.subTitle = subTitle;
    
    UILabel *price = [[UILabel alloc] init];
    price.font = UnenableTitleFont;
    price.textColor = ThemeColor;
    [self.contentView addSubview:price];
    self.price = price;
    
    YYEdgeLabel *status = [[YYEdgeLabel alloc] init];
    status.font = SubTitleFont;
    status.textColor = WhiteColor;
    status.layer.borderWidth = 0.0;
    status.edgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    [self.contentView addSubview:status];
    self.status = status;
    
}

- (void)masonrySubView {
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(YYCommonCellLeftMargin);
        make.width.equalTo(100);
        make.height.equalTo(80);
    }];
    
    [self.imageTagLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.leftImageView);
        make.width.equalTo(15);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYCommonCellRightMargin);
    }];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom).offset(YYInfoCellSubMargin);
        make.left.equalTo(self.title);
        make.right.equalTo(-YYCommonCellRightMargin);
    }];
    
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.leftImageView.bottom);
        make.left.equalTo(self.title);
    }];
    
    [self.status makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYCommonCellRightMargin);
        make.bottom.equalTo(self.leftImageView);
    }];
    
}


- (void)setCommonModel:(YYProductionCommonModel *)commonModel {
    
    _commonModel = commonModel;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:commonModel.com_pic] placeholderImage:imageNamed(placeHolderMini)];
    self.imageTagLabel.text = commonModel.label;
    self.title.text = commonModel.yname;
    self.subTitle.text = commonModel.introduce;
    self.price.text = commonModel.iosyprice;
    self.status.text = commonModel.ystate;
    if ([commonModel.ystate isEqualToString:@"在售"]) {
        self.status.backgroundColor = OrangeColor;
    }else {
        self.status.backgroundColor = UnactiveColor;
    }
    
}

- (void)setVipModel:(YYProductionVIPModel *)vipModel {
    
    _vipModel = vipModel;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:vipModel.titleimg] placeholderImage:imageNamed(placeHolderMini)];
    self.title.text = vipModel.title;
    self.price.text = vipModel.iosyprice;
    self.status.text = vipModel.sellstate;
    if ([vipModel.sellstate isEqualToString:@"在售"]) {
        self.status.backgroundColor = OrangeColor;
    }else {
        self.status.backgroundColor = UnactiveColor;
    }
}




@end
