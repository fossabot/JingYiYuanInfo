//
//  YYCommunityQuestionVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYCommunityQuestionVM.h"
#import "YYCommunityQuestionModel.h"
#import "YYQuestionCell.h"

#import <MJExtension/MJExtension.h>
#import "UITableView+FDTemplateLayoutCell.h"

@interface YYCommunityQuestionVM()

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *questionDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYCommunityQuestionVM

- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
#warning  假的userid
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendawz",@"act",@"15000164281kb3bn",USERID, nil];
    
    [PPNetworkHelper GET:communityUrl parameters:para responseCache:^(id responseCache) {
        
        if (responseCache) {
            
            self.questionDataSource = [YYCommunityQuestionModel mj_objectArrayWithKeyValuesArray:responseCache[@"wd_arr"]];
            self.lastid = responseCache[@"lastid"];
            completion(YES);
        }else {
            completion(NO);
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            self.questionDataSource = [YYCommunityQuestionModel mj_objectArrayWithKeyValuesArray:responseObject[@"wd_arr"]];
            self.lastid = responseObject[@"lastid"];
            completion(YES);
        }else {
            completion(NO);
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
#warning  假的userid
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendawz",@"act",@"15000164281kb3bn",USERID,self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            
            self.questionDataSource = [YYCommunityQuestionModel mj_objectArrayWithKeyValuesArray:response[@"wd_arr"]];
            self.lastid = response[@"lastid"];
            completion(YES);
        }else {
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}


#pragma -- mark TableViewDelegate  -----------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYCommunityQuestionModel *model = self.questionDataSource[indexPath.row];
    
    return [tableView fd_heightForCellWithIdentifier:YYQuestionCellId cacheByIndexPath:indexPath configuration:^(YYQuestionCell *cell) {
        
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.niu_img] placeholderImage:imageNamed(@"placeholder")];
        cell.name.text = model.niu_name;
        cell.title.text = model.title;
        cell.question.text = model.desc;
    }];
    
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:YYQuestionCellId];
    YYCommunityQuestionModel *model = self.questionDataSource[indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.niu_img] placeholderImage:imageNamed(@"placeholder")];
    cell.name.text = model.niu_name;
    cell.title.text = model.title;
    cell.question.text = model.desc;
    return cell;
}


@end
