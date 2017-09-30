//
//  YYPersonBannerModel.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYPersonBannerModel.h"

@implementation YYPersonBannerModel


- (NSString *)picurl {
    
    if ([_picurl containsString:@"http"]) {
        return _picurl;
    }
    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_picurl];
}

//- (NSString *)piclink {
//    
//    if ([_piclink containsString:@"http"]) {
//        return _piclink;
//    }
//    return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_piclink];
//}

@end
