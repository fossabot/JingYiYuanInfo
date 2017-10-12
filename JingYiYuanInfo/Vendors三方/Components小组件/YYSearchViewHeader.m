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

/** 猜你喜欢*/
@property (nonatomic, strong) UIView *caiView;

/** 标签区*/
@property (nonatomic, strong) LabelContainer *tagZone;

@end

@implementation YYSearchViewHeader

- (instancetype)initWithDatas:(NSArray *)datas {
    self = [[YYSearchViewHeader alloc] initWithFrame:CGRectZero];
    if (self) {
        _datas = [datas copy];
        
        [self addSubview:self.caiView];
        
        [self addSubview:self.tagZone];
        
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
    
    self.bounds = CGRectMake(0, 0, kSCREENWIDTH, CGRectGetMaxY(self.tagZone.frame)+YYInfoCellCommonMargin);
}

#pragma mark -- labelcontainer 的代理方法
/** 选中哪个标签*/
- (void)labelContainerDidClickAtIndex:(NSInteger)index labelTitle:(NSString *)title {
    
    if (self.changeTagBlock) {
        self.changeTagBlock(index);
    }
    YYLog(@"选中了button ： %@, index : %ld",title,(long)index);
    
}


- (UIView *)caiView {
    if (!_caiView) {
        _caiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _caiView.backgroundColor = [UIColor whiteColor];
//        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 13, 3, 14)];
//        redview.backgroundColor = ThemeColor;
//        [_caiView addSubview:redview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"热门搜索";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SubTitleFont;
        label.textColor = SubTitleColor;
        [_caiView addSubview:label];
        
    }
    return _caiView;
}


- (LabelContainer *)tagZone {
    if (!_tagZone) {
        _tagZone = [[LabelContainer alloc] initWithTitles:_datas andFrame:CGRectMake(0, CGRectGetMaxY(self.caiView.frame)+10, kSCREENWIDTH, 0) labelContainerStableEdge:LabelContainerStableEdgeWidth delegate:self];
    }
    return _tagZone;
}

@end
