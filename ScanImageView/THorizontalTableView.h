//
//  THorizontalTableView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol SWHorizonDelegate <NSObject>

@optional
- (void)pageChange:(NSInteger)index;

@end

@interface THorizontalTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign)id<SWHorizonDelegate> horizonDelegate;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UILabel *numLabel;

/////data
@property (nonatomic, assign) BOOL isLocalImg; //区别是本地图片还是网络图片
@property (nonatomic,strong)NSArray *data;



@end
