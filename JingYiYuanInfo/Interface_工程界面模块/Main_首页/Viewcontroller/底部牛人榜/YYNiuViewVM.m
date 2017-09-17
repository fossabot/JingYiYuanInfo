//
//  YYNiuViewVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuViewVM.h"
#import "YYNiuModel.h"
#import <MJExtension/MJExtension.h>

#import "YYNiuArticleModel.h"
#import "YYNiuManModel.h"

#import "YYNiuManCell.h"
#import "YYNiuArticleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface YYNiuViewVM()

/** 牛人数据源*/
@property (nonatomic, strong) NSMutableArray *niuManDataSource;

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *niuArtDataSource;

@end

@implementation YYNiuViewVM

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
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

/**
 *  加载更多数据
 */
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

#pragma mark -------  tableview  代理方法 ---------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNiuManCellID cacheByIndexPath:indexPath configuration:^(YYNiuManCell *cell) {
                [cell setNiuManModel:self.niuManDataSource[indexPath.row] andIndex:indexPath.row];
            }];
            return height;
        }
            
            break;
            
        default:
        {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNiuArticleCellID cacheByIndexPath:indexPath configuration:^(YYNiuArticleCell *cell) {
                cell.niuArtModel = self.niuArtDataSource[indexPath.row];
            }];
            return height;
        }
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 13, 3, 14)];
        redview.backgroundColor = ThemeColor;
        [view addSubview:redview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 70, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"为你推荐";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SubTitleFont;
        label.textColor = SubTitleColor;
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 30;
            break;
            
        default:
            return 0.1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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
    if (_selectedBlock) {
        if (indexPath.section == 0) {
            
//            YYNiuManCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            YYNiuManModel *niuManModel = self.niuManDataSource[indexPath.row];
            _selectedBlock(nil, indexPath);
        }else {
            
//            YYNiuArticleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            YYNiuArticleModel *articleModel = self.niuArtDataSource[indexPath.row];
            _selectedBlock([NSString stringWithFormat:@"%@%@",niuWebJointUrl,articleModel.art_id], indexPath);
        }
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            YYNiuManCell *niuManCell = [tableView dequeueReusableCellWithIdentifier:YYNiuManCellID];
            [niuManCell setNiuManModel:self.niuManDataSource[indexPath.row] andIndex:indexPath.row];
            return niuManCell;
        }
            break;
            
        case 1:{
            YYNiuArticleCell *niuArtCell = [tableView dequeueReusableCellWithIdentifier:YYNiuArticleCellID];
            niuArtCell.niuArtModel = self.niuArtDataSource[indexPath.row];
            return niuArtCell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYMainVCLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
    }
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

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
