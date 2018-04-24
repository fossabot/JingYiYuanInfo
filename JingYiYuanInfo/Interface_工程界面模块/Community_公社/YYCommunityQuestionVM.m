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
#import "YYUser.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#import "UITableView+FDTemplateLayoutCell.h"

@interface YYCommunityQuestionVM()

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *questionDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYCommunityQuestionVM

- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendawz",@"act",user.userid,USERID, nil];
    
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
        completion(NO);
    }];
    
}

- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    

    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"wendawz",@"act",user.userid,USERID,self.lastid,@"lastid", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:communityUrl parameters:para success:^(id response) {
        
        if (response) {
            
            [self.questionDataSource addObjectsFromArray:[YYCommunityQuestionModel mj_objectArrayWithKeyValuesArray:response[@"wd_arr"]]];
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
    
    tableView.mj_footer.hidden = (self.questionDataSource.count%10 != 0 || self.questionDataSource.count == 0);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYCommunityQuestionModel *model = self.questionDataSource[indexPath.row];
    if (_cellSelectedBlock) {
        _cellSelectedBlock(model,indexPath);
    }
}

#pragma -- mark TableViewDataSource  --------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:YYQuestionCellId];
    YYCommunityQuestionModel *model = self.questionDataSource[indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.niu_img] placeholderImage:imageNamed(@"placeholder")];
    cell.name.text = model.niu_name;
    cell.title.text = model.title;
    cell.question.text = model.desc;
    
    //  隐藏每个分区最后一个cell的分割线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        // 1.系统分割线,移到屏幕外
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        
        // 2.自定义Cell
        cell.bottomView.hidden = YES;
    }
    else
    {
//        cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0)
        cell.bottomView.hidden = NO;
    }
    return cell;
}


@end
