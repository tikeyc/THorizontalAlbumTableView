//
//  TAlbumImageView.m
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "TAlbumImageView.h"

#import "MBProgressHUD.h"
#import "TPhotoScrollView.h"

@implementation TAlbumImageView

{
    UIView *_bgView;
//    UITapGestureRecognizer *_tap;
    UITapGestureRecognizer *_zoomOutTap;
    
    //滑动视图
    UITableView *_albumTableView;
    UIImageView *_fullImgView;
    UIActivityIndicatorView *_activityView;
    UIPageControl *_pageControl;
    
    NSInteger _lastIndex;//s判断时候动画缩小
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _lastIndex = 0;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbumTap:)];
}

- (void)setImageModels:(NSArray *)imageModels{
    if (_imageModels != imageModels) {
        _imageModels = nil;
        _imageModels = imageModels;
    }
    
    
    if (_imageModels.count == 0) {
        [self removeGestureRecognizer:_tap];
    }else if (_imageModels.count >= 1){
        [self addGestureRecognizer:_tap];
        ////无线循环滑动
        NSMutableArray *images = [NSMutableArray arrayWithArray:_imageModels];
        id lastObject = [_imageModels lastObject];
        id firstObject = _imageModels[0];
        [images addObject:firstObject];
        [images insertObject:lastObject atIndex:0];
        _imageModels = [NSArray arrayWithArray:images];
    }

}

- (void)showAlbumTap:(UITapGestureRecognizer *)tap{
    
    //背景视图
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    if (self.isLocalImg) {
        _bgView.backgroundColor = RGBColor(255, 255, 255);
    }else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    [self.window addSubview:_bgView];
    //
    _zoomOutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut:)];
    [_bgView addGestureRecognizer:_zoomOutTap];
    //滑动视图
    _albumTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _bgView.height) style:UITableViewStylePlain];
    _albumTableView.dataSource = self;
    _albumTableView.delegate = self;
    _albumTableView.rowHeight = kScreenWidth;
    _albumTableView.backgroundColor = [UIColor clearColor];
    _albumTableView.showsHorizontalScrollIndicator = NO;
    _albumTableView.showsVerticalScrollIndicator = NO;
    _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _albumTableView.pagingEnabled = YES;
    //将_albumTableView逆时针旋转90°
    _albumTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _albumTableView.frame = CGRectMake(0, 0, kScreenWidth, _bgView.height);
    [_bgView addSubview:_albumTableView];
    //
    _fullImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _fullImgView.contentMode = UIViewContentModeScaleAspectFit;
    _fullImgView.userInteractionEnabled = YES;
    _fullImgView.image = self.image;
    [_bgView addSubview:_fullImgView];
    //
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImgView.frame = frame;
    _albumTableView.hidden = YES;
    //放大图片
    [self zoomIn];
}
//放大图片
- (void)zoomIn{

    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = _imageModels.count - 2;//无线循环的话须-2否则去掉
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    }else{
        _pageControl.numberOfPages = _imageModels.count - 2;//无线循环的话须-2否则去掉
    }
    _pageControl.currentPage = _selectedIndex;
    
//    _albumTableView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _fullImgView.frame = _bgView.frame;
//        _albumTableView.frame = _bgView.frame;
    } completion:^(BOOL finished) {
        //放大图片之后隐藏状态栏
        [_bgView addSubview:_pageControl];

        _bgView.backgroundColor = RGBColor(243, 243, 243);
//        //无限循环滑动 先滑到实际的第2页
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//        [_albumTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        _albumTableView.hidden = NO;
        _fullImgView.hidden = YES;
    }];
    
    //滑动到选择的第几张图片
    _lastIndex = self.selectedIndex;
    NSInteger index = self.selectedIndex + 1;
    _pageControl.currentPage = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_albumTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


//缩小图片
- (void)zoomOut:(UITapGestureRecognizer *)tap{
    //缩小图片之后显示状态栏

    _bgView.backgroundColor = [UIColor clearColor];
    _fullImgView.hidden = NO;
    _albumTableView.hidden = YES;
    _pageControl.currentPage = 0;
    [_pageControl removeFromSuperview];
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    if (_lastIndex == self.selectedIndex) {
        [UIView animateWithDuration:0.2 animations:^{
            _albumTableView.frame = frame;
            _fullImgView.frame = frame;
        } completion:^(BOOL finished) {
            
            [_albumTableView removeFromSuperview];
            [_fullImgView removeFromSuperview];
            [_bgView removeFromSuperview];
            _albumTableView = nil;
            _fullImgView = nil;
            _bgView = nil;
        }];
    }else{
        [_albumTableView removeFromSuperview];
        [_fullImgView removeFromSuperview];
        [_bgView removeFromSuperview];
        _albumTableView = nil;
        _fullImgView = nil;
        _bgView = nil;
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"horizontalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        EEPhotoScrollView *photoScrollView = [[EEPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _bgView.height)];
        photoScrollView.tag = 6666666;
        photoScrollView.tableView = _albumTableView;
        photoScrollView.bgTap = _zoomOutTap;
        [cell.contentView addSubview:photoScrollView];
        //

    }
    //图片
    EEPhotoScrollView *photoScrollView = (EEPhotoScrollView *)[cell.contentView viewWithTag:6666666];
    photoScrollView.top = 0;
    photoScrollView.row = indexPath.row;
    photoScrollView.imageModels = self.imageModels;

    
///////////
    id data = _imageModels[indexPath.row];
    if (self.isLocalImg) {
        UIImage *image;
        if ([data isKindOfClass:[NSData class]]) {
            image = [[UIImage alloc] initWithData:data];
        }else{
            image = [UIImage imageNamed:data];
        }

         photoScrollView.imageView.image = image;
    }else {
         photoScrollView.imgUrl = _imageModels[indexPath.row];
    }

    return cell;
}
/*
 *无限循环滑动
 */


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offSetX = scrollView.contentOffset.y;//注意旋转了90°
    NSInteger page = offSetX/kScreenWidth;
    NSLog(@"%ld",(long)page);
    page--;
    _pageControl.currentPage = page;
    _lastIndex = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float offSetX = scrollView.contentOffset.y;//注意旋转了90°
    
    NSLog(@"%f",offSetX);
    if (offSetX == 0) {//滑到 实际的最后一页
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_imageModels.count - 2 inSection:0];
        [_albumTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    if (offSetX == (_imageModels.count - 1)*kScreenWidth) {//滑到实际的第一页
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [_albumTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}


#pragma mark - pageContrl Action
- (void)pageControlAction:(UIPageControl *)pageContrl
{
    _albumTableView.contentOffset = CGPointMake(0, pageContrl.currentPage* kScreenWidth);
    NSLog(@"page = %ld",(long)pageContrl.currentPage);
}

@end
