//
//  PhotoCell.m
//  PhotoBrowser
//
//  Created by VINCENT on 2017/9/13.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "PhotoCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface PhotoCell()<UIScrollViewDelegate>

/** scrollView*/
@property (nonatomic, strong) UIScrollView *scrollView;

/** imageView*/
@property (nonatomic, strong) UIImageView *imageView;

/** imgUrl*/
@property (nonatomic, copy) NSString *imgUrl;

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubView];
        
    }
    return self;
}


- (void)configSubView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 3.0;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOther)];
    [scrollView addGestureRecognizer:tap];
    self.scrollView = scrollView;
    [self.contentView addSubview:scrollView];
    
    
}


- (void)hideOther {
    
    if (_tap) {
        _tap();
    }
}

- (void)save {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
 
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:save];
    [alert addAction:cancel];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark 保存图片后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo {
    
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}


- (void)setImgUrl:(NSString *)imgUrl desc:(NSString *)desc total:(NSInteger)total index:(NSInteger)index {
    
    //移除上一个imageView
    [self.imageView removeFromSuperview];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.imageView.frame = [self setImage:image];
        //设置scroll的contentsize的frame
        self.scrollView.contentSize = self.imageView.frame.size;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOther)];
    [self.imageView addGestureRecognizer:tap];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(save)];
    [self.imageView addGestureRecognizer:longPress];
    
}

//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       
                                       scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_tap) {
        _tap();
    }
}

//根据不同的比例设置尺寸
-(CGRect) setImage:(UIImage *)image
{
    
    CGFloat imageX = image.size.width;
    
    CGFloat imageY = image.size.height;
    
    CGRect imgfram;
    
    CGFloat CGscale;
    
    BOOL flx =  (SCREENWIDTH / SCREENHEIGHT) > (imageX / imageY);
    
    if(flx)
    {
        CGscale = SCREENHEIGHT / imageY;
        
        imageX = imageX * CGscale;
        
        imgfram = CGRectMake((SCREENWIDTH - imageX) / 2, 0, imageX, SCREENHEIGHT);
        
        return imgfram;
    }
    else
    {
        CGscale = SCREENWIDTH / imageX;
        
        imageY = imageY * CGscale;
        
        imgfram = CGRectMake(0, (SCREENHEIGHT - imageY) / 2, SCREENWIDTH, imageY);
        
        return imgfram;
    }
    
}

//这个方法的返回值决定了要缩放的内容(只能是UISCrollView的子控件)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
