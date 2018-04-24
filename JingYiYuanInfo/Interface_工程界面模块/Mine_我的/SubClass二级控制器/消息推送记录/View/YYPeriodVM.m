//
//  YYPeriodVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPeriodVM.h"
#import "YYPeriodCell.h"
#import "YYPeriodModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "UITableView+FDTemplateLayoutCell.h"


@interface YYPeriodVM()

/** 期刊数组*/
@property (nonatomic, strong) NSMutableArray *periodDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYPeriodVM

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void (^)(BOOL))completion {
    
    NSString *act = @"";
    if ([self.classid isEqualToString:@"1"]) {//周刊
        act = @"week";
    }else {//月刊
        act = @"moon";
    }

    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:act,@"act", nil];
    [PPNetworkHelper GET:periodUrl parameters:para responseCache:^(id responseCache) {
        
        if (responseCache && !self.periodDataSource.count) {
            
            self.periodDataSource = [YYPeriodModel mj_objectArrayWithKeyValuesArray:responseCache[@"info"]];
            self.lastid = responseCache[@"lastid"];
            completion(YES);
        }else {
            completion(NO);
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.periodDataSource = [YYPeriodModel mj_objectArrayWithKeyValuesArray:responseObject[@"info"]];
            self.lastid = responseObject[@"lastid"];
            completion(YES);
        }else{
            completion(NO);
        }
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
}


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void (^)(BOOL))completion {
    
    NSString *act = @"";
    if ([self.classid isEqualToString:@"1"]) {//周刊
        act = @"week";
    }else {//月刊
        act = @"moon";
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:act,@"act", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:periodUrl parameters:para success:^(id response) {
        
        if (response) {
            
            self.periodDataSource = [YYPeriodModel mj_objectArrayWithKeyValuesArray:response[@"info"]];
            self.lastid = response[@"lastid"];
            completion(YES);
        }else{
            completion(NO);
        }
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}


#pragma -- mark TableViewDelegate  ---------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.mj_footer.hidden = (self.periodDataSource.count%10 != 0) || self.periodDataSource.count == 0;
    return self.periodDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYLog(@"点击了 %ld 行",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYPeriodModel *periodModel = self.periodDataSource[indexPath.row];
    
    if (_cellSelectBlock) {
        _cellSelectBlock(indexPath, periodModel);
    }
}

#pragma -- mark TableViewDataSource  ---------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYPeriodCell * cell = [tableView dequeueReusableCellWithIdentifier:YYPeriodCellId];
    
    cell.model = self.periodDataSource[indexPath.row];
    
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)periodDataSource{
    if (!_periodDataSource) {
        _periodDataSource = [NSMutableArray array];
    }
    return _periodDataSource;
}


@end
