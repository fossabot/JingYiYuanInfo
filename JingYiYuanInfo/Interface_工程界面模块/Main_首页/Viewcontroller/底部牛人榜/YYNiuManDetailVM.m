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
#import "YYNiuManIntroduceCell.h"
#import "YYNiuManEmptyCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "NSString+Size.h"

@interface YYNiuManDetailVM()

/** 牛人文章数据源*/
@property (nonatomic, strong) NSMutableArray *niuArtDataSource;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end

@implementation YYNiuManDetailVM
{
//    BOOL _hidden;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _hidden = YES;
    }
    return self;
}

#pragma mark -- network   数据请求方法  ---------------------------

/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niuarticle",@"act",self.aid,@"niuid", nil];
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
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"niuarticle",@"act",self.lastid,@"lastid",self.aid,@"niuid", nil];
    
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

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (UIView *)headerForSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(YYInfoCellCommonMargin, 12, 2, 18)];
    redview.backgroundColor = ThemeColor;
    [view addSubview:redview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = section == 0 ? @"个人简介" : @"热门文章";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = TitleFont;
    label.textColor = TitleColor;
    [view addSubview:label];
    return view;
}

#pragma mark -------   scrollview delegate  ---------------------

/**
 *  监听滑动  改变头部头像的大小
 */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat contentOffSet = scrollView.contentOffset.y;
//
//    if (contentOffSet > 100 && _hidden) {
//        _hidden = NO;
//    }else if (contentOffSet < 100 && !_hidden){
//        _hidden = YES;
//    }
//    _hiddenHeaderBlock(_hidden);
//}


#pragma mark -------  tableview  代理方法 ---------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
//        CGFloat height = [self.introduce sizeWithFont:sysFont(14) size:CGSizeMake(kSCREENWIDTH-36, MAXFLOAT)].height;
        CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNiuManIntroduceCellID cacheByIndexPath:indexPath configuration:^(id cell) {
            
            YYNiuManIntroduceCell *introduceCell = (YYNiuManIntroduceCell *)cell;

            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 4;
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.introduce attributes:@{NSParagraphStyleAttributeName:style}];
            introduceCell.introduceLabel.attributedText = attributeStr;
        }];
        return height;
       
    }else {
        
        return self.niuArtDataSource.count == 0 ? 300 : 107;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0) {
        return 1;
    }
    tableView.mj_footer.hidden = (self.niuArtDataSource.count%10 != 0) || self.niuArtDataSource.count == 0;
        
    return self.niuArtDataSource.count == 0 ? 1 : self.niuArtDataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self headerForSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellSelectedBlock && indexPath.section == 1) {
       
        YYNiuArticleModel *articleModel = self.niuArtDataSource[indexPath.row];
        _cellSelectedBlock(articleModel, indexPath);
    }
}

#pragma -- mark TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YYNiuManIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:YYNiuManIntroduceCellID];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 4;
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.introduce attributes:@{NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:TitleColor}];
        cell.introduceLabel.attributedText = attributeStr;
        return cell;
    }else{
        
        if (self.niuArtDataSource.count) {
            
            YYNiuArticleCell *niuArtCell = [tableView dequeueReusableCellWithIdentifier:YYNiuArticleCellID];
            niuArtCell.niuArtModel = self.niuArtDataSource[indexPath.row];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return niuArtCell;
        }
        
        YYNiuManEmptyCell *niuManEmptyCell = [tableView dequeueReusableCellWithIdentifier:YYNiuManEmptyCellId];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return niuManEmptyCell;
    }
}


- (NSMutableArray *)niuArtDataSource{
    if (!_niuArtDataSource) {
        _niuArtDataSource = [NSMutableArray array];
    }
    return _niuArtDataSource;
}

@end
