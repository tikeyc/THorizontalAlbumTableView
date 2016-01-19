//
//  TAlbumImageView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "TPhotoScrollView.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIView+ViewController.h"

@interface EEPhotoScrollView ()<UIAlertViewDelegate>

@end

@implementation EEPhotoScrollView

{
    UIActivityIndicatorView *_activityView;
    UITapGestureRecognizer *_tap2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //让图片等比例适应图片视图的尺寸
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        //
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = self.center;
        [_activityView stopAnimating];
        [self addSubview:_activityView];
        //设置最大放大倍数
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        //隐藏滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.delegate = self;
        
        //单击手势
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        [self addGestureRecognizer:tap1];
        
        //双击放大缩小手势
        _tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        //双击
        _tap2.numberOfTapsRequired = 2;
        //手指的数量
        _tap2.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_tap2];
        
        //tap1、tap2两个手势同时响应时，则取消tap1手势
//        [tap1 requireGestureRecognizerToFail:tap2];
        ////保存图片至手机
        UILongPressGestureRecognizer *storeImgTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(storeImgTapPress:)];
        storeImgTap.minimumPressDuration = 1;
        [self addGestureRecognizer:storeImgTap];
    }
    return self;
}

//保存图片至手机
- (void)storeImgTapPress:(UILongPressGestureRecognizer *)longPressap{
    if (longPressap.state == UIGestureRecognizerStateBegan) {
//        __weak typeof(self) weekSelf = self;
//        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存图片至手机" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [weekSelf saveImageToPhotos:_imageView.image];
//        }];
//        [alertView addAction:alertAction];
//        [self.viewController presentViewController:alertView animated:YES completion:nil];
        //上面代码不知道为什么不执行呀  放到其他地方也不执行
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片至手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [view show];
    }else if (longPressap.state == UIGestureRecognizerStateEnded){
        return;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    [self saveImageToPhotos:_imageView.image];
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(savedImage:didFinishSavingWithError:contextInfo:), NULL);
	
}
// 指定回调方法
- (void)savedImage:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    NSString *msg;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 20.f;
    hud.yOffset = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)setBgTap:(UITapGestureRecognizer *)bgTap{
    if (_bgTap != bgTap) {
        _bgTap = nil;
        _bgTap = bgTap;
    }
    [_bgTap requireGestureRecognizerToFail:_tap2];
}

- (void)setImgUrl:(NSString *)imgUrl{
    if (_imgUrl != imgUrl) {
        _imgUrl = nil;
        _imgUrl = imgUrl;
    }
    
    //2G、3G下展示图片
    [_activityView startAnimating];
    __weak EEPhotoScrollView *this = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [this stopActivityViewAnimating];
        }
    }];
    

}

- (void)stopActivityViewAnimating{
    [_activityView stopAnimating];
}

#pragma mark - UIScrollView delegate
//返回需要缩放的子视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

//手指离开屏幕时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    // 滚动到末尾 scrollView.contentOffset.x == self.contentSize.width-self.width
//    NSLog(@"scrollView.contentOffset.x = %f",scrollView.contentOffset.x);
//    NSLog(@"self.contentSize.width-self.width = %f",self.contentSize.width-self.width);
    
    NSInteger nextRow = self.row;
    
    float x = scrollView.contentOffset.x - (self.contentSize.width-self.width);
    if (scrollView.contentOffset.x < -30) {  //滚动左侧末尾
        //滑到上一页
        nextRow--;
    }
    else if(x > 30) {
        //滑到下一页
        nextRow++;
    }
    //判断是否滑动到上一页、下一页，如果是，则缩回当前页
    if (self.row != nextRow && (nextRow > 0 && nextRow < self.imageModels.count + 2)) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [self performSelector:@selector(setZoomScale:) withObject:@1.0 afterDelay:0.2];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    if (tap.numberOfTapsRequired == 1) {
         //显示、隐藏导航栏
//        UINavigationBar *navigationBar = self.viewController.navigationController.navigationBar;
//        BOOL isHide = navigationBar.isHidden;
//        [self.viewController.navigationController setNavigationBarHidden:!isHide animated:YES];
    }
    else if(tap.numberOfTapsRequired == 2) {
        
        if (self.zoomScale > 1) {
            [self setZoomScale:1 animated:YES];
        } else {
            [self setZoomScale:3 animated:YES];
        }
        
    }
}

@end
