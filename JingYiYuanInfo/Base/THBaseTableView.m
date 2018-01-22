//
//  THBaseTableView.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "THBaseTableView.h"

@implementation THBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
//        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}



@end
