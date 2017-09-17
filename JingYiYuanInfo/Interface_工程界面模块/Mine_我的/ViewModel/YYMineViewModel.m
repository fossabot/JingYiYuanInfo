//
//  YYMineViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMineViewModel.h"
#import "YYMineCellModel.h"
#import "YYMineSectionModel.h"
#import "MJExtension.h"

#import "ShareView.h"

@interface YYMineViewModel()

/** rawDataSource*/
@property (nonatomic, strong) NSMutableArray *rawDataSource;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYMineViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchMineInfo];
    }
    return self;
}

- (void)fetchMineInfo {
    
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:[YYMineCellModel mj_objectArrayWithKeyValuesArray:self.rawDataSource[0]]];
    [self.dataSource addObject:[YYMineCellModel mj_objectArrayWithKeyValuesArray:self.rawDataSource[1]]];
    [self.dataSource addObject:[YYMineCellModel mj_objectArrayWithKeyValuesArray:self.rawDataSource[2]]];

//    self.dataSource = [YYMineSectionModel mj_objectArrayWithKeyValuesArray:self.rawDataSource];
}

- (NSInteger)numberOfSections {
    return  self.dataSource.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return  [self.dataSource[section] count];
}

- (YYMineModel *)modelOfIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.section][indexPath.row];
}


#pragma -- mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYMineCellModel *model = self.dataSource[indexPath.section][indexPath.row];
    if ([model.destinationVc isEqualToString:@"YYMineOnlineChatViewController"]) {//客服
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请通过以下方式联系我们" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *qq = [UIAlertAction actionWithTitle:@"QQ交流" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.cellSelecteBlock) {
                self.cellSelecteBlock(indexPath, model.destinationVc, nil);
            }
            
        }];
        UIAlertAction *mobile = [UIAlertAction actionWithTitle:@"电话沟通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([kApplication canOpenURL:[NSURL URLWithString:@"telprompt://010-87777077"]]) {
                [kApplication openURL:[NSURL URLWithString:@"telprompt://010-87777077"]];
            }
        }];
        UIAlertAction *giveUp = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:qq];
        [alert addAction:mobile];
        [alert addAction:giveUp];
        
        if (self.cellSelecteBlock) {
            self.cellSelecteBlock(indexPath, nil, alert);
        }
        
    }else if ([model.destinationVc isEqualToString:@""]) {//分享壹元服务
        [ShareView shareWithTitle:@"壹元服务" subTitle:@"提供专业的投资理财咨询" webUrl:@"http://www.1yuaninfo.com" imageUrl:nil isCollected:NO shareViewContain:nil shareContentType:nil finished:^(ShareViewType shareViewType, BOOL isFavor) {
            
            //不是收藏和字体，无须操作，分享接口直接调用umeng分享接口将信息分享出去
        }];
        
    }
    
    if (self.cellSelecteBlock) {
        self.cellSelecteBlock(indexPath, model.destinationVc, nil);
    }
    
}

#pragma -- mark TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    YYMineCellModel *model = self.dataSource[indexPath.section][indexPath.row];
    cell.imageView.image = imageNamed(model.icon);
    cell.textLabel.text = model.title;
    return cell;
}




- (NSMutableArray *)rawDataSource {
    if (!_rawDataSource) {
        _rawDataSource = [NSMutableArray array];
        
        NSDictionary *dic0 = [self dicIcon:@"yyfw_mine_collection_20x20_" title:@"我的收藏" destinationVc:@"YYMineFavoriteViewController"];
        NSDictionary *dic1 = [self dicIcon:@"yyfw_mine_order_20x20_" title:@"我的订单" destinationVc:@"YYMinePaymentViewController"];
        NSDictionary *dic2 = [self dicIcon:@"yyfw_mine_push_20x20_" title:@"消息推送记录" destinationVc:@"YYMineMsgHistoryViewController"];
        NSArray *sec0 = [NSArray arrayWithObjects:dic0,dic1,dic2, nil];
        [_rawDataSource addObject:sec0];
        
        
        NSDictionary *dic3 = [self dicIcon:@"yyfw_mine_shopping_20x20_" title:@"积分商城" destinationVc:@"YYMineIntegrationViewController"];
        NSArray *sec1 = [NSArray arrayWithObjects:dic3, nil];
        [_rawDataSource addObject:sec1];
        
        
        NSDictionary *dic4 = [self dicIcon:@"yyfw_mine_client_20x20_" title:@"在线客服" destinationVc:@"YYMineOnlineChatViewController"];
        NSDictionary *dic5 = [self dicIcon:@"yyfw_mine_share_20x20_" title:@"分享壹元服务" destinationVc:@""];
        NSDictionary *dic6 = [self dicIcon:@"yyfw_mine_aboutus_20x20_" title:@"关于我们" destinationVc:@"YYMineAboutUsViewController"];
        NSArray *sec2 = [NSArray arrayWithObjects:dic4,dic5,dic6, nil];
        [_rawDataSource addObject:sec2];
  
    }
    return _rawDataSource;
}

- (NSDictionary *)dicIcon:(NSString *)icon title:(NSString *)title destinationVc:(NSString *)destinationVc {
    NSDictionary *dic = @{
                          @"icon":icon,
                          @"title":title,
                          @"destinationVc":destinationVc
                          };
    return dic;
}

 


@end
