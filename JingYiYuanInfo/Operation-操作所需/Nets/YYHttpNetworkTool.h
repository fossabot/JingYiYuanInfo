//
//  YYHttpNetworkTool.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/31.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, YYHttpMethodType) {
    YYHttpMethodTypeGet = 0, //get请求
    YYHttpMethodTypePost     //post请求
};


@interface YYHttpNetworkTool : NSObject

/**
 通用的http请求方法

 @param url 请求路径
 @param para 请求参数
 @param type 请求类型
 @param success 返回值block
 @param failure 失败block
 @param successMsg 请求成功后提醒的文字，nil时默认不提醒
 */
+ (void)RequestWithUrlstring:(NSString *)url
                  parameters:(NSDictionary *)para
              httpMethodType:(YYHttpMethodType)type
                     success:(void(^)(id response))success
                     failure:(void(^)(NSError *error))failure
              showSuccessMsg:(NSString *)successMsg;

/**
 上传图片的http请求方法

 @param url 请求路径
 @param para 请求参数
 @param image 图片文件
 @param serverName 服务器图片请求的参数
 @param savedName 服务器保存图片用到文件名
 @param progress 上传进度 bytesProgress：每次上传的大小  totalBytesProgress：文件总大小
 @param success 返回值
 @param failure 失败返回
 @param successMsg 请求成功后提醒的文字，nil时默认不提醒
 */
+ (void)UPLOADFileWithUrlstring:(NSString *)url
                     parameters:(NSDictionary *)para
                          image:(UIImage *)image
                     serverName:(NSString *)serverName
                      savedName:(NSString *)filename
                       progress:(void (^)(int64_t bytesProgress,
                                          int64_t totalBytesProgress))progress
                        success:(void(^)(id response))success
                        failure:(void(^)(NSError *error))failure
                 showSuccessMsg:(NSString *)successMsg;

/**
 get请求

 @param url 请求路径
 @param para 请求参数
 @param success 返回值
 @param failure 失败返回
 @param successMsg 请求成功后提醒的文字，nil时默认不提醒
 */
+ (void)GETRequestWithUrlstring:(NSString *)url
                     parameters:(NSDictionary *)para
                        success:(void(^)(id response))success
                        failure:(void(^)(NSError *error))failure
                 showSuccessMsg:(NSString *)successMsg;

/**
 post请求

 @param url 请求路径
 @param para 请求参数
 @param success 返回值
 @param failure 失败返回
 @param successMsg 请求成功后提醒的文字，nil时默认不提醒
 */
+ (void)POSTRequestWithUrlstring:(NSString *)url
                      parameters:(NSDictionary *)para
                         success:(void(^)(id response))success
                         failure:(void(^)(NSError *erro))failure
                  showSuccessMsg:(NSString *)successMsg;


+ (void)globalNetStatusNotice:(void(^)(AFNetworkReachabilityStatus status))notice;

@end
