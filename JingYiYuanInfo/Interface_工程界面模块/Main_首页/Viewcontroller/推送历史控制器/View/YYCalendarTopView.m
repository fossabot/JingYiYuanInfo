//
//  YYCalendarTopView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/30.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCalendarTopView.h"

#import "YYCalendarCollectionCell.h"

#import "YYPushViewModel.h"
#import "YYCalendarTopViewModel.h"

#import "NSDate+YYCalculation.h"

@interface YYCalendarTopView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** leftImageView*/
@property (nonatomic, strong) UIImageView *leftImageView;

/** rightImageView*/
@property (nonatomic, strong) UIImageView *rightImageView;

/** collectioinView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** viewModel*/
@property (nonatomic, strong) YYPushViewModel *viewModel;


@end

@implementation YYCalendarTopView
{
    NSInteger _selectedIndex;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 60)];
    if (self) {
        [self configViewWithFrame:frame];
    }
    return self;
}


- (void)configViewWithFrame:(CGRect)frame {
    
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.collectionView];
    [self refreshTopViewWithDate:[NSDate date]];

}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)refreshTopViewWithDate:(NSDate *)date {
    
    [self.dataSource removeAllObjects];
    NSMutableArray *tempArr = [self.viewModel oldNineDaysAndLastFiveDaysAccordingDate:date];
    int i = 0;
    for (NSDateComponents *components in tempArr) {
        YYCalendarTopViewModel *model = [[YYCalendarTopViewModel alloc] init];
        model.weekDay = [self weekDayFromComponents:components];
        model.dateStr = [NSString stringWithFormat:@"%ld",components.day];
        model.date = [NSString stringWithFormat:@"%ld-%0ld-%0ld",components.year,components.month,components.day];
        model.isFuture = [NSDate isFuture:components];
        if ([date isEqualToComponents:components]) {
            
            model.isSelected = YES;
            _selectedIndex = i;
        }else{
            
            model.isSelected = NO;
        }
        i++;
        [self.dataSource addObject:model];
    }
    
//    self.dataSource = tempArr;
    [self.collectionView reloadData];
    
    [self.collectionView setContentOffset:CGPointMake(470-self.collectionView.yy_width/2, 0) animated:NO];
}

- (void)scrollToSelectedIndex:(NSInteger)index {
 
    CGFloat centerx = 20 + 50*index;
    
    if (centerx > self.collectionView.yy_width/2 && centerx < self.collectionView.contentSize.width - self.collectionView.yy_width/2) {//中间徘徊时
        
        [self.collectionView setContentOffset:CGPointMake(centerx-self.collectionView.yy_width/2, 0) animated:YES];
    }else if (centerx <= self.collectionView.yy_width/2) {//处于左侧时
        
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (centerx >= self.collectionView.contentSize.width - self.collectionView.yy_width/2) {//处于右侧时
        
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width - self.collectionView.yy_width, 0) animated:YES];
    }
}

/** 根据weekday转换成中文周几*/
- (NSString *)weekDayFromComponents:(NSDateComponents *)components {
    
    switch (components.weekday) {
        case 1:
            return @"周日";
            break;
        
        case 2:
            return @"周一";
            break;
            
        case 3:
            return @"周二";
            break;
            
        case 4:
            return @"周三";
            break;
            
        case 5:
            return @"周四";
            break;
            
        case 6:
            return @"周五";
            break;
            
        case 7:
            return @"周六";
            break;
        default:
            return @"周六";
            break;
    }
}

#pragma mark -------   collection 代理方法  -------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCalendarTopViewModel *selectedModel = self.dataSource[indexPath.row];
    YYCalendarTopViewModel *lastModel = self.dataSource[_selectedIndex];
    if (selectedModel.isFuture) {
        return;
    }
    if (_selectedIndex == indexPath.row) {
        return;
    }
    
    lastModel.isSelected = NO;
    selectedModel.isSelected = YES;
    NSIndexPath *_selectedIndexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [collectionView reloadItemsAtIndexPaths:@[_selectedIndexPath,indexPath]];
    _selectedIndex = indexPath.row;
    
    [self scrollToSelectedIndex:indexPath.row];
    
    if (_selectedBlock) {
        
        _selectedBlock(selectedModel.date);
    }
}

#pragma mark -------  collectionView 数据源方法  ---------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCalendarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarCollectionCellID forIndexPath:indexPath];
    YYCalendarTopViewModel *model = self.dataSource[indexPath.row];
    cell.weekDayLabel.text = model.weekDay;
    [cell.dateButton setTitle:model.dateStr forState:UIControlStateNormal];
//    [cell.dateButton setTitle:model.dateStr forState:UIControlStateSelected];
    if (model.isSelected) {
        
        cell.dateButton.selected = YES;
        cell.dateButton.backgroundColor = ThemeColor;
    }else {
        cell.dateButton.selected = NO;
        cell.dateButton.backgroundColor = ClearColor;
    }
    cell.dateButton.enabled = !model.isFuture;
    return cell;
    
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 60)];
        _leftImageView.backgroundColor = WhiteColor;
        _leftImageView.contentMode = UIViewContentModeCenter;
        _leftImageView.image = imageNamed(@"yyfw_push_calendararrow_left_20x20_");
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREENWIDTH-20, 0, 20, 60)];
        _rightImageView.backgroundColor = WhiteColor;
        _rightImageView.contentMode = UIViewContentModeCenter;
        _rightImageView.image = imageNamed(@"yyfw_push_calendararrow_right_20x20_");
    }
    return _rightImageView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame), 0, kSCREENWIDTH-CGRectGetWidth(_leftImageView.frame)*2, 60) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YYCalendarCollectionCell class]) bundle:nil]forCellWithReuseIdentifier:CalendarCollectionCellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(40, 60);
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (YYPushViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[YYPushViewModel alloc] init];
    }
    return _viewModel;
}


@end
