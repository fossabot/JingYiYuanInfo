//
//  YYProdutionVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYProductionVM.h"
#import "YYProductionListModel.h"
#import "YYCompanyListModel.h"
#import "YYProductionCommonModel.h"
#import "YYProductionVIPModel.h"
#import "YYCompanyModel.h"

#import "YYCompanyCell.h"
#import "YYProductionCell.h"

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface YYProductionVM()

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *normalDataSource;

/** vipModel*/
@property (nonatomic, strong) YYProductionVIPModel *vipModel;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYProductionVM


#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self act],@"act", nil];
    
    [PPNetworkHelper GET:[self requestUrl] parameters:para responseCache:^(id responseCache) {
        
        if (responseCache && !self.normalDataSource.count) {
           
            [self dispatchResponse:responseCache];
            
            completion(YES);
        }else {
            
            completion(NO);
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            [self dispatchResponse:responseObject];
            completion(YES);
        }else {
            [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            [SVProgressHUD dismissWithDelay:1];
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
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self actMore],@"act", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:[self requestUrl] parameters:para success:^(id response) {
        
        if (response) {
            
            [self dispatchMoreResponse:response];
            completion(YES);
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"暂无更多数据"];
            [SVProgressHUD dismissWithDelay:1];
            completion(NO);
        }
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
}



#pragma -- mark TableViewDelegate  --------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.classid isEqualToString:@"1"]) {//产品列表
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.classid isEqualToString:@"1"]) {//产品列表
        if (section == 0) {
            return 1;
        }
    }
    tableView.mj_footer.hidden = (self.normalDataSource.count%10 != 0) || self.normalDataSource.count == 0;
    return self.normalDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return YYCommonSectionMargin;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_classid isEqualToString:@"1"]) {
        return 110;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (_productionSelectBlock) {
        
        if ([self.classid isEqualToString:@"1"]) {//产品列表
            
            if (indexPath.section == 0) {
                
                _productionSelectBlock(YYProductionTypeVIP, indexPath, self.vipModel);
            }else{
                
                YYProductionCommonModel *productionModel = self.normalDataSource[indexPath.row];
                _productionSelectBlock(YYProductionTypeNormal, indexPath, productionModel);
            }
            
        }else {//公司列表
            
            YYCompanyModel *companyModel = self.normalDataSource[indexPath.row];
            _productionSelectBlock(YYProductionTypeCompany, indexPath, companyModel);
        }
    }
    
}

#pragma -- mark TableViewDataSource  ----------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.classid isEqualToString:@"1"]) {//产品列表
        YYProductionCell *productionCell = [tableView dequeueReusableCellWithIdentifier:YYProductionCellId];
        
        if (indexPath.section == 0) {
            
            [productionCell setVipModel:self.vipModel];
        }else{
            
            YYProductionCommonModel *productionModel = self.normalDataSource[indexPath.row];
            [productionCell setCommonModel:productionModel];
        }
        return productionCell;
    }else {//公司列表
        YYCompanyCell *companyCell = [tableView dequeueReusableCellWithIdentifier:YYCompanyCellId];
        YYCompanyModel *companyModel = self.normalDataSource[indexPath.row];
        [companyCell setCompanyModel:companyModel];
        return companyCell;
    }
    
}



#pragma mark -------   辅助方法  -------------------

/** 分发返回的json，填充到合适的数组或模型*/
- (void)dispatchResponse:(id)response {
    
    if ([self.classid isEqualToString:@"1"]) {
        
        YYProductionListModel *proListModel = [YYProductionListModel mj_objectWithKeyValues:response];
#warning 这个版本不打开  下个版本再上线产品
        self.normalDataSource = (NSMutableArray *)proListModel.pro_arr;
        self.vipModel = proListModel.vip;
        self.lastid = proListModel.lastid;
    }else {
        
        YYCompanyListModel *companyListModel = [YYCompanyListModel mj_objectWithKeyValues:response];
        self.normalDataSource = (NSMutableArray *)companyListModel.com_arr;
        self.lastid = companyListModel.lastid;
    }
}

/** 分发返回的json，追加到合适的数组或模型*/
- (void)dispatchMoreResponse:(id)response {
    
    if ([self.classid isEqualToString:@"1"]) {
        
        YYProductionListModel *proListModel = [YYProductionListModel mj_objectWithKeyValues:response];
        [self.normalDataSource addObjectsFromArray:proListModel.pro_arr];
        self.lastid = proListModel.lastid;
    }else {
        
        YYCompanyListModel *companyListModel = [YYCompanyListModel mj_objectWithKeyValues:response];
        [self.normalDataSource addObjectsFromArray:companyListModel.com_arr];
        self.lastid = companyListModel.lastid;
    }
    
}

/** 请求数据的act参数*/
- (NSString *)act {
    if ([_classid isEqualToString:@"1"]) {//产品分类
        
        return @"product";
    }else {//公司分类
        
        return @"company";
    }
}

/** 请求的地址*/
- (NSString *)requestUrl {
    
    if ([_classid isEqualToString:@"1"]) {//产品分类
        
        return newProductionUrl;
    }else {//公司分类
        
        return channelProductionUrl;
    }
}

/** 请求更多数据的act参数*/
- (NSString *)actMore {
    if ([_classid isEqualToString:@"1"]) {//产品分类
        
        return @"promore";
    }else {//公司分类
        
        return @"commore";
    }
}

- (NSMutableArray *)normalDataSource {
    
    if (!_normalDataSource) {
        _normalDataSource = [NSMutableArray array];
    }
    return _normalDataSource;
}

@end
