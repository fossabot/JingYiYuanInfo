//
//  YYSettingViewController.m
//  壹元服务
//
//  Created by VINCENT on 2017/4/24.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYMineSettingSecurityController.h"
#import "YYAddressController.h"
#import "YYSubscribleSettingController.h"
#import "PageSlider.h"

#import "YYSettingViewModel.h"
#import "YYUser.h"
#import "YYLoginManager.h"

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
    self.navigationItem.title = @"设置";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)cellSelectIndexPath:(NSIndexPath *)indexPath {
    
    YYWeakSelf
    if (indexPath.section == 0) {
        switch (indexPath.row) {//第一组，前三个已在VM中处理，为登录不会回调到这里
            case 0:{
                YYMineSettingSecurityController *security = [[YYMineSettingSecurityController alloc] init];
                [self.navigationController pushViewController:security animated:YES];
            }
                break;
            
            case 1:{
                YYAddressController *address = [[YYAddressController alloc] init];
                [self.navigationController pushViewController:address animated:YES];
            }
                break;
            
            case 2:{
                YYSubscribleSettingController *subscribleSetting = [[YYSubscribleSettingController alloc] init];
                [self.navigationController pushViewController:subscribleSetting animated:YES];
            }
                break;
                
            case 3:{
                
                NSArray *titles = @[@"标准",@"大",@"极大",@"超级大"];
                YYUser *user = [YYUser shareUser];
                [PageSlider showPageSliderWithTotalPoint:4 currentPoint:[user currentPoint] pointNames:titles fontChanged:^(CGFloat rate) {
                    
                    UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = user.webFontStr;
//                    [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
                break;
            
            case 5:{
                
                [SVProgressHUD showWithStatus:@"正在清理。。。"];
                [SVProgressHUD dismissWithDelay:3 completion:^{
                   
                    UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                    cell.detailTextLabel.text = @"0M";
                }];
            }
                break;
                
            default:
                break;
        }
        
        
    }else {
        YYWeakSelf
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出后将影响您接收壹元服务为您推送的消息" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            [YYLoginManager logOutAccountSuccess:^(BOOL success) {
                
                if (success) {
                    
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
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
        
        _settingViewModel.reloadBlock = ^{
          
            YYStrongSelf
            [strongSelf.tableView reloadData];
        };
    }
    return _settingViewModel;
}

@end
