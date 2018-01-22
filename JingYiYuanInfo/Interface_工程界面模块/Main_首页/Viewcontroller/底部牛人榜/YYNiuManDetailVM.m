//
//  YYNiuManDetailVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManDetailVM.h"
#import "YYNiuArticleModel.h"

#import "YYNiuArticleCell.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYNiuManDetailVM()

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *niuArtDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYNiuManDetailVM


#pragma mark -- network   数据请求方法  ---------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niuarticle",@"act",self.niuid,@"niuid", nil];
    //牛人列表接口
    [PPNetworkHelper GET:niunewsdefaultUrl parameters:para responseCache:^(id responseCache) {
        
        if (!self.niuArtDataSource.count) {
            
            self.niuArtDataSource = [YYNiuArticleModel mj_objectArrayWithKeyValuesArray:responseCache[@"niu_arr"]];
            self.lastid = responseCache[LASTID];
            completion(YES);
        }else{
            completion(NO);
        }
        
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.niuArtDataSource = [YYNiuArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"niu_arr"]];
            self.lastid = responseObject[LASTID];
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    }];
    
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niuarticle",@"act",self.lastid,@"lastid",self.niuid,@"niuid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:niunewsdefaultUrl parameters:para success:^(id response) {
        
        if (response) {
            
            [self.niuArtDataSource addObjectsFromArray:[YYNiuArticleModel mj_objectArrayWithKeyValuesArray:response[@"niu_arr"]]];
            self.lastid = response[LASTID];
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}


#pragma mark -------  tableview  代理方法 ---------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 107;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    tableView.mj_footer.hidden = (self.niuArtDataSource.count%10 != 0);
    return self.niuArtDataSource.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellSelectedBlock) {
       
        YYNiuArticleModel *articleModel = self.niuArtDataSource[indexPath.row];
        _cellSelectedBlock(articleModel, indexPath);
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYNiuArticleCell *niuArtCell = [tableView dequeueReusableCellWithIdentifier:YYNiuArticleCellID];
    niuArtCell.niuArtModel = self.niuArtDataSource[indexPath.row];
    return niuArtCell;
        
}


- (NSMutableArray *)niuArtDataSource{
    if (!_niuArtDataSource) {
        _niuArtDataSource = [NSMutableArray array];
    }
    return _niuArtDataSource;
}

@end
