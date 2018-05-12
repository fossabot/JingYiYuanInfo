//
//  YYNiuManHeader.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/11.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYNiuManHeader.h"
#import "NSString+Size.h"
#import "YYUser.h"

@interface YYNiuManHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followValueBtn;

@property (weak, nonatomic) IBOutlet UIButton *hotValueBtn;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;



@end

@implementation YYNiuManHeader
{
    NSAttributedString *_attrStr;
    BOOL _followState;
}
+ (instancetype)headerView {
    YYNiuManHeader *header = [[NSBundle mainBundle] loadNibNamed:@"NiuManHeader" owner:nil options:nil].firstObject;
    return header;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (IBAction)closeOrOpen:(UIButton *)sender {
    
    CGFloat height =  self.bounds.size.height;

    CGSize size = [_attrStr boundingRectWithSize:CGSizeMake(kSCREENWIDTH-60, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;

    CGFloat sub = size.height-10;
    sender.selected = !sender.isSelected;
    if (size.height <= 18) {
        return;
    }
    if (sender.isSelected) {
        height += sub;
    }else {
        height -= sub;
    }
    self.openOrCloseBlock(sender.isSelected,height);
    
//    self.bounds = CGRectMake(0, 0, width, height);
}

#pragma mark -- inner Methods 自定义方法  -------------------------------

/** 更改关注数*/
- (void)changeFollowValue:(NSInteger)follow {
    
    NSInteger followValue = [self.followVlaue integerValue];
    self.followVlaue = [NSString stringWithFormat:@"%ld",followValue+follow];
    [self.followValueBtn setTitle:self.followVlaue forState:UIControlStateNormal];
    if (self.focusChangedBlock) {
        self.focusChangedBlock(self.followVlaue);
    }
}

/**
 *  关注牛人
 */
- (IBAction)focus:(UIButton *)sender {
    
    //  info=  1查询时候标识已经关注/添加时候表示成功 0未关注/添加失败
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        [SVProgressHUD showErrorWithStatus:@"未登录账户"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    YYWeakSelf
    NSDictionary *para = nil;
    if (!_followState) {
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"add",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[@"info"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                    [weakSelf changeFollowValue:1];
                    sender.selected = YES;
                    _followState = YES;
                }else if([response[@"info"] isEqualToString:@"1"]){
                    [SVProgressHUD showErrorWithStatus:@"文章错误或者牛人不存在"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
            
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
    }else {
        
        para = [NSDictionary dictionaryWithObjectsAndKeys:@"delbyniuid",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
        
        [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
            
            if (response) {
                if ([response[STATE] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"取消关注"];
                    [weakSelf changeFollowValue:-1];
                    sender.selected = NO;
                    _followState = NO;
                }else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
                [SVProgressHUD dismissWithDelay:1];
            }
            
        } failure:^(NSError *error) {
            
        } showSuccessMsg:nil];
        
    }
    
}


//检查关注牛人状态
- (void)checkFollowState {
    
    YYUser *user = [YYUser shareUser];
    if (!user.isLogin) {
        return;
    }
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"quebyniuid",@"act",user.userid,USERID,self.niu_id,@"niu_id", nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:subscribdNiuUrl parameters:para success:^(id response) {
        
        if (response) {
            if ([response[@"info"] isEqualToString:@"1"]) {
                self.focusBtn.selected = YES;
                _followState = YES;
            }else {
                _followState = NO;
            }
        }
    } failure:^(NSError *error) {
        
    } showSuccessMsg:nil];
}



#pragma mark ------- setter


- (void)setIcon:(NSString *)icon {
    _icon = icon;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:imageNamed(placeHolderAvatar)];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}


- (void)setFollowVlaue:(NSString *)followVlaue {
    
    _followVlaue = followVlaue;
    [self.followValueBtn setTitle:followVlaue forState:UIControlStateNormal];
}

- (void)setHotVlaue:(NSString *)hotVlaue {
    _hotVlaue = hotVlaue;
    [self.hotValueBtn setTitle:hotVlaue forState:UIControlStateNormal];
    
}

- (void)setIntroduce:(NSString *)introduce {
    
    _introduce = introduce;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:introduce attributes:@{NSFontAttributeName:sysFont(15),NSForegroundColorAttributeName:WhiteColor}];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = imageNamed(@"niumanintroduce");
    attachment.bounds = CGRectMake(0, 0, 15, 14);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrString insertAttributedString:imageAttr atIndex:0];
    
    _attrStr = attrString;
//    self.introduceLabel.attributedText = attrString;
    
}




@end
