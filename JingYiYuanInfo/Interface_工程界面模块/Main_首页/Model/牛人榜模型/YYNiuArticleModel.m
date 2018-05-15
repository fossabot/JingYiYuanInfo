//
//  YYNiuArticleModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/11.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuArticleModel.h"
#import "MJExtension.h"
#import "NSCalendar+YYCommentDate.h"

@implementation YYNiuArticleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"art_id":@"id",
             @"art_description":@"description"
             };
}

- (BOOL)selected {
    
    if (super.selected) {
        self.selected = YES;
        return YES;
    }else {
    
        super.selected = [[YYDataBaseTool sharedDataBaseTool] isUrlHadReaded:self.webUrl];
        
        return super.selected;
    }
    
}


- (NSString *)picurl {
    if (![_picurl containsString:@"http"]) {
        
        return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_picurl];
    }
    return _picurl;
}

- (NSString *)posttime {
    return [NSCalendar commentDateByOriginalDate:_posttime withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)webUrl {
    
    return [NSString stringWithFormat:@"%@%@",niuWebJointUrl,_art_id];
}

@end
