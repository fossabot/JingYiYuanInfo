//
//  YYCompanyListModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCompanyModel;

@interface YYCompanyListModel : NSObject

/** 
 "com_arr": [
 {
 "id": "224",
 "logo": "uploads/image/20170327/1490594550.png",
 "gname": "中原证券股份有限公司",
 "regmoney": "392373.47",
 "auth_tag": "国际认证",
 "part": "2,3",
 "comtype": "券商"
 },
 
 "lastid":""
 */

/** com_arr*/
@property (nonatomic, strong) NSArray<YYCompanyModel *> *com_arr;

/** lastid*/
@property (nonatomic, copy) NSString *lastid;

@end
