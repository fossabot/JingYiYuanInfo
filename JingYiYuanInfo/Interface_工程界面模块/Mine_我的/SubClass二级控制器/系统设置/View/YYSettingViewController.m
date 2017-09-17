//
//  YYSettingViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYMineSettingSecurityController.h"

#import "YYSettingViewModel.h"
#import "YYUser.h"
@interface YYSettingViewController ()

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/** settongViewModel*/
@property (nonatomic, strong) YYSettingViewModel *settingViewModel;

@end

@implementation YYSettingViewController

#pragma mark -- lifeCycle 生命周期  --------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)cellSelectIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
//            case 0:{
//                YYChangePhoneNumViewController *changeTelVc = [[YYChangePhoneNumViewController alloc] init];
//                [self.rt_navigationController pushViewController:changeTelVc animated:YES complete:nil];
//            }
//                break;
//            
//            case 1:{
//                YYChangePhoneNumViewController *changeTelVc = [[YYChangePhoneNumViewController alloc] init];
//                [self.rt_navigationController pushViewController:changeTelVc animated:YES complete:nil];
//            }
//                break;
//            
//            case 2:{
//                YYChangePhoneNumViewController *changeTelVc = [[YYChangePhoneNumViewController alloc] init];
//                [self.rt_navigationController pushViewController:changeTelVc animated:YES complete:nil];
//            }
//                break;
//                
//            case 3:{
//                YYChangePhoneNumViewController *changeTelVc = [[YYChangePhoneNumViewController alloc] init];
//                [self.rt_navigationController pushViewController:changeTelVc animated:YES complete:nil];
//            }
//                break;
            
            default:
                break;
        }
        
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出后将影响您接收壹元服务为您推送的消息" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [YYUser logOut];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:logOut];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self.settingViewModel;
        _tableView.dataSource = self.settingViewModel;
        
    }
    return _tableView;
}

- (YYSettingViewModel *)settingViewModel {
    if (!_settingViewModel) {
        _settingViewModel = [[YYSettingViewModel alloc] init];
        YYWeakSelf
        _settingViewModel.cellSelectBlock = ^(NSIndexPath *indexPath){
            YYStrongSelf
            [strongSelf cellSelectIndexPath:indexPath];
        };
    }
    return _settingViewModel;
}

@end
