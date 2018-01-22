//
//  YYHotViewVM.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotViewVM.h"

#import "MJExtension.h"

#import "YYHotTableViewCell.h"
#import "YYNewsLeftPicCell.h"
#import "YYNewsBigPicCell.h"
#import "YYNewsPicturesCell.h"
#import "YYNewsThreePicCell.h"

#import "YYHotTagModel.h"
#import "YYHotModel.h"
#import "YYHotHotModel.h"
#import "YYHotInfoModel.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface YYHotViewVM()



/** hotDataSource*/
@property (nonatomic, strong) NSMutableArray *hotDataSource;

/** infoDataSource*/
@property (nonatomic, strong) NSMutableArray *infoDataSource;


@end

@implementation YYHotViewVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _urlKey = 0;
    }
    return self;
}


/**
 *  加载新数据
 */
- (void)fetchNewDataCompletion:(void(^)(BOOL success))completion {
    
    
    NSInteger urlKey = self.urlKey%3 + 1;
    //参数  act=change  changeid=1
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"change",@"act",@(urlKey),@"changeid", nil];
    [PPNetworkHelper GET:changetagsUrl parameters:para responseCache:^(id responseCache) {
        YYLog(@"hotview这是缓存数据");
        YYLog(@"changetagsUrl : %@",changetagsUrl);
        if (!self.headerDataSource.count && responseCache) {
            //数据源有数据，不是初始化，不用拿缓存,否则将拿缓存给数据源
            YYHotModel *hotModel = [YYHotModel mj_objectWithKeyValues:responseCache];
            self.headerDataSource = (NSMutableArray *)hotModel.tag_arr;
            self.hotDataSource = (NSMutableArray *)hotModel.hot_arr;
            self.infoDataSource = (NSMutableArray *)hotModel.info_arr;
            self.lastid = hotModel.lastid;
            self.classid = [hotModel.tag_arr firstObject].tagid;
            
            YYLog(@"hotModel : %@",hotModel);
            completion(YES);
        }
    } success:^(id responseObject) {
        YYLog(@"hotview这是新数据");
        self.urlKey += 1;
        
        YYHotModel *hotModel = [YYHotModel mj_objectWithKeyValues:responseObject];
        self.headerDataSource = (NSMutableArray *)hotModel.tag_arr;
        self.hotDataSource = (NSMutableArray *)hotModel.hot_arr;
        self.infoDataSource = (NSMutableArray *)hotModel.info_arr;
        self.lastid = hotModel.lastid;
        self.classid = [hotModel.tag_arr firstObject].tagid;
        
        //渲染头部
        completion(YES);
        
    } failure:^(NSError *error) {
        completion(NO);
    }];
}

- (void)selectedTag:(NSInteger)tag completion:(void (^)(BOOL))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"classify",@"act",@(tag),@"classify",nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:newsUrl parameters:para success:^(id response) {
        YYHotModel *hotModel = [YYHotModel mj_objectWithKeyValues:response];
        
//        self.headerDataSource = (NSMutableArray *)hotModel.tag_arr;
        self.hotDataSource = (NSMutableArray *)hotModel.hot_arr;
        self.infoDataSource = (NSMutableArray *)hotModel.info_arr;
        self.classid = [hotModel.tag_arr firstObject].tagid;
        self.lastid = hotModel.lastid;
        completion(YES);
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];
}


/**
 *  加载更多数据
 */
- (void)fetchMoreDataCompletion:(void(^)(BOOL success))completion {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"loadmorehot",@"act",self.lastid,@"lastid",self.classid,@"classid", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:hotnewsmoreUrl parameters:para success:^(id response) {
        
        YYHotModel *hotModel = [YYHotModel mj_objectWithKeyValues:response];
        [self.infoDataSource addObjectsFromArray:hotModel.info_arr];
        self.lastid = hotModel.lastid;
        
        completion(YES);
        
    } failure:^(NSError *error) {
        
        completion(NO);
    } showSuccessMsg:nil];

}




#pragma mark ----------------------  代理方法区域  -------------------------------

#pragma -- mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:YYHotTableViewCellId  cacheByIndexPath:indexPath configuration:^(YYHotTableViewCell *hotCell) {
            [hotCell setHotModel:self.hotDataSource[indexPath.row] andIndex:indexPath.row];
        }];
        return height;
        
    }else {
        
        YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
        NSInteger index = hotInfoModel.picstate;
        switch (index) {
            case 1:{//左图
                CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsLeftPicCellId cacheByIndexPath:indexPath configuration:^(YYNewsLeftPicCell *leftCell) {
                    leftCell.hotinfoModel = hotInfoModel;
                }];
                return height;
            }
                break;
                
            case 2:{//大图
                CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsBigPicCellId cacheByIndexPath:indexPath configuration:^(YYNewsBigPicCell *bigCell) {
                    bigCell.hotinfoModel = hotInfoModel;
                }];
                return height;
            }
                break;
                
            case 3:{//三图
                CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsThreePicCellId cacheByIndexPath:indexPath configuration:^(YYNewsThreePicCell *threeCell) {
                    threeCell.hotinfoModel = hotInfoModel;
                }];
                return height;
            }
                break;
                
            default:{//4图集
                CGFloat height = [tableView fd_heightForCellWithIdentifier:YYNewsPicturesCellId cacheByIndexPath:indexPath configuration:^(YYNewsPicturesCell *picturesCell) {
                    picturesCell.hotinfoModel = hotInfoModel;
                }];
                return height;
            }
                break;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.05;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 10)];
    view.backgroundColor = WhiteColor;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return [self.hotDataSource count];
    }else {
        return [self.infoDataSource count];
    }
    
}

/** 首页热搜cell的点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.hotDataSource.count && indexPath.section == 0) {
        YYHotHotModel *hotModel = self.hotDataSource[indexPath.row];
        _selectedBlock(5, hotModel, indexPath);
        //自定义5位排行cell的点击
    }
    else {
        
        YYHotInfoModel *hotInfoModel = self.infoDataSource[indexPath.row];
        switch (hotInfoModel.picstate) {
            case 1:
            case 2:
            case 3:
                _selectedBlock(hotInfoModel.picstate, hotInfoModel, indexPath);
                break;
                
            case 4:
                _selectedBlock(hotInfoModel.picstate, hotInfoModel, indexPath);
                break;
                
            default:
                break;
        }
    
    }
}


#pragma -- mark TableViewDataSource  ------------------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YYHotTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:YYHotTableViewCellId];
        [hotCell setHotModel:self.hotDataSource[indexPath.row] andIndex:indexPath.row];
        return hotCell;
    }else {
        UITableViewCell *cell = [self setHotInfoTableView:tableView cellForRowAtIndexPath:indexPath.row];
        return cell;
    }
    
}

/** 热搜榜中新闻cell的分配*/
- (UITableViewCell *)setHotInfoTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSInteger)index {
    
    YYHotInfoModel *hotInfoModel = self.infoDataSource[index];
    switch (hotInfoModel.picstate) {
            
        case 1:{//左图
            YYNewsLeftPicCell *leftCell = [tableView dequeueReusableCellWithIdentifier:YYNewsLeftPicCellId];
            leftCell.hotinfoModel = hotInfoModel;
            return leftCell;
        }
            break;
            
        case 2:{//大图
            YYNewsBigPicCell *bigCell = [tableView dequeueReusableCellWithIdentifier:YYNewsBigPicCellId];
            bigCell.hotinfoModel = hotInfoModel;
            return bigCell;
        }
            break;
            
        case 3:{//三图
            YYNewsThreePicCell *threeCell = [tableView dequeueReusableCellWithIdentifier:YYNewsThreePicCellId];
            threeCell.hotinfoModel = hotInfoModel;
            return threeCell;
        }
            break;
            
        default:{//4图集
            YYNewsPicturesCell *picturesCell = [tableView dequeueReusableCellWithIdentifier:YYNewsPicturesCellId];
            picturesCell.hotinfoModel = hotInfoModel;
            return picturesCell;
        }
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YYMainVCLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
    }
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

/** 表述图的头部视图数据源，即标签数组*/
- (NSMutableArray<YYHotTagModel *> *)headerDataSource{
    if (!_headerDataSource) {
        _headerDataSource = [NSMutableArray array];
    }
    return _headerDataSource;
}

/** 热搜榜的数据源*/
- (NSMutableArray<YYHotHotModel *> *)hotDataSource{
    if (!_hotDataSource) {
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}

/** 资讯信息的数据源*/
- (NSMutableArray<YYHotInfoModel *> *)infoDataSource{
    if (!_infoDataSource) {
        _infoDataSource = [NSMutableArray array];
    }
    return _infoDataSource;
}


@end
