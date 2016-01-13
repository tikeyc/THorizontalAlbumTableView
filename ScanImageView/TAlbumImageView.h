//
//  'TAlbumImageView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TAlbumImageView : UIImageView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *imageModels;
@property (nonatomic,strong)NSArray *imageNames;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isLocalImg; //区别是本地图片还是网络图片

@property (nonatomic,strong)UITapGestureRecognizer *tap;
- (void)showAlbumTap:(UITapGestureRecognizer *)tap;

@end
