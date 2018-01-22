//
//  YYThreeSeekVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYThreeSeekVM.h"
#import "YYCompanyModel.h"
#import "YYCompanyCell.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#import "UITableView+FDTemplateLayoutCell.h"
#import "YYThreeSeekListModel.h"


@interface YYThreeSeekVM()

/** 推荐数组*/
@property (nonatomic, strong) NSMutableArray *recommendDataSource;

/** 公司列表*/
@property (nonatomic, strong) NSMutableArray *companyDataSource;

/** paraDic*/
@property (nonatomic, strong) NSMutableDictionary *paraDic;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYThreeSeekVM

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataForThreeSeek:(NSInteger)fatherId completion:(void (^)(BOOL))completion {
    
    
    NSString *url = [self seekUrl:fatherId];
    NSDictionary *para = [self para:fatherId classid:self.classid];
    [PPNetworkHelper GET:url parameters:para responseCache:^(id responseCache) {
        
        if (responseCache && !self.companyDataSource.count) {
            
            YYThreeSeekListModel *threeSeekListModel = [YYThreeSeekListModel mj_objectWithKeyValues:responseCache];
            self.recommendDataSource = threeSeekListModel.recommend;
            self.companyDataSource = threeSeekListModel.other;
            self.lastid = threeSeekListModel.lastid;
            completion(YES);
        }
    } success:^(id responseObject) {
        
        if (responseObject) {
            
            YYThreeSeekListModel *threeSeekListModel = [YYThreeSeekListModel mj_objectWithKeyValues:responseObject];
            self.recommendDataSource = threeSeekListModel.recommend;
            self.companyDataSource = threeSeekListModel.other;
            self.lastid = threeSeekListModel.lastid;
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
- (void)fetchMoreDataForThreeSeek:(NSInteger)fatherId completion:(void (^)(BOOL))completion {
    
    NSString *url = [self seekUrl:fatherId];
    NSDictionary *para = [self paraMore:fatherId classid:self.classid];
    [YYHttpNetworkTool GETRequestWithUrlstring:url parameters:para success:^(id response) {
        
        if (response) {
            
            YYThreeSeekListModel *threeSeekListModel = [YYThreeSeekListModel mj_objectWithKeyValues:response];
            [self.recommendDataSource addObjectsFromArray:threeSeekListModel.recommend];
            [self.companyDataSource addObjectsFromArray:threeSeekListModel.other];
            self.lastid = threeSeekListModel.lastid;
            completion(YES);
        }else {
            completion(NO);
        }
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
    
}

/**
 *  换一批推荐数据
 */
- (void)fetchNewRecommendDataForThreeSeek:(NSInteger)fatherId completion:(void (^)(BOOL success))completion {

    //fatherId 6/投顾  7/券商  8/基金
    [YYHttpNetworkTool GETRequestWithUrlstring:[self seekUrl:fatherId] parameters:[self recommendChange:fatherId] success:^(id response) {
        
        if (response) {
            
            self.recommendDataSource = [YYCompanyModel mj_objectArrayWithKeyValuesArray:response[@"recommend"]];
            completion(YES);
        }else {
            completion(NO);
        }
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
}


/** 换一批推荐数据*/
- (void)changeRecommend:(UIButton *)sender {
    
    YYWeakSelf
    [self fetchNewRecommendDataForThreeSeek:_fatherId completion:^(BOOL success) {
        
        if (success) {
            if (weakSelf.changeBlock) {//回调去刷新推荐数据的section
                
                weakSelf.changeBlock();
            }
        }
    }];
}



#pragma -- mark TableViewDelegate  ---------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.classid isEqualToString:@"0"]) {
        return 40;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([self.classid isEqualToString:@"0"]) {
        return 5;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self.classid isEqualToString:@"0"]) {
        
        return [self sectionHeaderForSection:section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.classid isEqualToString:@"0"]) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.classid isEqualToString:@"0"] && section == 0) {
        
        return self.recommendDataSource.count;
    }
    
//    tableView.mj_footer.hidden = (self.companyDataSource.count%10 != 0);
    return self.companyDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 90;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYLog(@"点击了 %ld 行",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYCompanyModel *companyModel = nil;
    if ([self.classid isEqualToString:@"0"] && indexPath.section == 0) {
        
        companyModel = self.recommendDataSource[indexPath.row];
    }else {
        companyModel = self.companyDataSource[indexPath.row];
    }
    
    if (_cellSelectBlock) {
        _cellSelectBlock(indexPath, companyModel);
    }
}

#pragma -- mark TableViewDataSource  ---------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYCompanyCell * cell = [tableView dequeueReusableCellWithIdentifier:YYCompanyCellId];
    
    if ([self.classid isEqualToString:@"0"] && indexPath.section == 0) {
        
        [cell setCompanyModel:self.recommendDataSource[indexPath.row]];

    }else {
        [cell setCompanyModel:self.companyDataSource[indexPath.row]];
    }
    
    return cell;
}



#pragma mark -------  辅助方法  ------------------------

/** 根据classid返回对应的url*/
- (NSString *)seekUrl:(NSInteger)fatherId {
    
    switch (fatherId) {
        case 6://投顾url
            return adviserUrl;
            break;
        
        case 7://券商url
            return brokerUrl;
            break;
            
        case 8://基金url
            return fundUrl;
            break;
            
    }
    return @"";
}

/** 刷新数据时 根据fatherid 返回对应的请求参数*/
- (NSDictionary *)para:(NSInteger)fatherId classid:(NSString *)classid{
    
    switch ([classid integerValue]) {
        case 0:{
         
            NSDictionary *para = [self.paraDic objectForKey:@(fatherId)];
            return para;
        }
            break;
        
        default:{
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"notall",@"act",classid,@"keyword", nil];
            return para;
        }
            break;
    }
    
}

/** 根据fatherid 返回对应的act参数*/
- (NSDictionary *)paraMore:(NSInteger)fatherId classid:(NSString *)classid{
    
//    act=allmore&lastid=LASTID
//    act=othermore&keyword=KEYWORD&lastid=LASTID
    switch ([classid integerValue]) {
        case 0:{
         
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"allmore",@"act",self.lastid,@"lastid", nil];
            return para;
        }
            break;
            
        default:{
         
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"othermore",@"act",classid,@"keyword",self.lastid,@"lastid", nil];
            return para;
        }
            break;
    }
}


/** 推荐数据换一批的请求参数*/
- (NSMutableDictionary *)recommendChange:(NSInteger)fatherId {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    switch (fatherId) {
        case 6:
            [para setValue:@"touguchange" forKey:@"act"];
            break;
            
        case 7:
            [para setValue:@"qschange" forKey:@"act"];
            break;
            
        default:
            [para setValue:@"jjchange" forKey:@"act"];
            break;
    }
    return para;
}


- (UIView *)sectionHeaderForSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 40)];
    view.backgroundColor = WhiteColor;
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(YYCommonCellLeftMargin, 10, 2, 20)];
    redView.backgroundColor = ThemeColor;
    [view addSubview:redView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    if (section == 0) {
        
        title.text = @"推荐";
    }else{
        title.text = @"公司列表";
    }
    
    title.font = TitleFont;
    title.textColor = SubTitleColor;
    [view addSubview:title];
    
    if (section == 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kSCREENWIDTH-80, 10, 70, 20);
        [button setTitle:@"换一批" forState:UIControlStateNormal];
        [button setImage:imageNamed(@"refresh_20x20_") forState:UIControlStateNormal];
        button.titleLabel.font = SubTitleFont;
        [button setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeRecommend:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)recommendDataSource{
    if (!_recommendDataSource) {
        _recommendDataSource = [NSMutableArray array];
    }
    return _recommendDataSource;
}

- (NSMutableArray *)companyDataSource{
    if (!_companyDataSource) {
        _companyDataSource = [NSMutableArray array];
    }
    return _companyDataSource;
}

- (NSMutableDictionary *)paraDic{
    if (!_paraDic) {
        _paraDic = [NSMutableDictionary dictionary];
        [_paraDic setObject:@{@"act":@"tougu"} forKey:@6];
        [_paraDic setObject:@{@"act":@"quanshang"} forKey:@7];
        [_paraDic setObject:@{@"act":@"jijin"} forKey:@8];
    }
    return _paraDic;
}

@end
