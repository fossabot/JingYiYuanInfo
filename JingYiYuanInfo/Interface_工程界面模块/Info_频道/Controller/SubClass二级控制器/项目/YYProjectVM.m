//
//  YYProjectVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProjectVM.h"
#import "YYProjectModel.h"
#import "YYProjectListModel.h"
#import "YYProjectCell.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYProjectVM()

/** recommendDataSource*/
@property (nonatomic, strong) NSMutableArray *recommendDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYProjectVM

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = nil;
    if ([self.classid isEqualToString:@"0"]) {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"xiangmu",@"act", nil];
    }else {
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"other",@"act",self.classid,@"keyword", nil];
    }
    
    [PPNetworkHelper GET:projectUrl parameters:para responseCache:^(id responseCache) {
        if (responseCache) {
            
            YYProjectListModel *listModel = [YYProjectListModel mj_objectWithKeyValues:responseCache];
            self.recommendDataSource = (NSMutableArray *)listModel.recommend;
            self.lastid = listModel.lastid;
            completion(YES);
        }else {
            completion(NO);
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            YYProjectListModel *listModel = [YYProjectListModel mj_objectWithKeyValues:responseObject];
            self.recommendDataSource = (NSMutableArray *)listModel.recommend;
            self.lastid = listModel.lastid;
            completion(YES);
        }else {
            completion(NO);
        }
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
}


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = nil;
    if ([self.classid isEqualToString:@"0"]) {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"moretj",@"act",self.lastid,@"lastid", nil];
    }else {
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"moreother",@"act",self.classid,@"keyword",self.lastid,@"lastid", nil];
    }
    
    [YYHttpNetworkTool GETRequestWithUrlstring:projectUrl parameters:para success:^(id response) {
        
        if (response) {
            
            YYProjectListModel *listModel = [YYProjectListModel mj_objectWithKeyValues:response];
            [self.recommendDataSource addObjectsFromArray:listModel.recommend];
            self.lastid = listModel.lastid;
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
    tableView.mj_footer.hidden = (self.recommendDataSource.count%10 != 0) || self.recommendDataSource.count == 0;
    return self.recommendDataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYLog(@"点击了 %ld 行",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYProjectModel *projectModel = self.recommendDataSource[indexPath.row];
    
    if (_cellSelectBlock) {
        _cellSelectBlock(indexPath, projectModel);
    }
    
}


#pragma -- mark TableViewDataSource  ---------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:YYProjectCellId];
    
    [cell setProjectModel:self.recommendDataSource[indexPath.row]];
    return cell;
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)recommendDataSource{
    if (!_recommendDataSource) {
        _recommendDataSource = [NSMutableArray array];
    }
    return _recommendDataSource;
}



@end
