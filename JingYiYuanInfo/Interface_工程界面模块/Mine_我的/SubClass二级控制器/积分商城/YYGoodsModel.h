//
//  YYGoodsModel.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2017/9/26.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYGoodsModel : NSObject


/** 
 
 "id": "12",
 "pro_name": "锤子 坚果Pro 64GB",
 "pro_picture": "http://img13.360buyimg.com/n1/s450x450_jfs/t3259/201/4085616080/243767/3160656a/57fe0be8N942e3b6c.jpg",
 "pro_category": "推荐",
 "pro_state": "上架",
 "pro_label": "推荐",
 "pro_originalprice": "3321",
 "pro_presentprice": "2321",
 "pro_stock": "321",
 "pro_introduce": "\r\n 商品名称：锤子坚果Pro\r\n 商品编号：4086221\r\n 商品毛重：440.00g\r\n 商品产地：中国大陆\r\n 机身内存：64GB\r\n 运行内存：4GB\r\n",
 "pro_process": "(注:如厂家在商品介绍中有售后保障的说明,则此商品按照厂家说明执行售后保障服务。) ",
 "pro_notice": "注：因厂家会在没有任何提前通知的情况下更改产品包装、产地或者一些附件，本司不能确保客户收到的货物与商城图片、产地、附件说明完全一致。只能确保为原厂正货！并且保证与当时市场上同样主流新品一致。若本商城没有及时更新，请大家谅解！",
 "pro_midtime": "2017-07-21"
 
 */

/** goodsId*/
@property (nonatomic, copy) NSString *goodsId;

/** pro_name*/
@property (nonatomic, copy) NSString *pro_name;

/** pro_picture*/
@property (nonatomic, copy) NSString *pro_picture;

/** pro_category*/
@property (nonatomic, copy) NSString *pro_category;

/** pro_state*/
@property (nonatomic, copy) NSString *pro_state;

/** pro_label*/
@property (nonatomic, copy) NSString *pro_label;

/** pro_originalprice*/
@property (nonatomic, copy) NSString *pro_originalprice;

/** pro_presentprice*/
@property (nonatomic, copy) NSString *pro_presentprice;

/** pro_stock*/
@property (nonatomic, copy) NSString *pro_stock;

/** webUrl*/
@property (nonatomic, copy) NSString *webUrl;

@end
