//
//  YYNiuMoreVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/29.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuMoreVM.h"

#import "YYNiuManModel.h"
#import "YYNiuManCell.h"

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYNiuMoreVM()

/** 牛人数据源*/
@property (nonatomic, strong) NSMutableArray *niuManDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end


@implementation YYNiuMoreVM



#pragma mark -- network   数据请求方法  ---------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niumore",@"act", nil];
    //牛人列表接口
    [PPNetworkHelper GET:communityUrl parameters:para responseCache:^(id responseCache) {
        
        if (!self.niuManDataSource.count) {
            self.niuManDataSource = [YYNiuManModel mj_objectArrayWithKeyValuesArray:responseCache[@"niu_arr"]];
            self.lastid = responseCache[LASTID];
            
            completion(YES);
        }else{
            completion(NO);
        }
        
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.niuManDataSource = [YYNiuManModel mj_objectArrayWithKeyValuesArray:responseObject[@"niu_arr"]];
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
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niumore",@"act",self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            
            [self.niuManDataSource addObjectsFromArray:[YYNiuManModel mj_objectArrayWithKeyValuesArray:response[@"niu_arr"]]];
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
    
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 隐藏尾部刷新控件
    tableView.mj_footer.hidden = (self.niuManDataSource.count%10 != 0);
    return self.niuManDataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellSelectedBlock) {
        
        YYNiuManModel *niumanModel = self.niuManDataSource[indexPath.row];
        _cellSelectedBlock(niumanModel, indexPath);
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYNiuManCell *niuManCell = [tableView dequeueReusableCellWithIdentifier:YYNiuManCellID];
    [niuManCell setNiuManModel:self.niuManDataSource[indexPath.row]];
    return niuManCell;
    
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)niuManDataSource{
    if (!_niuManDataSource) {
        _niuManDataSource = [NSMutableArray array];
    }
    return _niuManDataSource;
}

@end
