//
//  YYMainSearchController.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYMainSearchController.h"
#import "SearchView.h"

#import "YYSearchList.h"
#import "YYSearchModel.h"
#import "YYSearchSecModel.h"
#import "YYSearchHotModel.h"
#import "YYSearchResultCell.h"

#import "YYNiuNewsDetailViewController.h"
#import "YYProjectDetailController.h"
#import "YYThreeSeekDetailController.h"
#import "YYShowOtherDetailController.h"
#import "YYBaseInfoDetailController.h"
#import "YYVideoDetailController.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import <MJExtension/MJExtension.h>

@interface YYMainSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchDelegate>

/** searchBar*/
@property (nonatomic, strong) UIView *searchBar;

/** 输入框*/
@property (nonatomic, strong) UITextField *textField;

/** 返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;

/** 搜索按钮*/
@property (nonatomic, strong) UIButton *searchBtn;

/** tableview*/
@property (nonatomic, strong) UITableView *searchListTable;

/** searchView*/
@property (nonatomic, strong) SearchView *searchView;

/** 我自己转变后台模型存放的方便我使用的数组*/
@property (nonatomic, strong) NSMutableArray *myDataSource;

/** 热搜的数组*/
@property (nonatomic, strong) NSMutableArray *hotDataSource;

/** 组头名字*/
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 组数据个数*/
@property (nonatomic, strong) NSMutableArray *rowDataSource;

/** searchListModel*/
@property (nonatomic, strong) YYSearchList *searchListModel;

@end

@implementation YYMainSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self configSubView];
    [self loadHotData];
}


//配置子控件
- (void)configSubView {
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchListTable];
    
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(YYTopNaviHeight);
    }];
    
    [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.searchBar).offset(YYInfoCellSubMargin);
        make.bottom.equalTo(self.searchBar).offset(-YYInfoCellSubMargin);
        make.width.height.equalTo(30);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backBtn.right).offset(YYInfoCellCommonMargin);
        make.bottom.equalTo(self.searchBar).offset(-YYInfoCellSubMargin);
        make.height.equalTo(30);
    }];
    
    [self.searchBtn makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.textField.right).offset(YYInfoCellSubMargin);
        make.right.equalTo(-YYInfoCellSubMargin);
        make.bottom.equalTo(self.searchBar).offset(-YYInfoCellSubMargin);
        make.height.equalTo(30);
        make.width.equalTo(40);
    }];
    
    [self.searchListTable makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.searchBar.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.searchBar.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 热门搜索*/
- (void)loadHotData {
    
//    [self.searchView setHotArr:@[@"lalal",@"oeoeo",@"jfjfjf"]];
//    return;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"hotsearch",@"act", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:searchUrl parameters:para success:^(id response) {
        
        if (response) {
            self.hotDataSource = [YYSearchHotModel mj_objectArrayWithKeyValuesArray:response[@"hsarr"]];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (YYSearchHotModel *hotModel in self.hotDataSource) {
                [tempArr addObject:hotModel.search_title];
            }
            [self.searchView setHotArr:tempArr];
        }
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];
}

/** 搜索按钮点击*/
- (void)searching:(UIButton *)sender {
    
    [self searchingText:self.textField.text];
}

/** 搜索按钮点击*/
- (void)dismiss:(UIButton *)sender {
    
    if (self.textField.text.length) {
        [self textFieldBeingNull];
        self.textField.text = @"";
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 搜索请求数据*/
- (void)searchingText:(NSString *)text {
    
    //判断输入框全是空格的思路 ：把空格和换行符全删除后剩余的字符长度不等于0，说明不全是空格
    NSCharacterSet *set=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString=[text stringByTrimmingCharactersInSet:set];
    if (trimedString.length == 0) {
        YYLog(@"当前输入框为空");
        [SVProgressHUD showImage:nil status:@"输入为空"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    [self.searchView insertSearchText:trimedString];
    
    [SVProgressHUD show];
    YYWeakSelf
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"global",@"act",trimedString,KEYWORD, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:searchUrl parameters:para success:^(id response) {
        [SVProgressHUD dismiss];
        if (response) {
            
            weakSelf.searchListModel = [YYSearchList mj_objectWithKeyValues:response];
            weakSelf.searchView.hidden = YES;
            weakSelf.searchListTable.hidden = NO;
            [weakSelf transferModel];
            [weakSelf.searchListTable reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    } showSuccessMsg:nil];
}

/** 输入框为空时调用*/
- (void)textFieldBeingNull {
    self.searchView.hidden = NO;
    self.searchListTable.hidden = YES;
}


#pragma -- mark TableViewDelegate   --------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.myDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    YYSearchSecModel *secModel = self.myDataSource[section];
    return secModel.models.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 40)];
    backView.backgroundColor = WhiteColor;
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 2, 20)];
    redView.backgroundColor = ThemeColor;
    [backView addSubview:redView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(23, 10, 200, 20)];
    title.textColor = TitleColor;
    title.font = NavTitleFont;
    YYSearchSecModel *secModel = self.myDataSource[section];
    title.text = secModel.className;
    [backView addSubview:title];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:YYSearchResultCellId cacheByIndexPath:indexPath configuration:^(YYSearchResultCell *cell) {
        
        YYSearchSecModel *secModel = self.myDataSource[indexPath.section];
        YYSearchModel *rowModel = secModel.models[indexPath.row];
        cell.title.text = rowModel.title;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYSearchSecModel *secModel = self.myDataSource[indexPath.section];
    YYSearchModel *rowModel = secModel.models[indexPath.row];
    //跳转相应的详情页
    [self jumpToRelativeVc:secModel.classId searchModel:rowModel];
    
}

#pragma -- mark TableViewDataSource   --------------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:YYSearchResultCellId];
    YYSearchSecModel *secModel = self.myDataSource[indexPath.section];
    YYSearchModel *rowModel = secModel.models[indexPath.row];
    cell.title.text = rowModel.title;
    
    return cell;
}

/** 转高亮字符串*/
- (NSMutableAttributedString *)attributeStringForStr:(NSString *)str keyWord:(NSString *)keyword {
    NSRange range = [keyword rangeOfString:str];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:ThemeColor range:range];
    
    return attrStr;
}

#pragma mark ------- searchView 代理方法 ——-----------------------------

- (void)searchView:(UIView *)searchView didSelectText:(NSString *)searchText {
    
    self.textField.text = searchText;
    [self searchingText:searchText];
}

#pragma mark -------  textField  代理方法  ----------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length) {
        self.searchListTable.hidden = NO;
        self.searchView.hidden = YES;
        [self.searchView insertSearchText:textField.text];
        [self searchingText:textField.text];
    }
    
    [self.view endEditing:YES];
    return YES;
}



#pragma mark  辅助方法 --------------------------

//跳转相应的详情页
- (void)jumpToRelativeVc:(NSInteger)classid searchModel:(YYSearchModel *)searchModel {
    
    switch (classid) {
        case 1:{//自定义搜索出来数据类型 1普通资讯文章  2资讯视频  3演出  4牛人观点  5项目  6三找
         
            YYBaseInfoDetailController * detail = [[YYBaseInfoDetailController alloc] init];
            detail.newsId = searchModel.searchId;
            detail.url = [NSString stringWithFormat:@"%@%@",infoWebJointUrl,searchModel.searchId];
            detail.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        
        case 2:{//2资讯视频
            
            YYVideoDetailController * detail = [[YYVideoDetailController alloc] init];
            detail.videoId = searchModel.searchId;
            detail.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",infoVideoJointUrl,searchModel.searchId]];
            detail.videoTitle = searchModel.title;
            detail.placeHolderImageUrl = @"";
            detail.seekTime = 0;
            detail.jz_wantsNavigationBarVisible = NO;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 3:{//3演出
            
            YYShowOtherDetailController * detail = [[YYShowOtherDetailController alloc] init];
//            detail.newsId = searchModel.searchId;
            detail.url = [NSString stringWithFormat:@"%@%@",showWebJointUrl,searchModel.searchId];
            detail.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 4:{//4牛人观点
            
            YYNiuNewsDetailViewController * detail = [[YYNiuNewsDetailViewController alloc] init];
            detail.niuNewsId = searchModel.searchId;
            detail.url = [NSString stringWithFormat:@"%@%@",niuWebJointUrl,searchModel.searchId];
            detail.newsTitle = searchModel.title;
            detail.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 5:{//5项目
            
            YYProjectDetailController * detail = [[YYProjectDetailController alloc] init];
            detail.projectId = searchModel.searchId;
            detail.url = [NSString stringWithFormat:@"%@%@",projecyJointUrl,searchModel.searchId];
            detail.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
        case 6:{//6三找
            
            YYThreeSeekDetailController * detail = [[YYThreeSeekDetailController alloc] init];
            detail.comid = searchModel.searchId;
            detail.isScrollToProduct = NO;
            detail.jz_wantsNavigationBarVisible = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
            
    }
}

//将后台返回的数据转成我自己适合使用的模型
- (void)transferModel {
    
    [self.myDataSource removeAllObjects];
    
    if (self.searchListModel.art_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"资讯";
        model.classId = 1;
        model.models = self.searchListModel.art_arr;
        [self.myDataSource addObject:model];
    }
    
    if (self.searchListModel.vid_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"视频";
        model.classId = 2;
        model.models = self.searchListModel.vid_arr;
        [self.myDataSource addObject:model];
    }
    
    if (self.searchListModel.sh_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"演出";
        model.classId = 3;
        model.models = self.searchListModel.sh_arr;
        [self.myDataSource addObject:model];
    }
    
    if (self.searchListModel.nar_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"牛人观点";
        model.classId = 4;
        model.models = self.searchListModel.nar_arr;
        [self.myDataSource addObject:model];
    }
    
    if (self.searchListModel.sm_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"项目";
        model.classId = 5;
        model.models = self.searchListModel.sm_arr;
        [self.myDataSource addObject:model];
    }
    
    if (self.searchListModel.sa_arr.count) {
        YYSearchSecModel *model = [[YYSearchSecModel alloc] init];
        model.className = @"投顾、券商、基金";
        model.classId = 6;
        model.models = self.searchListModel.sa_arr;
        [self.myDataSource addObject:model];
    }

}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)searchListTable{
    if (!_searchListTable) {
        _searchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight, kSCREENWIDTH, kSCREENHEIGHT - YYTopNaviHeight) style:UITableViewStyleGrouped];
        _searchListTable.delegate = self;
        _searchListTable.dataSource = self;
        _searchListTable.hidden = YES;
        _searchListTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _searchListTable.contentInset = UIEdgeInsetsMake(10, 0, 20, 0);
        [_searchListTable registerClass:[YYSearchResultCell class] forCellReuseIdentifier:YYSearchResultCellId];
        
        YYWeakSelf
        FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
        configer.emptyImage = imageNamed(emptyImageName);
        configer.emptyTitle = @"暂无搜索结果";
        configer.emptyTitleColor = UnenableTitleColor;
        configer.emptyTitleFont = SubTitleFont;
        configer.allowScroll = NO;
        configer.emptyViewTapBlock = ^{
            [weakSelf searching:nil];
        };
        [self.searchListTable emptyViewConfiger:configer];
    }
    return _searchListTable;
}

- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc] init];
        _searchView.isHaveHotSearchText = YES;
        _searchView.delegate = self;
    }
    return _searchView;
}


- (UIView *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UIView alloc] init];
        _searchBar.backgroundColor = ThemeColor;
//        [ThemeColor colorWithAlphaComponent:0.9];
        UITextField *textField = [[UITextField alloc] init];

        textField.delegate = self;
        textField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
        leftView.contentMode = UIViewContentModeRight;
        leftView.image = imageNamed(@"searchicon_44x44");
        textField.leftView = leftView;
        textField.tintColor = ThemeColor;
        textField.textColor = SubTitleColor;
        textField.font = SubTitleFont;
        textField.placeholder = @"搜索股票、基金、牛人";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.backgroundColor = YYRGB(239, 240, 241);
        textField.returnKeyType = UIReturnKeySearch;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [textField addTarget:self action:@selector(textFieldBeingNull) forControlEvents:UIControlEventEditingChanged];
        [_searchBar addSubview:textField];
        self.textField = textField;
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:imageNamed(@"nav_back_white_30x30") forState:UIControlStateNormal];
        [back addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        self.backBtn = back;
        [_searchBar addSubview:back];
        
        UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
        [search setTitle:@"搜索" forState:UIControlStateNormal];
        [search setTitleColor:SubTitleColor forState:UIControlStateNormal];
        search.titleLabel.font = TitleFont;
        [search setTitleColor:WhiteColor forState:UIControlStateNormal];
        [search addTarget:self action:@selector(searching:) forControlEvents:UIControlEventTouchUpInside];
        self.searchBtn = search;
        [_searchBar addSubview:search];
        
    }
    return _searchBar;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)hotDataSource{
    if (!_hotDataSource) {
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}


- (NSMutableArray *)myDataSource{
    if (!_myDataSource) {
        _myDataSource = [NSMutableArray array];
    }
    return _myDataSource;
}

@end
