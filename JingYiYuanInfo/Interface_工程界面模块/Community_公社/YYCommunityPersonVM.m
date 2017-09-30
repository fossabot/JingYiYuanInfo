//
//  YYCommunityPersonVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityPersonVM.h"
#import "YYNiuModel.h"
#import "YYNiuArticleModel.h"
#import "YYPersonBannerModel.h"

#import "YYNiuArticleCell.h"
#import "YYNiuManCell.h"

#import <MJExtension/MJExtension.h>


@interface YYCommunityPersonVM()

/** 牛人数据源*/
@property (nonatomic, strong) NSMutableArray *niuManDataSource;

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *niuArtDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYCommunityPersonVM



#pragma mark -------  banner 代理方法 -------------------------------------

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    YYPersonBannerModel *model = self.niuBannerDataSource[index];
    if (_bannerSelectedBlock) {
        _bannerSelectedBlock(model.picurl, model.piclink);
    }
}

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    //banner接口
    NSDictionary *bannerPara = [NSDictionary dictionaryWithObjectsAndKeys:@"rollpic", @"act", nil];
    [PPNetworkHelper GET:communityUrl parameters:bannerPara responseCache:^(id responseCache) {//{"lb_arr":[ ]}
        
        if (!self.niuBannerDataSource.count && responseCache) {
            self.niuBannerDataSource = [YYPersonBannerModel mj_objectArrayWithKeyValuesArray:responseCache[@"lb_arr"]];
            completion(YES);
        }else{
            completion(NO);
        }
        
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.niuBannerDataSource = [YYPersonBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"lb_arr"]];
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
    
    //牛人列表接口
    [PPNetworkHelper GET:niunewsdefaultUrl parameters:nil responseCache:^(id responseCache) {
        
        if (!self.niuManDataSource.count && !self.niuArtDataSource.count) {
            YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseCache];
            self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
            self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
            self.lastid = niuModel.lastid;
            completion(YES);
        }else{
            completion(NO);
        }
        
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            YYNiuModel *niuModel = [YYNiuModel mj_objectWithKeyValues:responseObject];
            if (niuModel.niu_arr.count || niuModel.niuart_arr.count) {
                [self.niuManDataSource removeAllObjects];
                [self.niuArtDataSource removeAllObjects];
            }
            self.niuManDataSource = (NSMutableArray *)niuModel.niu_arr;
            self.niuArtDataSource = (NSMutableArray *)niuModel.niuart_arr;
            self.lastid = niuModel.lastid;
            
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"loadmoreniu",@"act",self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:niunewsmoreUrl parameters:para success:^(id response) {
        
        if (response) {
            
            YYNiuModel *model = [YYNiuModel mj_objectWithKeyValues:response];
            [self.niuArtDataSource addObjectsFromArray:model.niuart_arr];
            self.lastid = model.lastid;
            completion(YES);
        }else {
            completion(NO);
        }
        
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
        return 107;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self sectionHeaderForSection:section];
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
            
            YYNiuManModel *niumanModel = self.niuManDataSource[indexPath.row];
            _cellSelectedBlock(niumanModel, indexPath);
        }else {
            
            YYNiuArticleModel *articleModel = self.niuArtDataSource[indexPath.row];
            _cellSelectedBlock(articleModel, indexPath);
        }
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YYNiuManCell *niuManCell = [tableView dequeueReusableCellWithIdentifier:YYNiuManCellID];
        [niuManCell setNiuManModel:self.niuManDataSource[indexPath.row]];
        return niuManCell;
    }else {
        
        YYNiuArticleCell *niuArtCell = [tableView dequeueReusableCellWithIdentifier:YYNiuArticleCellID];
        niuArtCell.niuArtModel = self.niuArtDataSource[indexPath.row];
        return niuArtCell;
        
    }
    
}





#pragma mark -------  辅助方法  -----------


- (UIView *)sectionHeaderForSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 10, 3, 20)];
    redview.backgroundColor = ThemeColor;
    [view addSubview:redview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @[@"牛人推荐",@"牛人观点推荐"][section];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = SubTitleFont;
    label.textColor = SubTitleColor;
    [view addSubview:label];
    
    if (section == 0) {
        
        UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
        more.frame = CGRectMake(kSCREENWIDTH-70, 10, 70, 20);
        [more setTitle:@"查看更多" forState:UIControlStateNormal];
        [more setImage:imageNamed(@"more") forState:UIControlStateNormal];
        [more setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 20)];
        [more setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -20)];
        [more setTitleColor:SubTitleColor forState:UIControlStateNormal];
        more.titleLabel.font = SubTitleFont;
        [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:more];
    }
    
    return view;
    
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
