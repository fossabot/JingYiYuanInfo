//
//  YYCompanyCell.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCompanyModel;

static NSString * const YYCompanyCellId = @"YYCompanyCell";

@interface YYCompanyCell : UITableViewCell

/** 公司模型*/
@property (nonatomic, strong) YYCompanyModel *companyModel;

@end
