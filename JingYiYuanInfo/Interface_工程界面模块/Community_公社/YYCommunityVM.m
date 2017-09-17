//
//  YYCommunityVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/7.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityVM.h"

#import "YYNiuModel.h"
#import "YYNiuArticleModel.h"
#import "YYCommunityBannerModel.h"

#import "YYNiuManCell.h"
#import "YYNiuArticleCell.h"

#import <MJExtension/MJExtension.h>

@interface YYCommunityVM()

/** 牛人数据源*/
@property (nonatomic, strong) NSMutableArray *niuManDataSource;

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *niuArtDataSource;



@end

@implementation YYCommunityVM


#pragma mark -------  banner 代理方法 -------------------------------------

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    YYCommunityBannerModel *model = self.niuBannerDataSource[index];
    if (_bannerSelectedBlock) {
        _bannerSelectedBlock(model.imgUrl, model.link);
    }
}

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    NSDictionary *bannerPara = [NSDictionary dictionaryWithObjectsAndKeys:@"rollpic", @"act", nil];
    [PPNetworkHelper GET:communityUrl parameters:bannerPara responseCache:^(id responseCache) {//{"lb_arr":[ ]}
        
        if (!self.niuBannerDataSource.count) {
            self.niuBannerDataSource = [YYCommunityBannerModel mj_objectArrayWithKeyValuesArray:responseCache[@"lb_arr"]];
            completion(YES);
        }
        
    } success:^(id responseObject) {
        
            self.niuBannerDataSource = [YYCommunityBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"lb_arr"]];
            completion(YES);
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
    
    [PPNetworkHelper GET:niunewsdefaultUrl parameters:nil responseCache:^(id responseCache) {
        
        if (!self.niuManDataSource.count && !self.niuArtDataSource.count) {
            YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseCache];
            self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
            self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
            self.lastid = niuModel.lastid;
            completion(YES);
        }
        
    } success:^(id responseObject) {
        
        YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseObject];
        if (niuModel.niu_arr.count || niuModel.niuart_arr.count) {
            [self.niuManDataSource removeAllObjects];
            [self.niuArtDataSource removeAllObjects];
        }
        self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
        self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
        self.lastid = niuModel.lastid;
        
        completion(YES);
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"loadmoreniu",@"act",self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:niunewsmoreUrl parameters:para success:^(id response) {
        
        YYNiuModel *model = [YYNiuModel mj_objectWithKeyValues:response];
        [self.niuArtDataSource addObjectsFromArray:model.niuart_arr];
        self.lastid = model.lastid;
        completion(YES);
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}


/**
 *  查看更多牛人
 */
- (void)more {
    
    if (_niuManListBlock) {
        _niuManListBlock();
    }
}


#pragma mark -------  tableview  代理方法 ---------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 110;
    }else {
        return 100;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 10, 3, 20)];
        redview.backgroundColor = ThemeColor;
        [view addSubview:redview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 70, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"为你推荐";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SubTitleFont;
        label.textColor = SubTitleColor;
        [view addSubview:label];
        
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        more.frame = CGRectMake(kSCREENWIDTH-100, 20, 90, 20);
        [more setTitle:@"查看更多" forState:UIControlStateNormal];
        [more setImage:imageNamed(@"more") forState:UIControlStateNormal];
        [more setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        [more setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -20)];
        [more setTitleColor:SubTitleColor forState:UIControlStateNormal];
        more.titleLabel.font = SubTitleFont;
        [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:more];
        
        return view;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 10, 3, 20)];
        redview.backgroundColor = ThemeColor;
        [view addSubview:redview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"牛人观点推荐";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SubTitleFont;
        label.textColor = SubTitleColor;
        [view addSubview:label];
        return view;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.niuManDataSource.count;
            break;
            
        default:
            return self.niuArtDataSource.count;
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellSelectedBlock) {
        if (indexPath.section == 0) {
            
            YYNiuManCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            _cellSelectedBlock(cell, indexPath);
        }else {
            
            YYNiuArticleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            _cellSelectedBlock(cell, indexPath);
        }
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YYNiuManCell *niuManCell = [tableView dequeueReusableCellWithIdentifier:YYNiuManCellID];
        [niuManCell setNiuManModel:self.niuManDataSource[indexPath.row] andIndex:indexPath.row];
        return niuManCell;
    }else {
        
        YYNiuArticleCell *niuArtCell = [tableView dequeueReusableCellWithIdentifier:YYNiuArticleCellID];
        niuArtCell.niuArtModel = self.niuArtDataSource[indexPath.row];
        return niuArtCell;
    
    }
    
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)niuBannerDataSource{
    if (!_niuBannerDataSource) {
        _niuBannerDataSource = [NSMutableArray array];
    }
    return _niuBannerDataSource;
}

- (NSMutableArray *)niuManDataSource{
    if (!_niuManDataSource) {
        _niuManDataSource = [NSMutableArray array];
    }
    return _niuManDataSource;
}

- (NSMutableArray *)niuArtDataSource{
    if (!_niuArtDataSource) {
        _niuArtDataSource = [NSMutableArray array];
    }
    return _niuArtDataSource;
}


@end
