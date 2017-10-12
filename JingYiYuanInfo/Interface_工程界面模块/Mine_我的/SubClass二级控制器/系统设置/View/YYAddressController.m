//
//  YYAddressController.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/25.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAddressController.h"
#import "BRAddressPickerView.h"
#import "YYCommentTextView.h"
#import "YYTextFilter.h"

@interface YYAddressController ()<YYTextFilterDelegate,UITextFieldDelegate,UITextViewDelegate>

//@property (nonatomic, strong) BRAddressPickerView *addressPicker;

//白色的背景view
@property (nonatomic, strong) UIView *backView;

//收件人label
@property (nonatomic, strong) UILabel *receivedMan;
//手机label
@property (nonatomic, strong) UILabel *mobile;
//地区label
@property (nonatomic, strong) UILabel *district;

@property (nonatomic, strong) UIView *seperator1;

@property (nonatomic, strong) UIView *seperator2;

@property (nonatomic, strong) UIView *seperator3;

//收件人的输入框
@property (nonatomic, strong) UITextField *receivedManText;
//手机号输入框
@property (nonatomic, strong) UITextField *mobileText;
//地区的输入框
@property (nonatomic, strong) UIButton *districtBtn;
//详细地址的输入框
@property (nonatomic, strong) YYCommentTextView *detailAddressTextView;

/** textField filter*/
@property (nonatomic,strong) YYTextFilter *textFilterPhone;

@end

@implementation YYAddressController
{
    BOOL _isFirstEdit;
    NSString *_provinceCityStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstEdit = YES;
    self.navigationItem.title = @"我的地址";
    self.view.backgroundColor = GrayBackGroundColor;
    
    [self configSubView];
    [self masonrySubView];
    [self configTextFilter];
    [self loadData];
}

- (void)configSubView {
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAddress)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = WhiteColor;
    self.backView = backView;
    [self.view addSubview:backView];
    
    UILabel *receivedMan = [[UILabel alloc] init];
    [receivedMan setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    receivedMan.text = @"收件人";
    receivedMan.textColor = SubTitleColor;
    receivedMan.font = TitleFont;
    self.receivedMan = receivedMan;
    [self.view addSubview:receivedMan];
    
    UITextField *receivedManText = [[UITextField alloc] init];
    receivedManText.delegate = self;
    receivedManText.font = TitleFont;
//    receivedManText.placeholder = @"名称";
    receivedManText.tintColor = ThemeColor;
    self.receivedManText = receivedManText;
    [self.view addSubview:receivedManText];
    
    UIView *seperator1 = [[UIView alloc] init];
    seperator1.backgroundColor = GraySeperatorColor;
    self.seperator1 = seperator1;
    [self.view addSubview:seperator1];
    
    UILabel *mobile = [[UILabel alloc] init];
    [mobile setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    mobile.text = @"联系电话";
    mobile.textColor = SubTitleColor;
    mobile.font = TitleFont;
    self.mobile = mobile;
    [self.view addSubview:mobile];
    
    UITextField *mobileText = [[UITextField alloc] init];
    mobileText.delegate = self;
    mobileText.font = TitleFont;
//    mobileText.placeholder = @"联系电话";
    mobileText.tintColor = ThemeColor;
    self.mobileText = mobileText;
    [self.view addSubview:mobileText];
    
    UIView *seperator2 = [[UIView alloc] init];
    seperator2.backgroundColor = GraySeperatorColor;
    self.seperator2 = seperator2;
    [self.view addSubview:seperator2];
    
    UILabel *district = [[UILabel alloc] init];
    [district setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    district.text = @"所在地区";
    district.textColor = SubTitleColor;
    district.font = TitleFont;
    self.district = district;
    [self.view addSubview:district];
    
    UIButton *districtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    districtBtn.titleLabel.font = TitleFont;
    [districtBtn setTitleColor:UnenableTitleColor forState:UIControlStateNormal];
    [districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [districtBtn addTarget:self action:@selector(chooseDistrict:) forControlEvents:UIControlEventTouchUpInside];
    self.districtBtn = districtBtn;
    [self.view addSubview:districtBtn];
    
    UIView *seperator3 = [[UIView alloc] init];
    seperator3.backgroundColor = GraySeperatorColor;
    self.seperator3 = seperator3;
    [self.view addSubview:seperator3];
    
    YYCommentTextView *detailAddressTextView = [[YYCommentTextView alloc] initWithFrame:CGRectZero PlaceText:@"详细地址" PlaceColor:UnenableTitleColor];
    detailAddressTextView.delegate = self;
    detailAddressTextView.font = TitleFont;
//    detailAddressTextView.placeColor = UnenableTitleColor;
//    detailAddressTextView.placeText = @"详细地址";
    self.detailAddressTextView = detailAddressTextView;
    [self.view addSubview:detailAddressTextView];
    
    
}

//配置子控件的布局
- (void)masonrySubView {
    
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.receivedMan makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(YYInfoCellCommonMargin);
    }];
    
    [self.receivedManText makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.receivedMan.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.receivedMan);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.seperator1 makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.receivedMan.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.receivedMan);
        make.right.equalTo(self.receivedManText);
        make.height.equalTo(0.5);
    }];
    
    [self.mobile makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.seperator1);
        make.top.equalTo(self.seperator1.bottom).offset(YYInfoCellCommonMargin);
    }];
    
    [self.mobileText makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mobile.right).offset(YYInfoCellCommonMargin);
        make.centerY.equalTo(self.mobile);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.seperator2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mobile.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.mobile);
        make.right.equalTo(self.mobileText);
        make.height.equalTo(0.5);
    }];
    
    [self.district makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.seperator2);
        make.top.equalTo(self.seperator2.bottom).offset(YYInfoCellCommonMargin);
    }];
    
    [self.districtBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.district);
        make.right.equalTo(-YYInfoCellCommonMargin);
    }];
    
    [self.seperator3 makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.district.bottom).offset(YYInfoCellCommonMargin);
        make.left.equalTo(self.district);
        make.right.equalTo(self.districtBtn);
        make.height.equalTo(0.5);
    }];
    
    [self.detailAddressTextView makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.seperator3);
        make.top.equalTo(self.seperator3.bottom).offset(YYInfoCellCommonMargin);
        make.right.equalTo(-YYInfoCellCommonMargin);
        make.height.equalTo(80);
        make.bottom.equalTo(self.backView.bottom).offset(-YYInfoCellCommonMargin);
    }];
    
}


- (void)configTextFilter {
    
    self.textFilterPhone = [[YYTextFilter alloc] init];
    [self.textFilterPhone SetFilter:self.mobileText
                           delegate:self
                             maxLen:11
                           allowNum:YES
                            allowCH:NO
                        allowLetter:YES
                        allowLETTER:YES
                        allowSymbol:YES
                        allowOthers:nil];
}


//获取地址   http://yyapp.1yuaninfo.com/app/application/useraddress.php
- (void)loadData {
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"getuseradd",@"act", nil];
    YYWeakSelf
    [YYHttpNetworkTool GETRequestWithUrlstring:addressUrl parameters:para success:^(id response) {
        
        if (response && [response[@"user_add"] firstObject]) {
            
            NSDictionary *addressDic = [response[@"user_add"] firstObject];
            
            _isFirstEdit = NO;
            weakSelf.receivedManText.text = addressDic[@"re_name"];
            weakSelf.mobileText.text = addressDic[@"re_phone"];
            _provinceCityStr = addressDic[@"prov_city"];
            NSArray *districtArr = [_provinceCityStr componentsSeparatedByString:@","];
            NSString *district = [NSString stringWithFormat:@"%@%@%@",districtArr[0],districtArr[1],districtArr[2]];
            [weakSelf.districtBtn setTitle:district forState:UIControlStateNormal];
            if ([addressDic[@"detailed_add"] length]) {
                
                weakSelf.detailAddressTextView.text = addressDic[@"detailed_add"];
                weakSelf.detailAddressTextView.Textnil = NO;
            }
            
        }else {
            
            _isFirstEdit = YES;
        }
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];
}


//保存编辑好的地址信息
- (void)saveAddress {
    
    [self.view endEditing:YES];
    
    if (![self addressShouldSave]) {
        return;
    }
    
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = nil;
    if (_isFirstEdit) {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"addaddr",@"act",_receivedManText.text,@"re_name",_mobileText.text,@"re_phone",_provinceCityStr,@"prov_city",_detailAddressTextView.text,@"detailed_add", nil];
    }else {
        para = [NSDictionary dictionaryWithObjectsAndKeys:user.userid,USERID,@"moduseradd",@"act",_receivedManText.text,@"re_name",_mobileText.text,@"re_phone",_provinceCityStr,@"prov_city",_detailAddressTextView.text,@"detailed_add", nil];
    }
    [YYHttpNetworkTool GETRequestWithUrlstring:addressUrl parameters:para success:^(id response) {
        
        if (response && [response[@"state"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            _isFirstEdit = NO;
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
        [SVProgressHUD dismissWithDelay:1];
        
    } failure:^(NSError *error) {
        
        
    } showSuccessMsg:nil];
}

//选择地区
- (void)chooseDistrict:(UIButton *)sender {
    
    [self.view endEditing:YES];
    YYWeakSelf
    //地址选择器的选择回调
    if (!_isFirstEdit) {
        
        
    }
    
    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@0,@0,@0] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
        
        _provinceCityStr = [NSString stringWithFormat:@"%@,%@,%@",selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
        [weakSelf.districtBtn setTitle:[NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]] forState:UIControlStateNormal];
    }];
    
    
}


//修改过的地址能保存不
- (BOOL)addressShouldSave {
    
    if (!self.receivedManText.text.length) {
        [SVProgressHUD showImage:nil status:@"收件人不能为空"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }
    
    if (self.mobileText.text.length != 11) {
        [SVProgressHUD showImage:nil status:@"手机号格式不正确"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }

    if (!self.districtBtn.titleLabel.text.length) {
        [SVProgressHUD showImage:nil status:@"所在地区不能为空"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }

    if (!self.detailAddressTextView.text.length) {
        [SVProgressHUD showImage:nil status:@"详细地址不能为空"];
        [SVProgressHUD dismissWithDelay:1];
        return NO;
    }

    return YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
