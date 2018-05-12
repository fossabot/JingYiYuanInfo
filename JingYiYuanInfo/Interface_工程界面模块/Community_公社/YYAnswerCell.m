//
//  YYAnswerCell.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/27.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYAnswerCell.h"
#import "UIView+YYCategory.h"
#import "YYAnswerModel.h"
#import "YYUser.h"

@interface YYAnswerCell ()



@end

@implementation YYAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configSubView];
        [self masonrySubviews];
        [self.icon cutCornerRect:CGRectMake(0, 0, 30, 30) radius:15];
    }
    return self;
}

- (void)setModel:(YYAnswerModel *)model {
    
    _model = model;
    self.question.text = model.qucotent;
    self.niuMan.text = self.niuManName;
    self.answer.text = model.content;
    
    if (model.content.length > 0) {
        YYLog(@"有答案model   ---  问题%@  ----  答案%@ ",model.qucotent,model.content);
        self.niuMan.text = self.niuManName;
        self.answer.text = model.content;

        [self.bgView remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.name);
            make.top.equalTo(self.question.bottom).offset(15);
            make.right.equalTo(-14);
        }];
        
    }else {

        YYLog(@"没有答案model   ---  问题%@  ----  答案%@ ",model.qucotent,model.content);
        //没数据时
        self.niuMan.text = @"";
        self.answer.text = @"";

        [self.bgView remakeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.question.bottom).offset(5);
            make.height.equalTo(0);
        }];

    }
    
    self.time.text = model.posttime;
    
}

/**
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_model.content.length > 0) {
        YYLog(@"有答案model   ---  问题%@  ----  答案%@ ",_model.qucotent,_model.content);
//        self.niuMan.text = self.niuManName;
//        self.answer.text = _model.content;
        
//        [self.name updateConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(10);
//        }];
        
        [self.bgView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.name);
            make.top.equalTo(self.question.bottom).offset(15);
            make.right.equalTo(-14);
            
        }];
        
        [self.time updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.bgView.bottom).offset(12);
        }];
    }else {
        
        YYLog(@"没有答案model   ---  问题%@  ----  答案%@ ",_model.qucotent,_model.content);
        //没数据时
//        self.niuMan.text = @"";
//        self.answer.text = @"";
        
        [self.bgView remakeConstraints:^(MASConstraintMaker *make) {
            
            //            make.left.equalTo(self.name);
            //            make.top.equalTo(self.question.bottom).offset(15);
            //            make.right.equalTo(-14);
            make.height.equalTo(0);
        }];
        
        [self.time updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.question.bottom).offset(12);
        }];
    }
    
}
*/

- (void)configSubView {
    
    YYUser *user = [YYUser shareUser];
    UIImageView *icon = [[UIImageView alloc] init];
    [icon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:imageNamed(placeHolderAvatar)];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    UILabel *name = [[UILabel alloc] init];
    name.text = user.username;
    name.textColor = SubTitleColor;
    name.font = SubTitleFont;
    self.name = name;
    [self.contentView addSubview:name];
    
    UILabel *question = [[UILabel alloc] init];
    question.textColor = TitleColor;
    question.font = shabiFont5;
    self.question = question;
    [self.contentView addSubview:question];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = YYRGB(245, 245, 245);
    bgView.layer.cornerRadius = 3;
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
    
    UILabel *niuMan = [[UILabel alloc] init];
    niuMan.font = SubTitleFont;
    niuMan.textColor = SubTitleColor;
    self.niuMan = niuMan;
    [self.bgView addSubview:niuMan];
    
    UILabel *answer = [[UILabel alloc] init];
    answer.numberOfLines = 0;
    answer.font = shabiFont3;
    answer.textColor = LightSubTitleColor;
    self.answer = answer;
    [self.bgView addSubview:answer];
    
    UILabel *time = [[UILabel alloc] init];
    time.numberOfLines = 0;
    time.font = UnenableTitleFont;
    time.textColor = LightSubTitleColor;
    self.time = time;
    [self.contentView addSubview:time];
    
}

- (void)masonrySubviews {
    
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(14);
        make.top.equalTo(10);
        make.width.height.equalTo(30);
    }];
    
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(13);
        make.left.equalTo(self.icon.right).offset(11);
    }];
    
    [self.question makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.name.bottom).offset(11);
        make.left.equalTo(self.name);
        make.right.equalTo(-15);
    }];
    
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.name);
        make.top.equalTo(self.question.bottom).offset(15);
        make.right.equalTo(-14);
    }];
    
    [self.niuMan makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bgView).offset(12);
        make.top.equalTo(self.bgView).offset(10);
    }];
    
    [self.answer makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.niuMan);
        make.left.equalTo(self.niuMan.right).offset(11);
        make.right.equalTo(self.bgView.right).offset(-12);
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
    }];
    
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgView.bottom).offset(12);
        make.left.equalTo(self.name);
        make.bottom.equalTo(-16);
    }];
    
}

@end
