//
//  YYIAPTool.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYIAPTool.h"
#import "YYUser.h"
#import "YYDataBaseTool.h"
#import "YYLoginManager.h"

#import "NSString+Base64.h"

@implementation YYIAPTool

+ (void)printReceipt{
    
    // 这个 receipt 就是内购成功 苹果返回的收据
    NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptBase64 = [NSString base64StringFromData:receipt length:[receipt length]];
    YYLog(@"receiptBase64 - -- - %@",receiptBase64);
}


/** 购买产品  通过产品id(通常为产品id一般为你工程的 Bundle ID + 功能 + 数字，ps:com.yyinfo)  需与iTunes connect 产品ID后台一致  productType   商品类型1会员2特色3三找4积分*/
+ (void)buyProductByProductionId:(NSString *)productionId type:(NSString *)productType{
    
//    [SVProgressHUD showWithStatus:@"购买时请不要关闭应用..."];
    
    YYUser *user = [YYUser shareUser];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:productionId,@"productid",productType,@"type",user.userid,USERID, nil];
    [YYHttpNetworkTool GETRequestWithUrlstring:preIapOrderUrl parameters:para success:^(id response) {
        YYLog(@"response %@",response[@"state"]);
        if (response && ![response[@"state"] isEqualToString:@"0"]) {
        
            [self buyProduct:productionId];
            YYLog(@"生成预支付订单成功");
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后重试"];
            [SVProgressHUD dismissWithDelay:1];
            YYLog(@"生成预支付订单失败");
        }
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后重试"];
        [SVProgressHUD dismissWithDelay:1];
    } showSuccessMsg:nil];
    
    
}

+ (void)buyProduct:(NSString *)productionId {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    // ProductID_diamond1 我这里是宏，产品id一般为你工程的 Bundle ID+数字
    // 我这里是6个内购的商品
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productionId,nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    //yes为生产环境  no为沙盒测试模式
    // 客户端做收据校验有用  服务器做收据校验忽略...
    [IAPShare sharedHelper].iap.production = NO;
    
    // 请求商品信息
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         
         if(response.products.count > 0 ) {
             //取出第一件商品id
             SKProduct *product = response.products[0];
             
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            
//                                            [[SKPaymentQueue defaultQueue] finishTransaction:trans];
                                           //存储交易数据，无论返回的是成功与失败，先存储，再改变交易状态，如果交易失败也改变state变为2，下次不可再次交易，只能产生新的交易，交易成功state变为1，默认状态是未支付，为0.
                                            
                                            if(trans.error)
                                            {
                                                
                                                [SVProgressHUD dismissWithDelay:1];
                                                YYLog(@"Fail  ????  %@",[trans.error localizedDescription]);
                                                
                                            }else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                YYLog(@"走了自定义支付工具类的成功回调");
//                                                [self showAlertWithTitle:@"购买成功,内购同步可能较慢，请您耐心等待，如有问题，请致电客服"];
                                                // 这个 receipt 就是内购成功 苹果返回的收据
//                                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                
                                                /******这里我将receipt base64加密，把加密的收据 和 产品id，一起发送到app服务器********/
#warning 等待后台提供传输加密文件的接口 验证支付结果
//                                                NSString *receiptBase64 = [NSString base64StringFromData:receipt length:[receipt length]];
                                                //
                                                //这里已完成交易，我必须存储交易凭证，病标记为与后台同步的状态，即未完成状态，然后骑牛后台同步信息
//                                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                                                formatter.dateFormat = yyyyMMddHHmmss;
//                                                NSString *now = [formatter stringFromDate:[NSDate date]];
                                                YYUser *user = [YYUser shareUser];
//                                                [[YYDataBaseTool sharedDataBaseTool]saveIapDataWithTransactionIdentifier:trans.transactionIdentifier productIdentifier:productionId userid:user.userid receipt:receiptBase64 good_type:@"1" transactionDate:now rechargeDate:now state:0];
//                                                [self sendReceiptToServer:receiptBase64 paymentTransaction:trans];
                                                /*******上面的sendCheckReceipt请求成功了，会返回用户购买的钻石数量*******/
                                                
                                                //客户端做收据验证 (不建议)
                                                //  [[IAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {
                                                //   NSLog(@"购买验证---%@",response);
                                                //  }];
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                if (trans.error.code == SKErrorPaymentCancelled) {
                                                    [SVProgressHUD showErrorWithStatus:@"您取消了此次购买"];
                                                    
                                                    YYLog(@"SKErrorPaymentCancelled用户取消了购买");
                                                    
                                                }else if (trans.error.code == SKErrorClientInvalid) {
                                                    [SVProgressHUD showErrorWithStatus:@"设备未能发送购买请求"];
                                                    YYLog(@"SKErrorPaymentCancelled设备不允许内购买");
                                                    
                                                }else if (trans.error.code == SKErrorPaymentInvalid) {
                                                    [SVProgressHUD showErrorWithStatus:@""];
                                                    YYLog(@"SKErrorPaymentCancelled用户取消了购买");
                                                    
                                                }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                                                    [SVProgressHUD showErrorWithStatus:@""];
                                                    YYLog(@"SKErrorPaymentCancelled设备未打开内购买权限");
                                                    
                                                }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                                                    [SVProgressHUD showErrorWithStatus:@""];
                                                    YYLog(@"SKErrorStoreProductNotAvailable产品失效");
                                                    
                                                }else{
                                                    [SVProgressHUD showErrorWithStatus:@""];
                                                    YYLog(@"SKErrorPaymentCancelled用户取消了购买");
                                                    
                                                }
                                                [SVProgressHUD dismissWithDelay:1];
                                            }
                                            [SVProgressHUD dismissWithDelay:1];
                                        }];
         }else{
             //  ..未获取到商品
             [self showAlertWithTitle:@"未获取到商品"];
         }
     }];
    
}


+ (void)showAlertWithTitle:(NSString *)title {
    
    [SVProgressHUD showInfoWithStatus:title];
    [SVProgressHUD dismissWithDelay:2];
    
}

//http://yyapp.1yuaninfo.com/app/application/apple_pay.php  name值apple_receipt
//交易成功的方法。交易成功跟后台验证，验证成功才能交这个交易在数据库中删除或者状态变为未完成
+ (void)sendReceiptToServer:(NSString *)base64Str paymentTransaction:(SKPaymentTransaction *)paymentTransaction {
    
    //先存储交易信息，等待后台返回的状态码，如果是是0，改变交易状态为1
//    [[IAPShare sharedHelper].iap provideContentWithTransaction:paymentTransaction];
//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:base64Str,@"name", nil];
    
    BOOL dealState = [[YYDataBaseTool sharedDataBaseTool] checkTransactionDealState:paymentTransaction.transactionIdentifier];
    if (dealState) {
        YYLog(@"该transactionIdentifier交易单号已验证");
        return;
    }
    YYUser *user = [YYUser shareUser];
    [YYHttpNetworkTool POSTRequestWithUrlstring:IAPReceiptUrl parameters:@{@"productid":paymentTransaction.payment.productIdentifier,USERID:user.userid,@"apple_receipt":base64Str} success:^(id response) {
        
        if ([response[@"state"] isEqualToString:@"0"]) {
            YYLog(@"购买成功，并给后台同步返回成功验证");
            //验证成功，返回
            [[YYDataBaseTool sharedDataBaseTool] changeTransactionIdentifierState:paymentTransaction.transactionIdentifier];
            [YYLoginManager getUserInfo];
        }
        YYLog(@"IAP收据验证%@",response);
    } failure:^(NSError *erro) {
        
//        [[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
        YYLog(@"error : %@",erro);
        
    } showSuccessMsg:nil];

}



@end
