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



@interface YYMainSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchDelegate>

/** searchBar*/
@property (nonatomic, strong) UIView *searchBar;

/** textField*/
@property (nonatomic, strong) UITextField *textField;

/** tableview*/
@property (nonatomic, strong) UITableView *searchListTable;

/** searchView*/
@property (nonatomic, strong) SearchView *searchView;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray<YYSearchList *> *dataSource;

@end

@implementation YYMainSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}



#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 取消按钮*/
- (void)cancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 搜索请求数据*/
- (void)searchingText:(NSString *)text {
#warning 搜索数据为空
    
    
}

/** 输入框为空时调用*/
- (void)textFieldBeingNull {
    self.searchView.hidden = NO;
    self.searchListTable.hidden = YES;
}


#pragma -- mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].subClasses.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataSource[section].className;
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSString *title = self.dataSource[indexPath.section].subClasses[indexPath.row].title;
    NSString *desc = self.dataSource[indexPath.section].subClasses[indexPath.row].desc;
    
    cell.textLabel.attributedText = [self attributeStringForStr:title keyWord:self.textField.text];
    cell.detailTextLabel.attributedText = [self attributeStringForStr:desc keyWord:self.textField.text];
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



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)searchListTable{
    if (!_searchListTable) {
        _searchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight, kSCREENWIDTH, kSCREENHEIGHT - YYTopNaviHeight) style:UITableViewStyleGrouped];
        _searchListTable.delegate = self;
        _searchListTable.dataSource = self;
        _searchListTable.hidden = YES;
    }
    return _searchListTable;
}

- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, YYTopNaviHeight, kSCREENWIDTH, kSCREENHEIGHT - YYTopNaviHeight)];
        _searchView.delegate = self;
    }
    return _searchView;
}


- (UIView *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, YYTopNaviHeight)];
        _searchBar.backgroundColor = [GraySeperatorColor colorWithAlphaComponent:0.7];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, kSCREENWIDTH-100, 30)];
        textField.delegate = self;
        textField.leftView = [[UIImageView alloc] initWithImage:imageNamed(@"searchicon_44x44")];
        textField.placeholder = @"搜索股票、基金、牛人";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.backgroundColor = YYRGB(239, 240, 241);
        textField.returnKeyType = UIReturnKeySearch;
        [textField addTarget:self action:@selector(textFieldBeingNull) forControlEvents:UIControlEventEditingChanged];
        [_searchBar addSubview:textField];
        self.textField = textField;
        
        
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:ThemeColor forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBar;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
