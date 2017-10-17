//
//  YYHttpNetworkTool.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/31.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHttpNetworkTool.h"


@implementation YYHttpNetworkTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)RequestWithUrlstring:(NSString *)url
                  parameters:(NSDictionary *)para
              httpMethodType:(YYHttpMethodType)type
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *))failure showSuccessMsg:(NSString *)successMsg {
    switch (type) {
        case YYHttpMethodTypeGet:
            [self GETRequestWithUrlstring:url parameters:para success:success failure:failure showSuccessMsg:successMsg];
            break;
            
        case YYHttpMethodTypePost:
            [self POSTRequestWithUrlstring:url parameters:para success:success failure:failure showSuccessMsg:successMsg];
            
        default:
            break;
    }
}


/** get请求*/
+(void)GETRequestWithUrlstring:(NSString *)url
                    parameters:(NSDictionary *)para
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *))failure
                showSuccessMsg:(NSString *)successMsg {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
//        manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 5;
    [manager GET:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
                [SVProgressHUD dismissWithDelay:1];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        YYLog(@"开小差的网络 --- --- %@%@",url,para);
        [SVProgressHUD showErrorWithStatus:@"网络在开小差，请稍后再试"];
        [SVProgressHUD dismissWithDelay:2];
    }];
    
}


/** post请求*/
+ (void)POSTRequestWithUrlstring:(NSString *)url
                      parameters:(NSDictionary *)para
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *))failure
                  showSuccessMsg:(NSString *)successMsg {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    /**
     *  请求队列的最大并发数
     */
    //        manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 5;
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
                [SVProgressHUD dismissWithDelay:1];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络在开小差，请稍后再试"];
        [SVProgressHUD dismissWithDelay:2];
    }];
    
}

/** 上传图片请求*/
+ (void)UPLOADFileWithUrlstring:(NSString *)url
                     parameters:(NSDictionary *)para
                          image:(UIImage *)image
                     serverName:(NSString *)serverName
                      savedName:(NSString *)filename
                       progress:(void (^)(int64_t bytesProgress,
                                          int64_t totalBytesProgress))progress
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *))failure
                 showSuccessMsg:(NSString *)successMsg{
 
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    AFHTTPSessionManager *manager = [self getAFManager];
    //压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [manager POST:url parameters:para  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
//        [formData appendPartWithFileData:UIImagePNGRepresentation(image)   name:serverName   fileName:imageFileName   mimeType:@"image/png,image/jpg,image/jpeg"];

        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:serverName fileName:imageFileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YYLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (success) {
            
            if (successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
                [SVProgressHUD dismissWithDelay:1];
            }
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([responseObject[@"state"] isEqualToString:@"1"]) {
                
                [[SDImageCache sharedImageCache] removeImageForKey:responseObject[@"userhead"] withCompletion:nil];
                success(responseObject);
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        [SVProgressHUD dismissWithDelay:1];
    }];
    
//    [task resume];
}


/** 
 全局的网络监测,是否在WiFi环境下，会返回bool值
 */
+ (void)globalNetStatusNotice:(void (^)(AFNetworkReachabilityStatus))notice {
    
    //是否是运营商网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                YYLog(@"未知网络");
//                [SVProgressHUD showInfoWithStatus:@"未知网络"];
                notice(AFNetworkReachabilityStatusUnknown);
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                
                notice(AFNetworkReachabilityStatusNotReachable);
                YYLog(@"没有网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                YYLog(@"WiFi网络");
//                [SVProgressHUD showInfoWithStatus:@"已切换至WiFi网络"];
                notice(AFNetworkReachabilityStatusReachableViaWiFi);

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                YYLog(@"运营商网络");
//                [SVProgressHUD showInfoWithStatus:@"已切换至运营商网络"];
                notice(AFNetworkReachabilityStatusReachableViaWWAN);
                
                break;
                
            default:
                notice(AFNetworkReachabilityStatusNotReachable);
                break;
        }
    }];
}


+(AFHTTPSessionManager *)getAFManager{
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval=10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    return manager;
    
}

@end
