//
//  YYThreeSeekDetailCompanyModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/20.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYThreeSeekDetailCompanyModel : NSObject

/**
 
 "com_intro_arr": {
 "logo": "uploads/image/20170327/1490589496.jpg",
 "gname": "浙江同花顺投资咨询有限公司",
 "url": "http://www.10jqka.com.cn/",
 "regmoney": "500.00",
 "comtype": "投顾",
 "auth_tag": "国际认证",
 "trendcontent": "",
 "introduction": "安信基金注册资本2亿元，公司股东为安信证券股份有限公司、五矿投资发展有限责任公司和中广核财务有限责任公司。其中安信证券持有49%股份，五矿投资和中广核财务持股比例分别为36%和15%。\r\n安信证券股份有限公司是国内大型综合类证券公司之一，综合实力位居国内证券业前列。其研究业务在宏观、策略及重点行业研究等领域处于业内领先水平，团队研究成果在“新财富最佳分析师”评选、“卖方分析师水晶球奖”评选、“中国证券分析师金牛奖”评选上屡获殊荣。"
 }
 */

/** logo*/
@property (nonatomic, copy) NSString *logo;

/** gname公司名称*/
@property (nonatomic, copy) NSString *gname;

/** url公司网址*/
@property (nonatomic, copy) NSString *url;

/** regmoney注册资金*/
@property (nonatomic, copy) NSString *regmoney;

/** comtype公司类别:基金,投顾....*/
@property (nonatomic, copy) NSString *comtype;

/** auth_tag*/
@property (nonatomic, copy) NSString *auth_tag;

/** trendcontent动态内容*/
@property (nonatomic, copy) NSString *trendcontent;

/** introduction公司介绍*/
@property (nonatomic, copy) NSString *introduction;

/** trendcontentHeight*/
@property (nonatomic, assign) CGFloat trendcontentHeight;

/** introductionHeight*/
@property (nonatomic, assign) CGFloat introductionHeight;

@end
