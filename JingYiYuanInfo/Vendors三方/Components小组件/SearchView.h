//
//  SearchView.h
//  自定义搜索界面
//
//  Created by VINCENT on 2017/8/17.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  searchview 用法 -- 将searchview初始化添加至VC的view上就行了
//  只是搜索历史记录界面搜索出结果需将该view隐藏，显示外界的搜索结果

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

/*已删除历史记录cell之后的代理回调*/
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

/** hotArr热门搜索的文字数组*/
@property (nonatomic, strong) NSArray *hotArr;

//插入一条搜索记录
- (void)insertSearchText:(NSString *)text;

@end


