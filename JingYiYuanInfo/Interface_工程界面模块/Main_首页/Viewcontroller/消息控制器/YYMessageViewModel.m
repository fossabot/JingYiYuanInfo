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
#import "YYMainMessageCell.h"

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


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (UIView *)headerForSection:(NSString *)sectionTitle {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
    backView.backgroundColor = WhiteColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 30)];
    title.text = sectionTitle;
    title.font = SubTitleFont;
    title.textColor = TitleColor;
    
    [backView addSubview:title];
    return backView;
    
}


#pragma -- mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return YYCommonSectionMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YYMessageSectionModel *secModel = self.dataSource[section];
    return [self headerForSection:secModel.date];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYMessageSectionModel *secModel = self.dataSource[section];
    
    return secModel.info.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYMessageSectionModel *secModel = self.dataSource[indexPath.section];
    YYMessageModel *model = secModel.info[indexPath.row];
    if (_cellSelectBlock) {
        _cellSelectBlock(model.webUrl, model.title);
    }
    
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YYMainMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:YYMainMessageCellId];
    YYMessageSectionModel *secModel = self.dataSource[indexPath.section];
    YYMessageModel *model = secModel.info[indexPath.row];
    cell.title.text = model.title;
    
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
