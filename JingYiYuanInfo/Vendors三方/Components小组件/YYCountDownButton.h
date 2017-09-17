//
//  YYCountDownButton.h
//  YYCountDownButton
//
//

#import <UIKit/UIKit.h>

@interface YYCountDownButton : UIButton


/**
 *  开始倒计时
 *
 *  @param startTime  倒计时时间
 *  @param unitTitle  倒计时时间单位（如：s）
 *  @param completion 倒计时结束执行的Block
 */
- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(void(^)(YYCountDownButton *countDownButton))completion;

@end
