//
//  YYHotInfoModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/9.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHotInfoModel.h"
#import "MJExtension.h"
#import "NSCalendar+YYCommentDate.h"
#import "NSString+Size.h"
#import "YYHotPicsModel.h"
#import "YYUser.h"

static CGFloat const leftPicH = 70;
//static CGFloat const bigPicH = (kSCREENWIDTH-20)*0.6;

#define threePicsH (kSCREENWIDTH-50)/3*9/16
#define bigPicsH  (kSCREENWIDTH-20)*0.6


@implementation YYHotInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"infoid":@"id",
             @"infodescription":@"description"
             };
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"picarr":@"YYHotPicsModel"
             };
}


- (BOOL)selected {
    
    if (super.selected) {
        self.selected = YES;
        return YES;
    }else {
        if (_picstate == 4) {
            super.selected = [[YYDataBaseTool sharedDataBaseTool] isUrlHadReaded:self.sharePicsUrl];
        }else {
            
            super.selected = [[YYDataBaseTool sharedDataBaseTool] isUrlHadReaded:self.webUrl];
        }
        return super.selected;
    }

}

- (NSString *)webUrl {
    
    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {
        
        _webUrl = [NSString stringWithFormat:@"%@%@&userid=%@",infoWebJointUrl,_infoid,user.userid];
    }else{
        _webUrl = [NSString stringWithFormat:@"%@%@",infoWebJointUrl,_infoid];
    }
    return _webUrl;
}

- (NSString *)shareUrl {
    
    YYUser *user = [YYUser shareUser];
    if (user.isLogin) {
        
        _shareUrl = [NSString stringWithFormat:@"%@%@&userid=%@",infoWebShareJointUrl,_infoid,user.userid];
    }else{
        _shareUrl = [NSString stringWithFormat:@"%@%@",infoWebShareJointUrl,_infoid];
    }
    return _shareUrl;
}

- (NSString *)sharePicsUrl {
    
    return [NSString stringWithFormat:@"%@%@",picsWebShareJointUrl,self.infoid];
}


- (NSString *)picurl {
    if (_picurl && ![_picurl containsString:@"http"]) {
        
        return [NSString stringWithFormat:@"%@%@",yyappJointUrl,_picurl];
    }else if(!_picurl){
        
        return _picarr[0].img;
    }
    return _picurl;
}

- (NSString *)posttime {
    return [NSCalendar commentDateByOriginalDate:_posttime withDateFormat:yyyyMMddHHmmss];
}


/** 1为左图，2为大图，3为三图，4为图集*/
- (CGFloat)cellHeight {
    
    CGFloat titleH = [_title sizeWithFont:TitleFont].height;
    CGFloat posttimeH = [_posttime sizeWithFont:UnenableTitleFont].height;
    if (_picstate == 1) {
//        CGFloat subTitleH = [_infodescription sizeWithFont:SubTitleFont].height;
        return YYInfoCellCommonMargin*2 + titleH + leftPicH;
    }else if (_picstate == 2) {
       
        return YYInfoCellCommonMargin*2 + titleH + bigPicsH + YYInfoCellSubMargin + posttimeH;
    }else if (_picstate == 3) {
        
        return YYInfoCellCommonMargin*2 + titleH + threePicsH + YYInfoCellSubMargin + posttimeH;
    }else if (_picstate == 4) {
        
        return YYInfoCellCommonMargin*2 + titleH + bigPicsH + YYInfoCellSubMargin + posttimeH;
    }
    return 0;
}

@end
