//
//  macro.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/22.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//
/**
 *  宏的用法： 一般字符串抽成宏，代码抽成宏使用。
 *  const用法：一般常用的字符串定义成const（对于常量字符串苹果推荐我们使用const）。
 *  宏与const区别：
 *  1.编译时刻不同，宏属于预编译 ，const属于编译时刻
 *  2.宏能定义代码，const不能，多个宏对于编译会相对时间较长，影响开发效率，调试过慢，const只会编译一次，缩短编译时间。
 *  3.宏不会检查错误，const会检查错误
*/

#ifndef macro_h
#define macro_h

//————————————————————————————————   常用颜色宏定义  ——————————————————————————————————————————----
//颜色的宏定义设置
#define YYRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define YYRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
//随机色
#define YYRandomColor HBRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define YYRGBCOLOR_HEX(hexColor) [UIColor colorWithRed: (((hexColor >> 16) & 0xFF))/255.0f         \
green: (((hexColor >> 8) & 0xFF))/255.0f          \
blue: ((hexColor & 0xFF))/255.0f                 \
alpha: 1]

//灰色，等常用颜色宏定义
#define GRAYTEXTCOLOR YYRGBCOLOR_HEX(0x7b7b7b)
#define ButtonNormalColor YYRGBCOLOR_HEX(0x67d2ca)

//新闻标题的文字颜色
#define NewsTextColor [UIColor darkTextColor]
#define NewsTextFont [UIFont systemFontOfSize:14]

//新闻附属的来源，时间，点击量的label颜色及字体
#define NewsSubtextColor [UIColor grayColor]
#define NewsSubtextFont  [UIFont systemFontOfSize:12]


//屏幕高
#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width

//弱引用
#define YYWeakSelf  __weak typeof(self) weakSelf = self;
//强引用
#define YYStrongSelf  __strong typeof(self) strongSelf = weakSelf;

//---------------------------------  常用的一些单例宏  -----------------------------------------------
///通知中心
#define kNotificationCenter [NSNotificationCenter defaultCenter]
///application单例
#define kApplication        [UIApplication sharedApplication]
///keywindow单例
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
///主屏幕单例
#define kMainScreen         [UIScreen mainScreen]
///APPdelegate
#define kAppDelegate        [UIApplication sharedApplication].delegate
///Userdefaults
#define kUserDefaults      [NSUserDefaults standardUserDefaults]

///APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
///系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]


//自定义视图的圆角（视图，半径）
#define YYViewBorderRadiusSimple(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];

//自定义视图的圆角（视图，半径，边框宽度，边框颜色）
#define YYViewBorderRadiusComplex(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//——————————————————————————————   文件路径获取    ——————————————————————————————————————
///获取temp路径
#define kPathTemp NSTemporaryDirectory()

///获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

///获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

///拨打客服电话☎️
#define clientHelper @"tel://010-87777077"


/*
 *  根据当前view 找所在tableview 里的 indexpath
 */
#define INDEXPATH_SUBVIEW_TABLEVIEW(subview,tableview)\
({\
CGRect subviewFrame = [subview convertRect:subview.bounds toView:tableview];\
NSIndexPath *tabIndexPath = [tableview indexPathForRowAtPoint:subviewFrame.origin];\
tabIndexPath;\
})\

/*
 *   根据当前view 找所在collectionview 里的 indexpath
 */
#define INDEXPATH_SUBVIEW_COLLECTION(subview,collectionview)\
({\
CGRect subviewFrame = [subview convertRect:subview.bounds toView:collectionview];\
NSIndexPath *tabIndexPath = [collectionview indexPathForItemAtPoint:subviewFrame.origin];\
tabIndexPath;\
})\


/*
 *   根据当前view 找所在tableview 里的 tableviewcell
 */
#define CELL_SUBVIEW_TABLEVIEW(subview,tableview)\
({\
CGRect subviewFrame = [subview convertRect:subview.bounds toView:tableview];\
NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:subviewFrame.origin];\
UITableViewCell *tabCell  = [tableview cellForRowAtIndexPath:indexPath];\
tabCell;\
})\

//  —————————————   NSUserDefault常用的常量宏 key<----->value  --——————————

#define LOGINSTATUS  @"loginStatus"//判断登录状态的宏

#define LASTAPPVERSION  @"lastAppVersion" //本地存储最新版本的APP版本号

#define NETERRORMSG  @"网络在开小差"  ///错误提示宏

#define SIGNDAYS  @"signDays" //签到天数的宏


#endif /* macro_h */
