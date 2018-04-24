//
//  YYBaseTabView.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBaseTabView.h"

@implementation YYBaseTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
            // iOS 9.0 以上系统的处理
            YYContentInsetBottom = 0;
        } else {
            // iOS 9.0 及以下系统的处理
            YYContentInsetBottom = 20;
        }
    
        self.tableView = [[THBaseTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, CGRectGetHeight(frame)) style:UITableViewStyleGrouped];
        self.tableView.tableFooterView = [[UIView alloc] init];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:YYMainVCGoTopNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:YYMainVCLeaveTopNotificationName object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    }
    return self;
}


-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:YYMainVCGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:YYMainVCLeaveTopNotificationName]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
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


- (void)dealloc {
    
    [kNotificationCenter removeObserver:self name:YYMainVCGoTopNotificationName object:nil];
    [kNotificationCenter removeObserver:self name:YYMainVCLeaveTopNotificationName object:nil];
}


@end
