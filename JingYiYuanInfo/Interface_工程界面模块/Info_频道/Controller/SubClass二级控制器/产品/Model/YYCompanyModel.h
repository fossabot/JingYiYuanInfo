//
//  YYCompanyModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCompanyModel : NSObject

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
 
 id,logo,gname,regmoney,auth_tag认证标签,part功能标签,comtype公司类别
 */

/** id*/
@property (nonatomic, copy) NSString *comId;

/** logo 需拼接*/
@property (nonatomic, copy) NSString *logo;

/** gname公司名称*/
@property (nonatomic, copy) NSString *gname;

/** regmoney注册资金*/
@property (nonatomic, copy) NSString *regmoney;

/** 认证标签*/
@property (nonatomic, copy) NSString *auth_tag;

/** 功能标签*/
@property (nonatomic, copy) NSString *part;

/** 公司类别*/
@property (nonatomic, copy) NSString *comtype;


@end
