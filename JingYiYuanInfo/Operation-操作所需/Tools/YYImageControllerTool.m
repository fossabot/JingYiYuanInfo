//
//  YYImageControllerTool.m
//  壹元服务
//
//  Created by VINCENT on 2017/8/28.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "YYImageControllerTool.h"

@interface YYImageControllerTool()

/** _imageController*/
@property (nonatomic, strong) UIImagePickerController *imageController;

@end

@implementation YYImageControllerTool
{
//    UIImagePickerController *_imageController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)awakeImagePickerControllerWithDelegate:(id)delegate {
    
    YYImageControllerTool *tool = [[YYImageControllerTool alloc] init];
    [tool awakeAlert];
    tool.imageController = [[UIImagePickerController alloc] init];
    tool.imageController.delegate = delegate;
    tool.imageController.allowsEditing = YES;

}

+ (void)awakeImagePickerControllerCompletion:(ImageControllerBlock)completion {
    YYImageControllerTool *tool = [[YYImageControllerTool alloc] init];
    tool.imageControllerBlock = completion;
    [tool awakeAlert];
}

/** 唤起actionsheet*/
- (void)awakeAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if ([self isCameraAvailable]) {
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self awakeImagePickerContrllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alert addAction:camera];
    }
    
    if ([self isPhotoLibraryAvailable]) {
        
        UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self awakeImagePickerContrllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alert addAction:photoLibrary];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:cancel];
    [kKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

/** 唤起摄像头或相册*/
- (void)awakeImagePickerContrllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    self.imageController.sourceType = sourceType;
    [kKeyWindow.rootViewController presentViewController:self.imageController animated:YES completion:nil];
    
}

/** 判断设备是否有摄像头*/
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/** 相册是否可用*/
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

/** 选中图片的回调*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(editImage, 1.0);
    while (imageData.length > 1024*1024) {
        imageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.5);
    }
    
    if (_imageControllerBlock) {
        _imageControllerBlock([UIImage imageWithData:imageData]);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    UIImage *editImage = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(editImage, 1.0);
    while (imageData.length > 1024*1024) {
        imageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.5);
    }
    
    if (_imageControllerBlock) {
        _imageControllerBlock([UIImage imageWithData:imageData]);
    }

}


@end
