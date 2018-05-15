//
//  YYHotTableViewCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  热搜排行cell

#import "YYHotTableViewCell.h"
#import "YYHotHotModel.h"
#import "YYBaseHotModel.h"

@interface YYHotTableViewCell()

/** indexButton排序*/
@property (nonatomic, strong) UIButton *indexButton;

/** title标题*/
@property (nonatomic, strong) UILabel *title;

/** link网址*/
@property (nonatomic, strong) UILabel *link;

/** 人气值*/
@property (nonatomic, strong) UILabel *renqizhi;

/** 人气值数字*/
@property (nonatomic, strong) UILabel *renqiValue;

/** 上升箭头*/
@property (nonatomic, strong) UIImageView *upImageView;

/** index*/
@property (nonatomic, assign) NSInteger index;

@end

@implementation YYHotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.indexButton];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.link];
        [self.contentView addSubview:self.renqizhi];
        [self.contentView addSubview:self.renqiValue];
        [self.contentView addSubview:self.upImageView];
        
        [self configSubviewLayout];
    }
    return self;
}

/** 配置子视图的约束*/
- (void)configSubviewLayout {
    
    [self.indexButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(YYInfoCellCommonMargin);
        make.width.equalTo(30);
        make.bottom.equalTo(self.contentView.bottom).offset(-YYInfoCellCommonMargin);
    }];
    
    [self.title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indexButton.right).offset(YYInfoCellSubMargin);
        make.centerY.equalTo(self.indexButton);
    }];
    
    [self.renqizhi makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.upImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(15);
        make.right.equalTo(self.contentView).offset(-YYInfoCellCommonMargin+2);
    }];
    
    [self.renqiValue makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.renqizhi.bottom);
        make.centerY.equalTo(self.upImageView);
        make.right.equalTo(self.upImageView.left);
        make.width.lessThanOrEqualTo(50);
    }];

    [self.link makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.right).offset(YYInfoCellSubMargin);
        make.right.equalTo(self.renqiValue.left).offset(-YYInfoCellCommonMargin);
        make.centerY.equalTo(self.title);
    }];
    
}


- (void)setHotModel:(YYHotHotModel *)hotModel andIndex:(NSInteger)index{
    _hotModel = hotModel;
    
    _title.text = hotModel.rname;
    _title.textColor = hotModel.selected ? UnenableTitleColor : TitleColor;
    _link.text = hotModel.rlink;
    _renqiValue.text = hotModel.pop_num;
    
    _index = index;
    switch (index) {
        case 0:
            [_indexButton setImage:imageNamed(@"yyfw_main_first_40x40_") forState:UIControlStateNormal];
            break;
            
        case 1:
            [_indexButton setImage:imageNamed(@"yyfw_main_second_40x40_") forState:UIControlStateNormal];
            break;
            
        case 2:
            [_indexButton setImage:imageNamed(@"yyfw_main_third_40x40_") forState:UIControlStateNormal];
            break;
            
        default:
            [_indexButton setTitle:[NSString stringWithFormat:@"%ld.",index+1] forState:UIControlStateNormal];
            break;
    }
    
}


- (void)setBaseModel:(YYBaseHotModel *)baseModel andIndex:(NSInteger)index {
    
    _baseModel = baseModel;
    _title.text = baseModel.self_name;
    _title.textColor = baseModel.selected ? UnenableTitleColor : TitleColor;
    _link.text = baseModel.self_link;
    _renqiValue.text = baseModel.pop_value;
    
    _index = index;
    [_indexButton setTitle:[NSString stringWithFormat:@"%ld.",index+1] forState:UIControlStateNormal];
//    switch (index) {
//        case 0:
//            [_indexButton setImage:imageNamed(@"yyfw_main_first_40x40_") forState:UIControlStateNormal];
//            break;
//            
//        case 1:
//            [_indexButton setImage:imageNamed(@"yyfw_main_second_40x40_") forState:UIControlStateNormal];
//            break;
//            
//        case 2:
//            [_indexButton setImage:imageNamed(@"yyfw_main_third_40x40_") forState:UIControlStateNormal];
//            break;
//            
//        default:
//            [_indexButton setTitle:[NSString stringWithFormat:@"%ld.",index+1] forState:UIControlStateNormal];
//            break;
//    }

}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)indexButton{
    if (!_indexButton) {
        _indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indexButton setTitleColor:TitleColor forState:UIControlStateNormal];
    }
    return _indexButton;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = TitleFont;
        _title.textColor = TitleColor;
        [_title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    }
    return _title;
}

- (UILabel *)link{
    if (!_link) {
        _link = [[UILabel alloc] init];
        _link.font = SubTitleFont;
        _link.textColor = SubTitleColor;
    }
    return _link;
}

- (UILabel *)renqizhi{
    if (!_renqizhi) {
        _renqizhi = [[UILabel alloc] init];
        _renqizhi.font = UnenableTitleFont;
        _renqizhi.textColor = UnenableTitleColor;
        _renqizhi.text = @"人气值";
    }
    return _renqizhi;
}

- (UILabel *)renqiValue{
    if (!_renqiValue) {
        _renqiValue = [[UILabel alloc] init];
        _renqiValue.font = UnenableTitleFont;
        _renqiValue.textColor = ThemeColor;
        _renqiValue.textAlignment = NSTextAlignmentRight;
    }
    return _renqiValue;
}

- (UIImageView *)upImageView{
    if (!_upImageView) {
        _upImageView = [[UIImageView alloc] init];
        _upImageView.image = imageNamed(@"yyfw_main_up_20x20_");
        _upImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _upImageView;
}

@end
