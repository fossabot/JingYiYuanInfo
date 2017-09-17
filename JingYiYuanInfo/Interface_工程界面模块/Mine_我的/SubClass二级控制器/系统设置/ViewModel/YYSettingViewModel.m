//
//  YYSettingViewModel.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYSettingViewModel.h"
#import "YYMineSettingCellModel.h"
#import "YYUser.h"


static NSString * const commonCellID = @"commonCell";
static NSString * const subTitleCellID = @"subTitleCell";
static NSString * const switchCellID = @"switchCell";
static NSString * const logOutCellID = @"logOutCell";

@interface YYSettingViewModel()

/** dataSource*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YYSettingViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma -- mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYUser *user = [YYUser shareUser];
    if (indexPath.row <= 2 && !user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账号，请登录后操作"];
        return;
    }
    if (_cellSelectBlock) {
        _cellSelectBlock(indexPath);
    }
}

#pragma -- mark TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYMineSettingCellModel *settingModel = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
//            case 0:
//            case 1:
//            case 2:
//            {//账号安全、我的地址、订阅设置
//                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commonCellID];
//                if (!cell) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commonCellID];
//                }
//                cell.textLabel.text = settingModel.title;
//                return cell;
//            }
//                break;
//
//            case 3:
//            {//字体大小
//                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:subTitleCellID];
//                if (!cell) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:subTitleCellID];
//                }
//                cell.textLabel.text = settingModel.title;
//                cell.detailTextLabel.text = settingModel.subTitle;
//                return cell;
//            }
//                break;

            case 4:
            {//wifi环境下播放
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:switchCellID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchCellID];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UISwitch *switchBtn = [[UISwitch alloc] init];
                    switchBtn.onTintColor = ThemeColor;
                    [switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.accessoryView = switchBtn;
                }
                cell.textLabel.text = settingModel.title;
                cell.detailTextLabel.text = settingModel.subTitle;
                return cell;

            }
                break;
                
            default:
            {//清除缓存 账号安全、我的地址、订阅设置 字体大小
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:subTitleCellID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:subTitleCellID];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = settingModel.title;
                cell.detailTextLabel.text = settingModel.subTitle ? : @"";
                return cell;
            }
                break;
        }

    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:logOutCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logOutCellID];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = settingModel.title;
        return cell;
    }

}


#pragma mark -- inner Methods 自定义方法  -------------------------------

- (void)changeCellModelAtIndexPath:(NSIndexPath *)indexPath {
    
    YYMineSettingCellModel *settingModel = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            case 1:
            case 2:
                return;
                break;
                
            default:
                
                break;
        }
    }else {
        settingModel.canSelect = NO;
    }
    
}


/** wifi 环境下的开关*/
- (void)switchBtnClick:(UISwitch *)sender {
    
    YYUser *user = [YYUser shareUser];
    [user setCanWIFIPlay:sender.isOn];
}


#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        YYUser *user = [YYUser shareUser];
        YYMineSettingCellModel *model0 = [[YYMineSettingCellModel alloc] init];
        model0.title = @"账号与安全";
        model0.destinationVc = @"";
        
        YYMineSettingCellModel *model1 = [[YYMineSettingCellModel alloc] init];
        model1.title = @"我的地址";
        model1.destinationVc = @"";
        
        YYMineSettingCellModel *model2 = [[YYMineSettingCellModel alloc] init];
        model2.title = @"订阅设置";
        model2.destinationVc = @"";
        
        YYMineSettingCellModel *model3 = [[YYMineSettingCellModel alloc] init];
        model3.title = @"字体大小";
        model3.subTitle = user.webFontStr;
        
        YYMineSettingCellModel *model4 = [[YYMineSettingCellModel alloc] init];
        model4.title = @"WIFI环境下播放";
        model4.canWifiPlay = user.canWIFIPlay;
        
        YYMineSettingCellModel *model5 = [[YYMineSettingCellModel alloc] init];
        model5.title = @"清楚缓存";
        model5.subTitle = [NSString stringWithFormat:@"%lfM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
    
        [_dataSource addObject:@[model0,model1,model2,model3,model4,model5]];
        
        YYMineSettingCellModel *model6 = [[YYMineSettingCellModel alloc] init];
        model6.title = @"退出登录";
        model6.canSelect = user.isLogin;
        
        [_dataSource addObject:@[model6]];
    }
    return _dataSource;
}




@end
