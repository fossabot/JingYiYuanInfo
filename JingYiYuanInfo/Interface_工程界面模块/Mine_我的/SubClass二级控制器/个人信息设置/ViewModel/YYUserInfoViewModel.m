//
//  YYUserInfoViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUserInfoViewModel.h"

#import "YYUser.h"

#import "YYUserSectionModel.h"

#import "YYUserIconCell.h"

#import "YYBundleSDKCell.h"

static NSString * const UITableViewCellID = @"UITableViewCell";
static NSString * const UITableViewCommonCellID = @"UITableViewCommonCell";

@interface YYUserInfoViewModel()

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYUserInfoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getUserInfo];
    }
    return self;
}

#pragma mark -- inner Methods 自定义方法  -------------------------------
/** 上传头像*/
- (void)uploadIconToserver:(UIImage *)image completion:(void (^)(BOOL))completion {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID, nil];
    [YYHttpNetworkTool UPLOADFileWithUrlstring:mineChangeIconUrl parameters:para image:image serverName:@"file" savedName:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        [SVProgressHUD showProgress:bytesProgress status:@"正在上传头像"];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    } success:^(id response) {
        
        [YYUser configUserInfoWithDic:response[USERINFO]];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error) {
        if (completion) {
            
            completion(NO);
        }
    } showSuccessMsg:nil];
}

/** 更改数据源的模型数据*/
- (void)changeModelAtIndexPath:(NSIndexPath *)indexPath {
    
    YYUser *user = [YYUser shareUser];
    YYUserSectionModel *secModel = self.dataSource[indexPath.section];
    YYUserCommonCellModel *cellModel = secModel.dataSource[indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cellModel.icon = user.avatar;
                break;
            
            case 1:
                cellModel.subTitle = user.username;
                break;
                
            default:
                cellModel.subTitle = user.mobile;
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                cellModel.subTitle = user.guling;
                break;
            
            case 1:
                cellModel.subTitle = user.capital;
                break;
                
            case 2:
                cellModel.subTitle = user.email;
                break;
                
            case 3:
                cellModel.isBundleSDK = user.qqnum ? YES : NO;
                break;
            
            case 4:
                cellModel.isBundleSDK = user.weixin ? YES : NO;
                break;
                
            case 5:
                cellModel.isBundleSDK = user.weibo ? YES : NO;
                break;
                
            default:
                break;
        }
    }
    
}

/** 获取个人信息*/
- (void)getUserInfo {
    YYUser *user = [YYUser shareUser];
   
    YYUserCommonCellModel *commonModel0 = [[YYUserCommonCellModel alloc] init];
    commonModel0.title = @"头像";
    commonModel0.icon = user.avatar;
    commonModel0.cellHeight = 70;
    commonModel0.userInfoCellType = YYUserInfoCellTypeIcon;
    
    YYUserCommonCellModel *commonModel1 = [[YYUserCommonCellModel alloc] init];
    commonModel1.title = @"昵称";
    commonModel1.subTitle = user.username;
    commonModel1.isHaveIndicator = YES;
    commonModel1.cellHeight = 44;
    commonModel1.userInfoCellType = YYUserInfoCellTypeCommon;
    
    YYUserCommonCellModel *commonModel2 = [[YYUserCommonCellModel alloc] init];
    commonModel2.title = @"手机号";
    commonModel2.subTitle = user.mobile;
    commonModel2.cellHeight = 44;
    commonModel2.userInfoCellType = YYUserInfoCellTypeTel;
    
    YYUserSectionModel *sectionModel0 = [[YYUserSectionModel alloc] init];
    [sectionModel0.dataSource addObjectsFromArray:@[commonModel0,commonModel1,commonModel2]];
    
    
    YYUserCommonCellModel *commonModel3 = [[YYUserCommonCellModel alloc] init];
    commonModel3.title = @"股龄";
    commonModel3.subTitle = user.guling;
    commonModel3.isHaveIndicator = YES;
    commonModel3.cellHeight = 44;
    commonModel3.userInfoCellType = YYUserInfoCellTypeCommon;
    
    YYUserCommonCellModel *commonModel4 = [[YYUserCommonCellModel alloc] init];
    commonModel4.title = @"资金量";
    commonModel4.subTitle = user.capital;
    commonModel4.isHaveIndicator = YES;
    commonModel4.cellHeight = 44;
    commonModel4.userInfoCellType = YYUserInfoCellTypeCommon;
    
    YYUserCommonCellModel *commonModel5 = [[YYUserCommonCellModel alloc] init];
    commonModel5.title = @"邮箱";
    commonModel5.subTitle = user.email;
    commonModel5.isHaveIndicator = YES;
    commonModel5.cellHeight = 44;
    commonModel5.userInfoCellType = YYUserInfoCellTypeCommon;
    
    YYUserCommonCellModel *commonModel6 = [[YYUserCommonCellModel alloc] init];
    commonModel6.title = @"QQ绑定";
    commonModel6.isBundleSDK = user.qqnum ? YES : NO;
//    commonModel6.subTitle = user.qqnum;
    commonModel6.cellHeight = 44;
    commonModel6.userInfoCellType = YYUserInfoCellTypeBundle;
    
    YYUserCommonCellModel *commonModel7 = [[YYUserCommonCellModel alloc] init];
    commonModel7.title = @"微信绑定";
    commonModel7.isBundleSDK = user.weixin ? YES : NO;
//    commonModel7.subTitle = user.weixin;
    commonModel7.cellHeight = 44;
    commonModel7.userInfoCellType = YYUserInfoCellTypeBundle;
    
    YYUserCommonCellModel *commonModel8 = [[YYUserCommonCellModel alloc] init];
    commonModel8.title = @"微博绑定";
    commonModel8.isBundleSDK = user.weibo ? YES : NO;
//    commonModel8.subTitle = user.weibo;
    commonModel8.cellHeight = 44;
    commonModel8.userInfoCellType = YYUserInfoCellTypeBundle;
    
    YYUserSectionModel *sectionModel1 = [[YYUserSectionModel alloc] init];
    [sectionModel1.dataSource addObjectsFromArray:@[commonModel3,commonModel4,commonModel5,commonModel6,commonModel7,commonModel8]];

}

#pragma mark -------  tableview 代理方法 ------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    YYUserSectionModel *sec = self.dataSource[section];
    
    return [sec.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYUserSectionModel *sec = self.dataSource[indexPath.section];
    YYUserCommonCellModel *cellModel = sec.dataSource[indexPath.row];
    return cellModel.cellHeight;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YYUserSectionModel *secModel = self.dataSource[indexPath.section];
    YYUserCommonCellModel *model = secModel.dataSource[indexPath.row];
    
    switch (model.userInfoCellType) {
        case YYUserInfoCellTypeIcon:
            if ([self.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
                
                [self.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeIcon];
            }
            break;
        
        case YYUserInfoCellTypeTel:{
            //手机号只能展示  不能修改点击等，在设置账号安全里面修改
//            if ([self.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
//                
//                [self.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeTel];
//            }
        }
            break;
            
        case YYUserInfoCellTypeBundle:{
         
            if (model.isBundleSDK) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
                
                [self.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeBundle];
            }
        }
            break;
            
        default:{
            
            if ([self.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
                
                [self.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeCommon];
            }
        }
            break;
    }
    
}


#pragma mark -------  tableview 数据源方法 ------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYUserSectionModel *secModel = self.dataSource[indexPath.section];
    YYUserCommonCellModel *model = secModel.dataSource[indexPath.row];
    YYWeakSelf
    switch (model.userInfoCellType) {
        case YYUserInfoCellTypeIcon:{
            YYUserIconCell *iconCell = [tableView dequeueReusableCellWithIdentifier:YYUserIconCellID];
            if (!iconCell) {
                iconCell = [[YYUserIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YYUserIconCellID];
            }
            iconCell.title.text = model.title;
            iconCell.accessoryType = model.isHaveIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            iconCell.iconBlock = ^(){
                YYStrongSelf
                if ([strongSelf.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
                    
                    [strongSelf.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeIcon];
                }

            };
            [iconCell.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:imageNamed(@"yyfw_mine_unloginicon_83x83_")];
            return iconCell;
        }
            break;
        
        case YYUserInfoCellTypeTel:{
            UITableViewCell *telCell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
            if (!telCell) {
                telCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCellID];
            }
            telCell.accessoryType = UITableViewCellAccessoryNone;
            telCell.textLabel.text = model.title;
            telCell.detailTextLabel.text = model.subTitle;
            telCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return telCell;
        }
            
            break;
            
        case YYUserInfoCellTypeBundle:{
            YYBundleSDKCell *bundleCell = [tableView dequeueReusableCellWithIdentifier:YYBundleSDKCellID];
            if (!bundleCell) {
                bundleCell = [[YYBundleSDKCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:YYBundleSDKCellID];
            }
            bundleCell.accessoryType = model.isHaveIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            bundleCell.title.text = model.title;
            bundleCell.bundleButton.selected = model.isBundleSDK;
            bundleCell.bundleSDKBlock = ^(YYBundleSDKCell *cell){
                YYStrongSelf
                if ([strongSelf.delegate respondsToSelector:@selector(didSelectedCellAtIndexPath:cellType:)]) {
                    
                    [strongSelf.delegate didSelectedCellAtIndexPath:indexPath cellType:YYUserInfoCellTypeBundle];
                }
            };
            bundleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return bundleCell;
        }
            
            break;
            
        default:{
         
            UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:UITableViewCommonCellID];
            if (!commonCell) {
                commonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UITableViewCommonCellID];
            }
            commonCell.accessoryType = model.isHaveIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            commonCell.textLabel.text = model.title;
            commonCell.detailTextLabel.text = model.subTitle;
            commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return commonCell;
        }
            break;
    }
    
    return nil;
}






@end
