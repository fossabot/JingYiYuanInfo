//
//  SearchView.m
//  自定义搜索界面
//
//  Created by VINCENT on 2017/8/17.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "SearchView.h"
#import "LabelContainer.h"
#import "YYSearchViewHeader.h"

static NSString * const historyCellId = @"historyCell";

@interface SearchView()<UITableViewDelegate,UITableViewDataSource,LabelContainerClickDelegate,CellDeleteDelegate>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** hotContainer*/
@property (nonatomic, strong) LabelContainer *hotContainer;

/** header*/
@property (nonatomic, strong) YYSearchViewHeader *header;

/** footer*/
@property (nonatomic, strong) UIButton *footer;

/** searchCachePath*/
@property (nonatomic, copy) NSString *searchCachePath;

/** historyArr*/
@property (nonatomic, strong) NSMutableArray *historyArr;

@end


@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        self.searchCachePath = [path stringByAppendingPathComponent:@"searchCachePath.txt"];
        self.historyArr = [NSMutableArray arrayWithContentsOfFile:self.searchCachePath];
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
        }];
        [self reloadData];
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
    [self renderHeader];
}

/** 渲染头部*/
- (void)renderHeader {
    
    if (!self.header) {
        self.header = [[YYSearchViewHeader alloc] initWithDatas:_hotArr];
        YYWeakSelf
        self.header.changeTagBlock = ^(NSInteger index){
            YYStrongSelf
            //选中标签的回调
//            YYHotTagModel *tagMoel = strongSelf.viewModel.headerDataSource[index];
//            [strongSelf selectTag:[tagMoel.tagid integerValue]];
            if ([strongSelf.delegate respondsToSelector:@selector(searchView:didSelectText:)]) {
                
                [strongSelf.delegate searchView:strongSelf didSelectText:strongSelf.hotArr[index]];
            }
        };
        
    }else {
        [self.header setDatas:_hotArr];
    }
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.header;
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/**
 *  插入一条历史记录
 */
- (void)insertSearchText:(NSString *)text {
    [self exchangeHistoryIndexWithText:text];
    
//    [NSKeyedArchiver archiveRootObject:self.historyArr toFile:self.searchCachePath];
    BOOL success = [self.historyArr writeToFile:self.searchCachePath atomically:YES];
    if (success) {
        YYLog(@"写入success");
    }else {
        YYLog(@"写入failure");
    }
    
    
    [self.tableView reloadData];
}

/**
 *  切换搜索文字在历史中的位置
 */
- (void)exchangeHistoryIndexWithText:(NSString *)text {
    if ([self.historyArr containsObject:text]) {
        [self.historyArr removeObject:text];
        [self.historyArr insertObject:text atIndex:0];
    }else {
        [self.historyArr addObject:text];
    }
}

/**
 *  清除历史
 */
- (void)clearHistory {
    [self.historyArr removeAllObjects];
    [self.tableView reloadData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_searchCachePath error:nil];
}


#pragma mark -------  tableView 代理方法 -------------------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.historyArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //改变历史记录的顺序
    NSString *text = [self.historyArr objectAtIndex:indexPath.row];
    [self.historyArr removeObjectAtIndex:indexPath.row];
    [self.historyArr insertObject:text atIndex:0];
    [self.historyArr writeToFile:_searchCachePath atomically:YES];
//    [tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathWithIndex:0]];
    [tableView reloadData];
    //代理执行搜索
    if ([self.delegate respondsToSelector:@selector(searchView:didSelectText:)]) {
        
        [self.delegate searchView:self didSelectText:self.historyArr[indexPath.row]];
        
    }
}


#pragma mark -------  collectionview 数据源方法  ----------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellId];
    cell.textLabel.text = self.historyArr[indexPath.row];
    cell.delegate = self;
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
    BOOL success = [self.historyArr writeToFile:self.searchCachePath atomically:YES];
    if (success) {
        YYLog(@"写入success");
    }else {
        YYLog(@"写入failure");
    }
//    [NSKeyedArchiver archiveRootObject:self.historyArr toFile:self.searchCachePath];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UIButton *)footer{
    if (!_footer) {
        _footer = [UIButton buttonWithType:UIButtonTypeCustom];
        _footer.frame = CGRectMake(0, 0, kSCREENWIDTH, 40);
        _footer.titleLabel.font = SubTitleFont;
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
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footer;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10);
        [_tableView registerClass:[HistoryCell class] forCellReuseIdentifier:historyCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (NSMutableArray *)historyArr{
    if (!_historyArr) {
        
//        _historyArr = [NSMutableArray arrayWithContentsOfFile:self.searchCachePath];
//        _historyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:self.searchCachePath]; 
        NSMutableArray *tempArr = [NSMutableArray arrayWithContentsOfFile:self.searchCachePath];
        if (tempArr) {
            _historyArr = tempArr;
        }else {
            _historyArr = [NSMutableArray array];
        }
    }
    return _historyArr;
}


@end


@interface HistoryCell()

@end

@implementation HistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.image = imageNamed(@"searchhistory_44x44");
        self.textLabel.textColor = SubTitleColor;
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

