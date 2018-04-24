//
//  YYSearchViewHeader.m
//  JingYiYuanInfo
//
//  Created by 杨春禹 on 2017/10/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSearchViewHeader.h"
#import "LabelContainer.h"

@interface YYSearchViewHeader()<LabelContainerClickDelegate>

/** 热门搜索*/
@property (nonatomic, strong) UILabel *hotLabel;
/** 标签区*/
@property (nonatomic, strong) LabelContainer *tagZone;
/** 搜索历史*/
@property (nonatomic, strong) UILabel *historyLabel;

@end

@implementation YYSearchViewHeader

- (instancetype)initWithDatas:(NSArray *)datas {
    self = [[YYSearchViewHeader alloc] initWithFrame:CGRectZero];
    if (self) {
        _datas = [datas copy];
        
        [self addSubview:self.hotLabel];
        [self addSubview:self.tagZone];
        [self addSubview:self.historyLabel];
        
        [self renderUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas {
    _datas = [datas copy];
    
    [self.tagZone setTitles:datas];
    [self renderUI];
}


- (void)renderUI {
    
    self.historyLabel.frame = CGRectMake(10, CGRectGetMaxY(self.tagZone.frame), 100, 20);
    self.bounds = CGRectMake(0, 0, kSCREENWIDTH, CGRectGetMaxY(self.historyLabel.frame));
}

#pragma mark -- labelcontainer 的代理方法
/** 选中哪个标签*/
- (void)labelContainerDidClickAtIndex:(NSInteger)index labelTitle:(NSString *)title {
    
    if (self.changeTagBlock) {
        self.changeTagBlock(index);
    }
    YYLog(@"选中了button ： %@, index : %ld",title,(long)index);
    
}


- (UILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        _hotLabel.backgroundColor = [UIColor whiteColor];
        _hotLabel.text = @"热门搜索";
        _hotLabel.textAlignment = NSTextAlignmentLeft;
        _hotLabel.font = SubTitleFont;
        _hotLabel.textColor = TitleColor;
    }
    return _hotLabel;
} 

- (UILabel *)historyLabel {
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tagZone.frame)+10, 100, 20)];
        _historyLabel.backgroundColor = [UIColor whiteColor];
        _historyLabel.text = @"搜索历史";
        _historyLabel.textAlignment = NSTextAlignmentLeft;
        _historyLabel.font = SubTitleFont;
        _historyLabel.textColor = TitleColor;
    }
    return _historyLabel;
}

- (LabelContainer *)tagZone {
    if (!_tagZone) {
        _tagZone = [[LabelContainer alloc] initWithTitles:_datas andFrame:CGRectMake(0, CGRectGetMaxY(self.hotLabel.frame), kSCREENWIDTH, 0) edgeInset:UIEdgeInsetsMake(5, 10, 5, 10) labelContainerStableEdge:LabelContainerStableEdgeWidth rowMargin:10 labelMargin:15 delegate:self];
        _tagZone.labelMaskToBounds = YES;
        _tagZone.labelCornerRadius = 5;
        _tagZone.labelTitleColor = SubTitleColor;
        
    }
    return _tagZone;
}

@end
