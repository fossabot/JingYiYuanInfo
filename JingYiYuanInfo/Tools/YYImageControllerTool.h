//
//  YYImageControllerTool.h
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageControllerBlock)(UIImage *image);

@interface YYImageControllerTool : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** imageContrllerDelegate*/
@property (nonatomic, copy) ImageControllerBlock imageControllerBlock;

+ (void)awakeImagePickerControllerCompletion:(ImageControllerBlock)completion;

@end
