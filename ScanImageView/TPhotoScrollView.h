//
//  TAlbumImageView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EEPhotoScrollView : UIScrollView<UIScrollViewDelegate> {
    UIImageView *_imageView;
}

@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,assign)NSInteger row;
@property (nonatomic,strong)NSArray *imageModels;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITapGestureRecognizer *bgTap;//为了禁用手势 冲突问题

@property (nonatomic, strong) UIImageView *imageView;

@end
