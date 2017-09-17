//
//  YYHttpNetworkTool.m
//  壹元服务
//
//  Created by VINCENT on 2017/3/31.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYHttpNetworkTool.h"
#import "AFNetworking.h"


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
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络在开小差，请稍后再试"];
    }];
    
}


/** post请求*/
+ (void)POSTRequestWithUrlstring:(NSString *)url
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
    [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络在开小差，请稍后再试"];
    }];
    
}

/** 上传图片请求*/
+ (void)UPLOADFileWithUrlstring:(NSString *)url
                     parameters:(NSDictionary *)para
                          image:(UIImage *)image
                     serverName:(NSString *)serverName
                      savedName:(NSString *)savedName
                       progress:(void (^)(int64_t bytesProgress,
                                          int64_t totalBytesProgress))progress
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *))failure
                 showSuccessMsg:(NSString *)successMsg{
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:para  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * imageFileName = savedName;
        if (savedName == nil || ![savedName isKindOfClass:[NSString class]] || savedName.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        [formData appendPartWithFileData:UIImagePNGRepresentation(image)   name:serverName   fileName:imageFileName   mimeType:@"image/png,image/jpg,image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YYLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (success) {
            
            if (successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            success(dic);   
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:@"网络在开小差，请稍后再试"];
    }];
    
}


/** 
 全局的网络监测,是否在WiFi环境下，会返回bool值
 */
+ (BOOL)globalNetStatusNotice{
    
    
    __block BOOL isWIFI = nil;  //是否是运营商网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                YYLog(@"未知网络");
                [SVProgressHUD showInfoWithStatus:@"未知网络"];
                isWIFI = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                
                UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无网络" message:@"当前网络出错，请前往设置检查网络" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *urlString = [NSURL URLWithString:@"prefs:root=General"];
                    if([[UIApplication sharedApplication] canOpenURL:urlString]){
                        [[UIApplication sharedApplication] openURL:urlString];
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    YYLog(@"点击了取消");
                }]];
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    
                    [vc presentViewController:alert animated:YES completion:nil];
                });
                YYLog(@"没有网络");
            }
                isWIFI = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                YYLog(@"WiFi网络");
                [SVProgressHUD showInfoWithStatus:@"已切换至WiFi网络"];
                isWIFI = YES;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                YYLog(@"运营商网络");
                [SVProgressHUD showInfoWithStatus:@"已切换至运营商网络"];
                isWIFI = NO;
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
    return isWIFI;
    
}



@end
