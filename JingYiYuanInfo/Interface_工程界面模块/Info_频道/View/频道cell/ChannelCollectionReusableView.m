//
//  ChannelCollectionReusableView.m
//  复杂tableviewcell搭建思路实现
//
//  Created by VINCENT on 2017/7/10.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "ChannelCollectionReusableView.h"

@implementation ChannelCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (IBAction)more:(id)sender {
    
    if (_moreBlock) {
        _moreBlock(sender);
    }
    
}




@end
