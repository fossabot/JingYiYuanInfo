//
//  SearchView.h
//  自定义搜索界面
//
//  Created by VINCENT on 2017/8/17.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

@required
/**
 *  选中文字返回给代理搜索
 */
- (void)searchView:(UIView *)searchView didSelectText:(NSString *)searchText;

@end

/**
 *  cell点击删除按钮代理方法
 */
@protocol CellDeleteDelegate <NSObject>

- (void)searchViewDidDeleteCell:(UITableViewCell *)cell;

@end

/** 删除某一条历史记录的回调*/
typedef void(^HistoryBlock)(id cell);


@interface HistoryCell : UITableViewCell

/** historyBlock*/
//@property (nonatomic, copy) HistoryBlock historyBlock;

/** delete delgate*/
@property (nonatomic, weak) id<CellDeleteDelegate> delegate;

/** accessoryButton*/
@property (nonatomic, strong) UIButton *accessoryButton;

@end

@interface SearchView : UIView

/**
 *  刷新数据源
 */
- (void)reloadData;

/** 是否含有热门搜索  default NO*/
@property (nonatomic, assign) BOOL isHaveHotSearchText;

/** delegate*/
@property (nonatomic, weak) id<SearchDelegate> delegate;

/** hotArr*/
@property (nonatomic, strong) NSArray *hotArr;

- (void)insertSearchText:(NSString *)text;

@end


