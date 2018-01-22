//
//  YYChannelViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/1.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYChannelViewController.h"
#import "UIView+YYViewInWindow.h"
#import "YYCollectionViewFlowLayout.h"
#import "ChannelCollectionViewCell.h"
#import "ChannelCollectionReusableView.h"

#import "YYMarketViewController.h"     //行情
#import "YYHotListViewController.h"    //热点
#import "YYEntertainmentViewController.h" //娱乐
#import "YYLifeViewController.h"       //生活
#import "YYProductionViewController.h" //产品
//#import "YYAdviserViewController.h"    //投顾
#import "YYBrokerViewController.h"     //券商
#import "YYFundViewController.h"       //基金
#import "YYProjectViewController.h"    //项目

#import "YYThreeSeekController.h"

#import "YYChannel.h"
#import "YYSubtitle.h"
#import "MJExtension.h"


#define itemH 45
#define itemVerticalMargin 5
#define collectionEdgeMargin 15
#define sectionHeader 40

@interface YYChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout*/
@property (nonatomic, strong) YYCollectionViewFlowLayout *flowLayout;

/** datas*/
@property (nonatomic, strong) NSMutableArray<YYChannel *> *datas;

@end

@implementation YYChannelViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubview];
    
    [kNotificationCenter addObserver:self selector:@selector(repeatClickTabbar:) name:YYTabbarItemDidRepeatClickNotification object:nil];

}


- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:YYTabbarItemDidRepeatClickNotification object:nil];

}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  配置子控件
 */
- (void)configSubview {
    
    [self.view addSubview:self.collectionView];
    
}



#pragma mark -- 双击tab的通知方法

/** 两次点击maincontroller*/
- (void)repeatClickTabbar:(NSNotification *)notice {
    
    if (self.view.window == nil) return;
    if (![self.view yy_intersectsWithAnotherView:nil]) return;
    
    //滚动到顶部
    [self.collectionView scrollsToTop];
    
}

- (void)selectedIndexPathSection:(NSInteger)section row:(NSInteger)row {
    
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:{
            //行情 热点 娱乐 生活
            YYMarketViewController *market = [[YYMarketViewController alloc] init];
            YYChannel *channel = self.datas[section];
            market.datas = channel.subtitles;
            market.fatherId = channel.fatherId;
            market.defaultSelectedControllerIndex = row;
            market.title = channel.title;
            market.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:market animated:YES];
        }
            break;
        
//        case 1:{
//            //热点
//            YYHotListViewController *hotList = [[YYHotListViewController alloc] init];
//            YYChannel *channel = self.datas[section];
//            hotList.datas = channel.subtitles;
//            hotList.selectedControllerIndex = row;
//            [self.navigationController pushViewController:hotList animated:YES];
//        }
//            break;
//            
//        case 2:{
//            //娱乐
//            YYEntertainmentViewController *entertainment = [[YYEntertainmentViewController alloc] init];
//            YYChannel *channel = self.datas[section];
//            entertainment.datas = channel.subtitles;
//            entertainment.selectedControllerIndex = row;
//            [self.navigationController pushViewController:entertainment animated:YES];
//        }
//            break;
//            
//        case 3:{
//            //生活
//            YYLifeViewController *life = [[YYLifeViewController alloc] init];
//            YYChannel *channel = self.datas[section];
//            life.datas = channel.subtitles;
//            life.selectedControllerIndex = row;
//            [self.navigationController pushViewController:life animated:YES];
//        }
//            break;
            
        case 4:{
            //产品
            YYProductionViewController *production = [[YYProductionViewController alloc] init];
            YYChannel *channel = self.datas[section];
            production.datas = channel.subtitles;
            production.fatherId = channel.fatherId;
            production.defaultSelectedControllerIndex = row;
            production.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:production animated:YES];
        }
            break;
            
        case 5:{
            //项目
            YYProjectViewController *project = [[YYProjectViewController alloc] init];
            YYChannel *channel = self.datas[section];
            project.datas = channel.subtitles;
            project.fatherId = channel.fatherId;
            project.defaultSelectedControllerIndex = row;
            project.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:project animated:YES];
        }
            break;
            
        case 6:
        case 7:
        case 8:{
            //投顾、券商、基金
            YYThreeSeekController *threeVc = [[YYThreeSeekController alloc] init];
            YYChannel *channel = self.datas[section];
            threeVc.datas = channel.subtitles;
            threeVc.title = channel.title;
            threeVc.fatherId = channel.fatherId;
            threeVc.defaultSelectedControllerIndex = row;
            threeVc.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:threeVc animated:YES];
        }
            break;
            
//        case 7:{
//            //券商
//            YYBrokerViewController *broker = [[YYBrokerViewController alloc] init];
//            YYChannel *channel = self.datas[section];
//            broker.datas = channel.subtitles;
//            broker.selectedControllerIndex = row;
//            broker.jz_wantsNavigationBarVisible = YES;
//            [self.navigationController pushViewController:broker animated:YES];
//        }
//            break;
//            
//        case 8:{
//            //基金
//            YYFundViewController *fund = [[YYFundViewController alloc] init];
//            YYChannel *channel = self.datas[section];
//            fund.datas = channel.subtitles;
//            fund.selectedControllerIndex = row;
//            fund.jz_wantsNavigationBarVisible = YES;
//            [self.navigationController pushViewController:fund animated:YES];
//        }
//            break;
            
        default:
            
            break;
    }
    
}


#pragma mark -- collectionView 代理方法  ---------------------------------------

/** 点击了相应的item*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (indexPath.section >= 5) {
        row = row+1;
    }
    [self selectedIndexPathSection:indexPath.section row:row];
    YYLog(@"选中了section : %ld row : %ld",indexPath.section,indexPath.row);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(0, 60);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, collectionEdgeMargin, collectionEdgeMargin, collectionEdgeMargin);
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section {
    return [UIColor whiteColor];
}


#pragma mark -- collectionView 数据源方法  -------------------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas[section].subtitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.titleLabel.text = self.datas[indexPath.section].subtitles[indexPath.row].title;
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ChannelCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    YYChannel *channel = self.datas[indexPath.section];
    reusableView.icon.image = imageNamed(channel.icon);
    reusableView.titleLabel.text = channel.title;
    YYWeakSelf
    reusableView.moreBlock = ^{
        
        YYStrongSelf
        [strongSelf selectedIndexPathSection:indexPath.section row:0];
        
    };
    return reusableView;
}



#pragma mark -- lazyMethods 懒加载区域  ----------------------------------------

- (NSMutableArray *)datas{
    if (!_datas) {
        
        self.datas = [YYChannel mj_objectArrayWithFilename:@"Channel.plist"];
        YYChannel *channel = self.datas[0];
        YYSubtitle *subtitle = channel.subtitles[0];
        YYLog(@"datas : %@   %ld",channel.title,(long)subtitle.classid);
    }
    return _datas;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, YYTabBarH+20, 0);
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = YYRGB(238, 239, 240);
        _collectionView.backgroundView = bgView;

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}


- (YYCollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        
        _flowLayout = [[YYCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = itemVerticalMargin;
        _flowLayout.minimumLineSpacing = itemVerticalMargin;
        CGFloat wid = self.collectionView.bounds.size.width - 2*(itemVerticalMargin + collectionEdgeMargin)-10;
        _flowLayout.itemSize = CGSizeMake(wid/3, itemH);

    }
    return _flowLayout;
}


@end
