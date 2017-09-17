//
//  YYBundleSDKCell.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYBundleSDKCell.h"

@implementation YYBundleSDKCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 绑定第三方平台SDK*/
- (IBAction)bundleSDK:(UIButton *)sender {
    
    if (sender.isSelected) {
        return;
    }
    //回调
    if (self.bundleSDKBlock) {
        
        self.bundleSDKBlock(self);
    }
}


@end
