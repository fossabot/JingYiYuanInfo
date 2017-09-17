//
//  YYMessageViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/9/5.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMessageViewModel.h"
#import "YYMessageModel.h"
#import "YYMessageSectionModel.h"
//#import "YYMainMessageCell.h"

#import <MJExtension/MJExtension.h>

@interface YYMessageViewModel()

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYMessageViewModel


/**
 *  刷新数据
 */
- (void)loadNewDataCompletion:(void(^)(BOOL success))completion {
    
    
    //"info":[{"id":"2","title":"壹元服务改版升级啦！","addtime":"2017-04-08 21:57:50"}]
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"list",@"act", nil];
    [PPNetworkHelper GET:messagesUrl parameters:para responseCache:^(id responseCache) {
        if (!self.dataSource.count) {
            
            self.dataSource = [YYMessageSectionModel mj_objectArrayWithKeyValuesArray:responseCache];
            if (completion) {
                completion(YES);
            }
        }
    } success:^(id responseObject) {
        
        self.dataSource = [YYMessageSectionModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error) {
        
        if (completion) {
            completion(NO);
        }
    }];

}

/**
 *  加载更多数据
 */
- (void)loadMoreDataCompletion:(void(^)(BOOL success))completion {

}


#pragma -- mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYMessageSectionModel *secModel = self.dataSource[section];
    
    return secModel.info.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YYMessageSectionModel *secModel = self.dataSource[section];
    return secModel.date;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYMessageModel *model = self.dataSource[indexPath.row];
    if (_cellSelectBlock) {
        _cellSelectBlock(model.msgId, model.title);
    }
    
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    YYMessageSectionModel *secModel = self.dataSource[indexPath.section];
    YYMessageModel *model = secModel.info[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
