//
//  YYProductionCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProductionCell.h"
#import "YYEdgeLabel.h"

@interface YYProductionCell()

/** leftImageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** 产品图片上的标签*/
@property (nonatomic, strong) UILabel *imageTagLabel;

/** 标题*/
@property (nonatomic, strong) UILabel *title;

/** 副标题*/
@property (nonatomic, strong) UILabel *subTitle;

/** 标签1*/
@property (nonatomic, strong) YYEdgeLabel *tag1;

/** 标签2*/
@property (nonatomic, strong) YYEdgeLabel *tag2;

/** 标签3*/
@property (nonatomic, strong) YYEdgeLabel *tag3;

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
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UILabel *imageTagLabel = [[UILabel alloc] init];
    imageTagLabel.textColor = WhiteColor;
    imageTagLabel.font = UnenableTitleFont;
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
    [self.contentView addSubview:subTitle];
    self.subTitle = subTitle;
    
    YYEdgeLabel *tag1 = [[YYEdgeLabel alloc] init];
    tag1.font = UnenableTitleFont;
    tag1.textColor = ThemeColor;
    [self.contentView addSubview:tag1];
    self.tag1 = tag1;
    
    YYEdgeLabel *tag2 = [[YYEdgeLabel alloc] init];
    tag2.font = UnenableTitleFont;
    tag2.textColor = ThemeColor;
    [self.contentView addSubview:tag2];
    self.tag2 = tag2;
    
    YYEdgeLabel *tag3 = [[YYEdgeLabel alloc] init];
    tag3.font = UnenableTitleFont;
    tag3.textColor = ThemeColor;
    [self.contentView addSubview:tag3];
    self.tag3 = tag3;
    
    UILabel *price = [[UILabel alloc] init];
    price.font = UnenableTitleFont;
    price.textColor = ThemeColor;
    [self.contentView addSubview:price];
    self.price = price;
    
    YYEdgeLabel *status = [[YYEdgeLabel alloc] init];
    status.font = SubTitleFont;
    status.textColor = WhiteColor;
    status.edgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    [self.contentView addSubview:status];
    self.status = status;
    
}

- (void)masonrySubView {
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(YYInfoCellCommonMargin);
        make.width.equalTo(100);
        make.height.equalTo(80);
    }];
    
    [self.imageTagLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.leftImageView);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.right).offset(YYInfoCellCommonMargin);
    }];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.title.bottom);
        make.left.equalTo(self.title);
    }];
    
    [self.tag1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.subTitle.bottom);
        make.left.equalTo(self.title);
    }];
    
    [self.tag2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.subTitle.bottom);
        make.left.equalTo(self.tag1.right).offset(YYInfoCellSubMargin);
    }];
    
    [self.tag3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.subTitle.bottom);
        make.left.equalTo(self.tag2.right).offset(YYInfoCellSubMargin);
    }];
    
    [self.price makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.leftImageView.bottom);
        make.left.equalTo(self.title);
    }];
    
    [self.status makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.leftImageView);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
