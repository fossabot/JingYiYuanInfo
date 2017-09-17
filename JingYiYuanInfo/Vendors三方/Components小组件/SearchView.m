//
//  SearchView.m
//  自定义搜索界面
//
//  Created by VINCENT on 2017/8/17.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "SearchView.h"
#import "LabelContainer.h"
#import "MJRefresh.h"

@interface SearchView()<UITableViewDelegate,UITableViewDataSource,LabelContainerClickDelegate,CellDeleteDelegate>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** hotContainer*/
@property (nonatomic, strong) LabelContainer *hotContainer;

/** header*/
@property (nonatomic, strong) UIButton *footer;

/** searchCachePath*/
@property (nonatomic, copy) NSString *searchCachePath;

/** historyArr*/
@property (nonatomic, strong) NSMutableArray *historyArr;

@end




@implementation HistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.accessoryButton];
    }
    return self;
}

- (UIButton *)accessoryButton{
    if (!_accessoryButton) {
        _accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessoryButton setImage:imageNamed(@"searchdelete_44x44") forState:UIControlStateNormal];
        _accessoryButton.frame = CGRectMake(kSCREENWIDTH - 50, 5, 30, 30);
        [_accessoryButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accessoryButton;
}

- (void)deleteCell:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(searchViewDidDeleteCell:)]) {
        [self.delegate searchViewDidDeleteCell:self];
    }
//    YYWeakSelf
//    if (self.historyBlock) {
//        YYStrongSelf
//        self.historyBlock(strongSelf);
//    }
}


@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        self.searchCachePath = [path stringByAppendingPathComponent:@"searchCachePath.plist"];
        [self addSubview:self.tableView];
    }
    return self;
}

/**
 *  刷新数据源
 */
- (void)reloadData {
    
    [self.tableView reloadData];
}

- (void)setHotArr:(NSArray *)hotArr {
    _hotArr = hotArr;
    [self.hotContainer setTitles:hotArr];
    [self.tableView reloadData];
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  插入一条历史记录
 */
- (void)insertSearchText:(NSString *)text {
    [self exchangeHistoryIndexWithText:text];
    [_historyArr writeToFile:self.searchCachePath atomically:YES];
    [self.tableView reloadData];
}

/**
 *  切换搜索文字在历史中的位置
 */
- (void)exchangeHistoryIndexWithText:(NSString *)text {
    if ([_historyArr containsObject:text]) {
        [_historyArr removeObject:text];
        [_historyArr insertObject:text atIndex:0];
    }else {
        [_historyArr addObject:text];
    }
}

/**
 *  清除历史
 */
- (void)clearHistory {
    [self.historyArr removeAllObjects];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -------  collectionview 代理方法 -------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = self.hotArr ? self.hotContainer.bounds.size.height : 10;
        return height;
    }else {
        return 40;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }else{
        return 0.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 30)];
    label.text = @"  热门搜索";
    label.backgroundColor = WhiteColor;
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.historyArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //改变历史记录的顺序
    if (indexPath.section == 1) {
        NSString *text = [_historyArr objectAtIndex:indexPath.row];
        [_historyArr removeObjectAtIndex:indexPath.row];
        [_historyArr insertObject:text atIndex:0];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //代理执行搜索
    if ([self.delegate respondsToSelector:@selector(searchView:didSelectText:)]) {
        
        [self.delegate searchView:self didSelectText:_historyArr[indexPath.row]];
        
    }
}


#pragma mark -------  collectionview 数据源方法  ----------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellSection = @"cellsection0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSection];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSection];
            [cell.contentView addSubview:self.hotContainer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    static NSString *cellId = @"cellid";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = imageNamed(@"searchhistory_44x44");
    }
    cell.textLabel.text = self.historyArr[indexPath.row];
    cell.delegate = self;
//    YYWeakSelf
    //点击cell的删除按钮的回调
//    cell.historyBlock = ^(id hisCell){
//        YYStrongSelf
//        HistoryCell *historyCell = (HistoryCell *)hisCell;
//        NSIndexPath *index = [strongSelf.tableView indexPathForCell:historyCell];
//        [strongSelf.historyArr removeObjectAtIndex:index.row];
//        [strongSelf.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//    };
    return cell;
}


#pragma mark ------- container 代理区域  -------------------------------

- (void)labelContainerDidClickAtIndex:(NSInteger)index labelTitle:(NSString *)title {
    if ([self.delegate respondsToSelector:@selector(searchView:didSelectText:)]) {
        
        [self.delegate searchView:self didSelectText:title];
    }
    
}


#pragma mark -------  cell 删除按钮的代理方法 -----------------------------

- (void)searchViewDidDeleteCell:(UITableViewCell *)cell {
    HistoryCell *historyCell = (HistoryCell *)cell;
    NSIndexPath *index = [self.tableView indexPathForCell:historyCell];
    [self.historyArr removeObjectAtIndex:index.row];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)footer{
    if (!_footer) {
        _footer = [UIButton buttonWithType:UIButtonTypeCustom];
        _footer.frame = CGRectMake(0, 0, kSCREENWIDTH, 40);
        [_footer setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_footer setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_footer setBackgroundColor:WhiteColor];
        [_footer addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footer;
}

- (LabelContainer *)hotContainer{
    if (!_hotContainer) {
        _hotContainer = [[LabelContainer alloc] init];
        _hotContainer.delegate = self;
        _hotContainer.labelTitleColor = UnenableTitleColor;
        _hotContainer.fontSize = 16.f;
        _hotContainer.labelBorderColor = UnenableTitleColor;
    }
    return _hotContainer;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -100, 0, -100);
    }
    return _tableView;
}

- (NSMutableArray *)historyArr{
    if (!_historyArr) {
        
        _historyArr = [NSMutableArray arrayWithContentsOfFile:self.searchCachePath];
    }
    return _historyArr;
}



@end
