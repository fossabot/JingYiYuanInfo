//
//  TextFilter.h
//
//  Created by yangqi on 13-12-2.
//  Copyright (c) 2013年 yangqi. All rights reserved.
///  一个可以为UITextField设置输入限制的类(限制输入字符，数字，金额，汉字，长度，另外可标记特殊字符“_.-”等)

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#define PROPERTY_WEAK weak
#else
#define PROPERTY_WEAK assign
#endif

//使用TextFilter设置输入限制后，将无法再使用UITextFieldDelegate捕捉输入事件；
//这时可以使用YYTextFilterDelegate。
@protocol YYTextFilterDelegate <NSObject>
@optional
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
@end






@interface YYTextFilter : NSObject<UITextFieldDelegate>
{
    id<YYTextFilterDelegate> textFilterDelegate;
    int  MaxLen;
    BOOL AllowNum;
    BOOL AllowCH;
    BOOL AllowLetter;
    BOOL AllowLETTER;
    BOOL AllowSymbol;
    NSString *OtherString;
    
    NSInteger m_max_number;//最大数值
    CGFloat m_max_money;//判断金额时的最大金额
    BOOL m_only_number;//仅仅是数字的模式（只准输入正整数）
    BOOL m_money_mode; //置为YES时为判断金额的模式
    BOOL m_count_CH_len; //置为YES时将中文统计为2个字符，否则为一个
}
@property (PROPERTY_WEAK, nonatomic) id<YYTextFilterDelegate> textFilterDelegate;
@property (assign, nonatomic) int  MaxLen;
@property (assign, nonatomic) BOOL AllowNum;
@property (assign, nonatomic) BOOL AllowCH;
@property (assign, nonatomic) BOOL AllowLetter;
@property (assign, nonatomic) BOOL AllowLETTER;
@property (assign, nonatomic) BOOL AllowSymbol;
@property (strong, nonatomic) NSString *OtherString;

//为一个UITextField设置输入限制。
- (void)SetFilter:(UITextField *)textField
         delegate:(id<YYTextFilterDelegate>)delegate
           maxLen:(int)maxLen
         allowNum:(BOOL)allowNum
          allowCH:(BOOL)allowCH
      allowLetter:(BOOL)allowLetter
      allowLETTER:(BOOL)allowLETTER
      allowSymbol:(BOOL)allowSymbol
      allowOthers:(NSString *)otherString;

//maxCHLen:最大输入长度，中文算2个字符
- (void)SetFilter:(UITextField *)textField
         delegate:(id<YYTextFilterDelegate>)delegate
         maxCHLen:(int)maxLen
         allowNum:(BOOL)allowNum
          allowCH:(BOOL)allowCH
      allowLetter:(BOOL)allowLetter
      allowLETTER:(BOOL)allowLETTER
      allowSymbol:(BOOL)allowSymbol
      allowOthers:(NSString *)otherString;

//对于一个想作为金额输入的UITextField，使用这个方法。
- (void)SetMoneyFilter:(UITextField *)textField maxMoney:(CGFloat)maxMoney
              delegate:(id<YYTextFilterDelegate>)delegate;

//设置一个只能输入数字并且可以设置数字最大数值的TextFilter
- (void)setNumberfilter:(UITextField *)textField maxNum:(NSInteger)maxNum delegate:(id<YYTextFilterDelegate>)delegate;

@end

@interface YYTextFilter()
-  (int)lengthWithCH:(NSString *)strtemp;
@end
