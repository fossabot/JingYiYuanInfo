//
//  ShareView.m
//  分享面板定义
//
//  Created by VINCENT on 2017/7/14.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "ShareView.h"
#import "BAButton.h"
#import "YYUMShareManager.h"


#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

#define TopH  30
#define BottomH  40

#define HorizontalMargin  (SCREENW - 4*60)/5
#define VerticalMargin  10
#define ButtonW  60
#define ButtonH  90

@interface ShareView()

/** 标题*/
@property (nonatomic, copy) NSString *title;

/** 副标题*/
@property (nonatomic, copy) NSString *subTitle;

/** 分享的链接*/
@property (nonatomic, copy) NSString *webUrl;

/** 分享的图片地址*/
@property (nonatomic, copy) NSString *imageUrl;

/** 是否收藏了*/
@property (nonatomic, assign) BOOL isCollected;

/** collectionview*/
//@property (nonatomic, strong) UICollectionView *collectionView;

/** collectionFlowLayout*/
//@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** dataSource*/
@property (nonatomic, strong) NSMutableArray<ShareModel *> *dataSource;

/** buttonarr*/
@property (nonatomic, strong) NSMutableArray *buttonArr;

/** 底部分享区域的容器View*/
@property (nonatomic, strong) UIView *container;

/** topLabel 壹元服务*/
@property (nonatomic, strong) UILabel *topLabel;

/** 中间分享控件按钮*/
@property (nonatomic, strong) UIView *MiddleView;

/** cancelButton 下方取消按钮*/
@property (nonatomic, strong) UIButton *cancelBtn;

/** shareViewType 分享的平台（微信，QQ，微博，字体，收藏按钮（收藏回调），复制链接）*/
@property (nonatomic, assign) ShareViewType shareViewType;

/** shareContentType 分型内容属于（文章，音乐，图片，视频等等）*/
@property (nonatomic, assign) ShareContentType shareContentType;

/** containerHeight*/
@property (nonatomic, assign) CGFloat containerHeight;

@end

@interface ShareModel()

/** title*/
@property (nonatomic, copy) NSString *title;

/** selected title*/
@property (nonatomic, copy) NSString *selectedTitle;

/** image*/
@property (nonatomic, copy) NSString *imageName;

/** selectedImage*/
@property (nonatomic, copy) NSString *selectedImage;

/** ShareViewType 该模型属于哪个分享平台下的*/
@property (nonatomic, assign) ShareViewType shareType;

@end

@implementation ShareModel


@end


@implementation ShareView

+ (void)shareWithTitle:(NSString *)title subTitle:(NSString *)subTitle webUrl:(NSString *)webUrl imageUrl:(NSString *)imageUrl isCollected:(BOOL)isCollected shareViewContain:(ShareViewType)shareViewType shareContentType:(ShareContentType)shareContentType finished:(FinishedBlock)finished {
    
    ShareView *share = [[ShareView alloc] initWithFrame:CGRectMake(0, SCREENH - 330, SCREENW, 400)];
    
    share.title = title;
    share.subTitle = subTitle;
    //weburl代表所有的链接（音乐，视频），除了imageURL
    
    if ([webUrl containsString:@"userid"]) {
        YYLog(@"userid share url ---- %@",webUrl);
        NSRange range = [webUrl rangeOfString:@"&userid="];
        NSRange subRange = NSMakeRange(range.location, 24);
        NSString *temp = [webUrl substringWithRange:subRange];
        webUrl = [webUrl stringByReplacingOccurrencesOfString:temp withString:@""];
        YYLog(@"no userid share url ---- %@",webUrl);
    }
    
    share.webUrl = webUrl;
    
    share.imageUrl = imageUrl ? : @"logo";

    share.isCollected = isCollected;
    share.finishedBlock = finished;
    if (shareViewType) {
        share.shareViewType = shareViewType;
    }
    if (shareContentType) {
        share.shareContentType = shareContentType;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:share action:@selector(tap:)];
    [share addGestureRecognizer:tap];
    [share createSubviews];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _shareViewType = ShareViewTypeWechat | ShareViewTypeWechatTimeline | ShareViewTypeQQ | ShareViewTypeQQZone | ShareViewTypeMicroBlog ;
        _shareContentType = ShareContentTypeWeb;

    }
    return self;
}

- (void)createSubviews {
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self];
    
    [self addSubview:self.container];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.container.transform = CGAffineTransformMakeTranslation(0, -self.container.bounds.size.height);
    }];
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
//     if( CGRectContainsPoint(self.MiddleView.frame, [tap locationInView:self]) || CGRectContainsPoint(self.topLabel.frame, [tap locationInView:self])) {
//         YYLog(@"container  包含点击的点");
//         return;
//     }
    [self cancelButtonClick:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    YYLog(@"%s",__func__);
}

#pragma mark -- inner Methods 自定义方法


/**
 *点击取消
 */
- (void)cancelButtonClick:(UIButton *)btn {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.container.transform = CGAffineTransformMakeTranslation(0, self.container.bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:15/255.0 green:15/255.0 blue:15/255.0 alpha:0.0];

    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}

/**
 *分享平台的按钮被点击，收藏按钮selected取反，回调至上层界面，发送请求收藏，或者取消收藏
 */
- (void)shareButtonClick:(BAButton *)btn {
    
    [self cancelButtonClick:nil];
    
    ShareViewType shareViewType = self.dataSource[btn.tag-100].shareType;
    if (shareViewType == ShareViewTypeCopyLink) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webUrl;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        [SVProgressHUD dismissWithDelay:1];
    }else if (shareViewType == ShareViewTypeFavor) {
        
        YYWeakSelf
        [YYHttpNetworkTool globalNetStatusNotice:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                
                [SVProgressHUD showErrorWithStatus:@"无法连接到网络"];
                
            }else {
                //回调给新闻详情页控制器，如果是复制（直接在UIPasteboard上赋值）,收藏（改变图标，回调后请求后台），字体（回调后弹出字体选择面板）
                btn.selected = !btn.selected;
                if (weakSelf.finishedBlock) {
                    weakSelf.finishedBlock(shareViewType, btn.isSelected);
                }

            }
        }];
    }else if (shareViewType == ShareViewTypeFont) {
        
        if (_finishedBlock) {
            _finishedBlock(shareViewType, btn.isSelected);
        }
    }else {
    
        //分享第三方
        UMSocialPlatformType type = [self translateIntoUMSocialPlatformType:shareViewType];
        
        if (self.shareContentType == ShareContentTypeWeb) {
            [YYUMShareManager shareWeburl:self.webUrl title:self.title desc:self.subTitle thumbUrl:self.imageUrl platform:type];
        }else if (self.shareContentType == ShareContentTypeMusic) {
            [YYUMShareManager shareMusic:self.webUrl title:self.title desc:self.subTitle thumbUrl:self.imageUrl toPlatformType:type];
        }else if (self.shareContentType == ShareContentTypeImage) {
            [YYUMShareManager shareImage:self.imageUrl toPlatformType:type];
        }else if (self.shareContentType == ShareContentTypeVideo) {
            [YYUMShareManager shareVideo:self.webUrl title:self.title desc:self.subTitle thumbUrl:self.imageUrl toPlatformType:type];
        }
    
    }

}

- (UMSocialPlatformType)translateIntoUMSocialPlatformType:(ShareViewType)shareViewType{
    
    switch (shareViewType) {
        case ShareViewTypeQQ:
            return UMSocialPlatformType_QQ;
            break;
        
        case ShareViewTypeQQZone:
            return UMSocialPlatformType_Qzone;
            break;
            
        case ShareViewTypeWechat:
            return UMSocialPlatformType_WechatSession;
            break;
            
        case ShareViewTypeWechatTimeline:
            return UMSocialPlatformType_WechatTimeLine;
            break;
            
        case ShareViewTypeMicroBlog:
            return UMSocialPlatformType_Sina;
            break;
            
        default:
            return nil; //返回nil时，说明调用的是收藏、字体等
            break;
    }
    
}


#pragma mark -- lazyMethods 懒加载区域

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.MiddleView.frame), SCREENW, BottomH);
        [_cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1.0] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENW, TopH)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = SubTitleFont;
        _topLabel.text = @"壹元服务为您提供专业的投资理财资讯";
        _topLabel.textColor = [UIColor colorWithRed:75/255.0 green:76/255.0 blue:81/255.0 alpha:1.0];
        _topLabel.backgroundColor = [UIColor clearColor];
    }
    return _topLabel;
}

- (UIView *)MiddleView{
    if (!_MiddleView) {
        _MiddleView = [[UIView alloc] init];
        self.buttonArr = [NSMutableArray array];
        for (ShareModel *model in self.dataSource) {
            
            BAButton *button = [BAButton creatButtonWithFrame:CGRectZero                                   title:model.title
                                selTitle:model.selectedTitle
                              titleColor:[UIColor
                                          colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0]
                               titleFont:[UIFont systemFontOfSize:10] image:[UIImage imageNamed:[NSString stringWithFormat:@"image.bundle/%@",model.imageName]]
                                selImage:[UIImage imageNamed:[NSString stringWithFormat:@"image.bundle/%@",model.selectedImage]]
                     buttonPositionStyle:BAButtonPositionStyleTop
                                  target:self
                                selector:@selector(shareButtonClick:)];
            
            [_MiddleView addSubview:button];
            if (_isCollected && model.shareType & ShareViewTypeFavor) {
                button.selected = YES;
            }

            button.hadWhiteBackground = YES;
            button.padding = 15;
            button.backgroundColor = [UIColor clearColor];
            [self.buttonArr addObject:button];
        }
//        NSInteger colum = (self.dataSource.count-1)/4 + 1;
        
        CGFloat superHeight = 0;
        
        for (int i = 0; i<self.buttonArr.count; i++) {
            CGFloat x = HorizontalMargin + (i%4)*(ButtonW + HorizontalMargin);
            CGFloat y = VerticalMargin + (i/4)*(ButtonH + VerticalMargin);
            BAButton *button = (BAButton *)self.buttonArr[i];
            button.frame = CGRectMake(x, y, ButtonW, ButtonH);
            button.tag = 100 + i;
            superHeight = CGRectGetMaxY(button.frame) + 20;
        }
        _containerHeight = superHeight;
        _MiddleView.frame = CGRectMake(0, TopH, SCREENW, superHeight);
    }
    return _MiddleView;
}


- (UIView *)container{
    if (!_container) {
        
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [_container addSubview:self.topLabel];
        [_container addSubview:self.MiddleView];
        [_container addSubview:self.cancelBtn];
        CGFloat containerH = TopH+_containerHeight+BottomH;
        _container.frame = CGRectMake(0, SCREENH, SCREENW, containerH);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lanjie:)];
        [_container addGestureRecognizer:tap];
    
    }
    return _container;
}

- (void)lanjie:(UITapGestureRecognizer *)gesture{
    YYLog(@"点击了container  用于拦截父视图的tap手势");
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        BOOL hadInstalledWeChat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
        
        BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
        
        //微信好友
        if ( hadInstalledWeChat &&_shareViewType & ShareViewTypeWechat) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"微信好友";
            shareModel.selectedTitle = @"微信好友";
            shareModel.imageName = @"share_wechat_friend_30x30_@3x.png";
            shareModel.selectedImage = @"share_wechat_friend_30x30_@3x.png";
            shareModel.shareType = ShareViewTypeWechat;
            [_dataSource addObject:shareModel];
            
        }
        //微信朋友圈
        if (hadInstalledWeChat && _shareViewType & ShareViewTypeWechatTimeline) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"微信朋友圈";
            shareModel.selectedTitle = @"微信朋友圈";
            shareModel.imageName = @"share_wechat_timeline_30x30_@3x.png";
            shareModel.selectedImage = @"share_wechat_timeline_30x30_@3x.png";
            shareModel.shareType = ShareViewTypeWechatTimeline;
            [_dataSource addObject:shareModel];
            
        }
        //QQ好友
        if (hadInstalledQQ && _shareViewType & ShareViewTypeQQ) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"QQ好友";
            shareModel.selectedTitle = @"QQ好友";
            shareModel.imageName = @"share_qq_30x30_@3x.png";
            shareModel.selectedImage = @"share_qq_30x30_@3x.png";
            shareModel.shareType = ShareViewTypeQQ;
            [_dataSource addObject:shareModel];

        }
        //QQ空间
        if (hadInstalledQQ && _shareViewType & ShareViewTypeQQZone) {
         
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"QQ空间";
            shareModel.selectedTitle = @"QQ空间";
            shareModel.imageName = @"share_qqzone_30x28_@3x.png";
            shareModel.selectedImage = @"share_qqzone_30x28_@3x.png";
            shareModel.shareType = ShareViewTypeQQZone;
            [_dataSource addObject:shareModel];
        
        }
        //新浪微博
        if (_shareViewType & ShareViewTypeMicroBlog) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"新浪微博";
            shareModel.selectedTitle = @"新浪微博";
            shareModel.imageName = @"share_weibo_30x30_@3x.png";
            shareModel.selectedImage = @"share_weibo_30x30_@3x.png";
            shareModel.shareType = ShareViewTypeMicroBlog;
            [_dataSource addObject:shareModel];
            
        }
        //收藏
        if (_shareViewType & ShareViewTypeFavor) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"收藏";
            shareModel.selectedTitle = @"取消收藏";
            shareModel.imageName = @"share_collection_normal@3x.png";
            shareModel.selectedImage = @"share_collection_highlighted@3x.png";
            shareModel.shareType = ShareViewTypeFavor;
            [_dataSource addObject:shareModel];
            
        }
        //调整字体
        if (_shareViewType & ShareViewTypeFont) {
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"调整字体";
            shareModel.selectedTitle = @"调整字体";
            shareModel.imageName = @"share_font_normal_30x30_@2x.png";
            shareModel.selectedImage = @"share_font_normal_30x30_@2x.png";
            shareModel.shareType = ShareViewTypeFont;
            [_dataSource addObject:shareModel];
        }
        //复制链接
        if (_shareViewType & ShareViewTypeCopyLink) {
            
            ShareModel *shareModel = [[ShareModel alloc] init];
            shareModel.title = @"复制链接";
            shareModel.selectedTitle = @"复制链接";
            shareModel.imageName = @"share_copy_link_30x30_@3x.png";
            shareModel.selectedImage = @"share_copy_link_30x30_@3x.png";
            shareModel.shareType = ShareViewTypeCopyLink;
            [_dataSource addObject:shareModel];
        }
        //空值
        if (_shareViewType & ShareViewTypeNone) {
            YYLog(@"分享面板输入了空的分享平台");
        }
    }
    return _dataSource;
}



@end



