//
//  YYUserInfoViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYUserInfoViewController.h"
#import "YYChangeUserInfoController.h"
#import "YYChangePhoneNumViewController.h"

#import "YYUserInfoViewModel.h"
#import "YYImageControllerTool.h"
#import "YYUser.h"

#import <UMSocialCore/UMSocialCore.h>  //友盟登录第三方

@interface YYUserInfoViewController ()<YYUserInfoViewModelCellDidSelectedDelegate>

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** viewModel*/
@property (nonatomic, strong) YYUserInfoViewModel *userInfoViewModel;

@end

@implementation YYUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


#pragma mark -------  个人信息的Viewmodel的代理方法 -------------------------

- (void)didSelectedCellAtIndexPath:(NSIndexPath *)indexPath cellType:(YYUserInfoCellType)userCellType {
    
    switch (userCellType) {
        case YYUserInfoCellTypeIcon:{
            
            [self awakeUpAlbumAtIndexPath:indexPath];
        }
            break;
            
        case YYUserInfoCellTypeTel:{
            
//            [self accessToChangeTelControllerAtIndexPath:indexPath];
        }
            break;
            
        case YYUserInfoCellTypeBundle:{
            
            [self accessToBundleControllerAtIndexPath:indexPath];
        }
            break;
            
        
        default:{
            [self accessToChangeUserInfoControllerAtIndexPath:indexPath];
        }
            break;
    }
    
}

/** 唤起系统相册*/
- (void)awakeUpAlbumAtIndexPath:(NSIndexPath *)indexPath {
    YYWeakSelf
    [YYImageControllerTool awakeImagePickerControllerCompletion:^(UIImage *image) {
        YYStrongSelf
        [strongSelf.userInfoViewModel uploadIconToserver:image completion:^(BOOL success) {
            
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"更改头像成功"];
                [strongSelf.userInfoViewModel changeModelAtIndexPath:indexPath];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [SVProgressHUD showErrorWithStatus:@"更改头像失败"];
            }
        }];
    }];
}


/** 进入更换手机号的界面*/
//- (void)accessToChangeTelControllerAtIndexPath:(NSIndexPath *)indexPath {
//    
//    YYChangePhoneNumViewController *changePhoneNumVc = [[YYChangePhoneNumViewController alloc] init];
//    YYWeakSelf
//    changePhoneNumVc.completion = ^(){
//        YYStrongSelf
//        [strongSelf.userInfoViewModel changeModelAtIndexPath:indexPath];
//        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    };
//    [self.rt_navigationController pushViewController:changePhoneNumVc animated:YES complete:^(BOOL finished) {
//        
//    }];
//}


/** 进入改变用户普通信息的界面*/
- (void)accessToChangeUserInfoControllerAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    YYChangeUserInfoController *changeUserInfoVc = [[YYChangeUserInfoController alloc] init];
    //将cell赋值给改变信息的控制器，内部直接将cell的detailLabel的text改了，同时也更新了YYuser
    changeUserInfoVc.cell = cell;
    changeUserInfoVc.paraKey = [self getParaKeyAtIndexPath:indexPath];
//    [self.rt_navigationController pushViewController:changeUserInfoVc animated:YES complete:nil];
    [self.navigationController pushViewController:changeUserInfoVc animated:YES];
}

- (NSString *)getParaKeyAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            return USERNAME;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                return @"guling";
                break;
            
            case 1:
                return @"capital";
                break;
                
            case 2:
                return @"email";
                break;
                
            default:
                return nil;
                break;
        }
    }
    return nil;
}

/** 进入绑定第三方的界面*/
- (void)accessToBundleControllerAtIndexPath:(NSIndexPath *)indexPath {
    
    //3 QQ绑定  4微信绑定  5微博绑定
    
    switch (indexPath.row) {
        case 3:
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ atIndexPath:indexPath paraKey:@"qqnum"];
            break;
        
        case 4:
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession atIndexPath:indexPath paraKey:@"weixin"];
            break;
            
        case 5:
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina atIndexPath:indexPath paraKey:@"weibo"];
            break;
            
        default:
            break;
    }
}


/** 
 UShare封装后字段名	QQ原始字段名	微信原始字段名	 新浪原始字段名	 字段含义	      备注
 uid                openid      unionid      uid             用户唯一标识	  uid能否实现Android与iOS平台打通，目前QQ只能实现同APPID下用户ID匹配
 
 openid             openid      openid       空              用户唯一标识	  主要为微信和QQ使用
 
 unionid            unionid     unionid      uid             用户唯一标识	  主要为微信             和QQ使用，unionid主要用于微信、QQ用户系统打通
 
 usid               openid      openid       uid             用户唯一标识 	  用于U-Share 4.x/5.x 升级后保留原先使用形式
 
 name               screen_name	screen_name	 screen_name	 用户昵称
 
 gender             gender      gender       gender          用户性别	      该字段会直接返回男女
 
 iconurl       profile_image_url profile_image_url profile_image_url	  用户头像
 
 */

/** 获取第三方的授权*/
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType atIndexPath:(NSIndexPath *)indexPath paraKey:(NSString *)parakey
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        YYWeakSelf
        YYUser *user = [YYUser shareUser];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:parakey,@"act",user.userid,USERID,resp.uid,parakey, nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:mineChangeUserInfoUrl parameters:para success:^(id response) {
            YYStrongSelf
            [strongSelf.userInfoViewModel changeModelAtIndexPath:indexPath];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(NSError *error) {
            
        } showSuccessMsg:@"绑定成功"];
    }];
}




#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self.userInfoViewModel;
        _tableView.dataSource = self.userInfoViewModel;
    }
    return _tableView;
}

- (YYUserInfoViewModel *)userInfoViewModel{
    if (!_userInfoViewModel) {
        _userInfoViewModel = [[YYUserInfoViewModel alloc] init];
        _userInfoViewModel.delegate = self;
    }
    return _userInfoViewModel;
}

@end
