//
//  YYBackOrderController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/1/26.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#define cancelOrderUrl @"http://yyapp.1yuaninfo.com/app/houtai/admin/backOrder.php"

#import "YYBackOrderController.h"
#import "YYReasonView.h"
#import "YYCommentTextView.h"
#import "DaiDodgeKeyboard.h"
#import "YYBackOrderSucceedController.h"

@interface YYBackOrderController ()<UITextViewDelegate>

/** */
@property (nonatomic, strong) YYCommentTextView *textView;

/** commit*/
@property (nonatomic, strong) UIButton *commit;

/** 选择的理由数组*/
@property (nonatomic, strong) NSMutableArray *reasonArr;

@end

@implementation YYBackOrderController
{
    NSString *_reasonStr;
    NSInteger _canCommit;
}

- (void)dealloc {
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YYLogFunc
    self.navigationItem.title = @"申请终止服务";
    _canCommit = 0;
    [self createSubView];
    YYLogFunc
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.baseScrollView];
}


- (void)createSubView {
    
    UILabel *tip = [[UILabel alloc] init];
    tip.text = @"请选择您的理由";
    tip.font = [UIFont boldSystemFontOfSize:17];
    [self.baseScrollView addSubview:tip];
    
    YYWeakSelf
    YYReasonView *reasonView1 = [[YYReasonView alloc] init];
    reasonView1.title.text = @"最近很忙，没时间操作";
    reasonView1.reasonBlock = ^(BOOL selected) {
        YYStrongSelf
        strongSelf->_canCommit += selected ? 1 : -1;
        
        if (selected) {
            [strongSelf.reasonArr addObject:@"1"];
        }else {
            [strongSelf.reasonArr removeObject:@"1"];
        }
    };
    [self.baseScrollView addSubview:reasonView1];
    
    YYReasonView *reasonView2 = [[YYReasonView alloc] init];
    reasonView2.title.text = @"资金有其他用途";
    reasonView2.reasonBlock = ^(BOOL selected) {
        YYStrongSelf
        strongSelf->_canCommit += selected ? 1 : -1;
        if (selected) {
            [strongSelf.reasonArr addObject:@"2"];
        }else {
            [strongSelf.reasonArr removeObject:@"2"];
        }
    };
    [self.baseScrollView addSubview:reasonView2];
    
    YYReasonView *reasonView3 = [[YYReasonView alloc] init];
    reasonView3.title.text = @"服务质量不好";
    reasonView3.reasonBlock = ^(BOOL selected) {
        YYStrongSelf
        strongSelf->_canCommit += selected ? 1 : -1;
        if (selected) {
            [strongSelf.reasonArr addObject:@"3"];
        }else {
            [strongSelf.reasonArr removeObject:@"3"];
        }
    };
    [self.baseScrollView addSubview:reasonView3];
    
    YYReasonView *reasonView4 = [[YYReasonView alloc] init];
    reasonView4.title.text = @"效果不理想";
    reasonView4.reasonBlock = ^(BOOL selected) {
        YYStrongSelf
        strongSelf->_canCommit += selected ? 1 : -1;
        if (selected) {
            [strongSelf.reasonArr addObject:@"4"];
        }else {
            [strongSelf.reasonArr removeObject:@"4"];
        }
    };
    [self.baseScrollView addSubview:reasonView4];
    
    UILabel *other = [[UILabel alloc] init];
    other.text = @"其他";
    other.font = [UIFont boldSystemFontOfSize:17];
    [self.baseScrollView addSubview:other];
    
    YYCommentTextView *textView = [[YYCommentTextView alloc] initWithFrame:CGRectZero PlaceText:@"建议意见" PlaceColor:UnenableTitleColor];
    textView.font = SubTitleFont;
    textView.layer.borderColor = UnenableTitleColor.CGColor;
    textView.layer.cornerRadius = 5;
    textView.layer.borderWidth = 1.f;
    self.textView = textView;
    [self.baseScrollView addSubview:textView];
    
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeCustom];
    commit.backgroundColor = ThemeColor;
    commit.layer.cornerRadius = 5;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitSuggestion:) forControlEvents:UIControlEventTouchUpInside];
    self.commit = commit;
    [self.baseScrollView addSubview:commit];
    
    [tip makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.top.equalTo(YYCommonCellLeftMargin*2);
    }];
    
    [reasonView1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tip.bottom).offset(YYCommonCellLeftMargin*2);
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.right.equalTo(self.view.right).offset(-YYCommonCellLeftMargin*2);
        make.height.equalTo(30);
    }];
    
    [reasonView2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(reasonView1.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(reasonView1);
        make.height.equalTo(30);
    }];
    
    [reasonView3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(reasonView2.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(reasonView1);
        make.height.equalTo(30);
    }];
    
    [reasonView4 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(reasonView3.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(reasonView1);
        make.height.equalTo(30);
    }];
    
    [other makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(reasonView4.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(-YYCommonCellLeftMargin*2);
        make.height.equalTo(30);
    }];
    
    [textView  makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(other.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(reasonView1);
        make.height.equalTo(100);
    }];
    
    [commit makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(YYCommonCellLeftMargin*2);
        make.top.equalTo(textView.bottom).offset(YYCommonCellLeftMargin*2);
        make.right.equalTo(reasonView1);
        make.height.equalTo(40);
    }];
    
}


#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 提交修改意见*/
- (void)commitSuggestion:(UIButton *)sender {
    
    
    if (!_canCommit && !self.textView.text.length && [self.textView.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"至少选择一项原因！"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    if (!self.isNeverCommited) {
        [self alertUser];
        return;
    }
    
    YYWeakSelf
    [SVProgressHUD showWithStatus:@"正在提交。。。"];
    _reasonStr = [self.reasonArr componentsJoinedByString:@","];
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,self.orderId,@"orderid",_reasonStr,@"numres",self.textView.text,@"res", nil];
    
    [YYHttpNetworkTool GETRequestWithUrlstring:cancelOrderUrl parameters:para success:^(id response) {
        
        [SVProgressHUD dismissWithDelay:1 completion:^{
            //成功请求后台，得到反馈，这时回调给订单列表界面，改变订单的推定状态
            if (weakSelf.backSucceedBlock) {
                weakSelf.backSucceedBlock(weakSelf.orderId);
            }
            [weakSelf backSucceed];
        }];
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
    } showSuccessMsg:nil];
}


- (void)backSucceed {
    
    YYBackOrderSucceedController *backSucceedController = [[YYBackOrderSucceedController alloc] init];
    [self.navigationController pushViewController:backSucceedController animated:YES];
}

- (void)alertUser {
    
    YYWeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的申请已提交，稍后会有客服人员与您联系，请保持通讯畅通" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- lazyMethods 懒加载区域  --------------------------

- (NSMutableArray *)reasonArr{
    if (!_reasonArr) {
        _reasonArr = [NSMutableArray array];
    }
    return _reasonArr;
}



@end
