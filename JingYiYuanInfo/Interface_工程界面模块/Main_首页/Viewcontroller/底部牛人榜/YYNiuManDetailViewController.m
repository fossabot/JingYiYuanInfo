//
//  YYNiuManDetailViewController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/6.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//  牛人详情页

#import "YYNiuManDetailViewController.h"
#import "UIBarButtonItem+YYExtension.h"

@interface YYNiuManDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** uitableView*/
@property (nonatomic, strong) UITableView *tableView;

/** focus*/
@property (nonatomic, strong) UIBarButtonItem *focusItem;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYNiuManDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *focusItem = [[UIBarButtonItem alloc] initWithTitle:@"+关注" style:UIBarButtonItemStyleDone target:self action:@selector(focus)];
    self.navigationItem.rightBarButtonItem = focusItem;
    self.focusItem = focusItem;
    [self configSubView];
    
    
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)configSubView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:titleView.bounds];
    imageV.layer.cornerRadius = imageV.yy_height/2;
    imageV.layer.masksToBounds = YES;
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    self.imageView = imageV;
    [titleView addSubview:imageV];
    
    [self.view addSubview:self.tableView];
}

/**
 *  关注牛人
 */
- (void)focus {
    
    //关注后修改右耳目为已关注
    [self.focusItem setTitle:@"已关注"];
}

/**
 *  加载最新牛人观点
 */
- (void)loadNewData {
    
    
}

/**
 *  加载更多牛人观点
 */
- (void)loadMoreData {
    
    
}



#pragma -- mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


/**
 *  监听滑动  改变头部头像的大小
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentSet = scrollView.contentOffset.y + _tableView.contentInset.top;
    
    if (contentSet <= 0 && contentSet >= -44) {
        self.imageView.transform = CGAffineTransformMakeScale(1 - contentSet/44, 1-contentSet/44);
        self.imageView.yy_y = 0;
    }else if (contentSet > 0) {
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
        self.imageView.yy_y = 0;
    }
    
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
