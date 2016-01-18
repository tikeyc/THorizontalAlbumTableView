//
//  ViewController.m
//  THorizontalAlbumTableView
//
//  Created by tikeyc on 16/1/13.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "ViewController.h"

#import "THorizontalTableView.h"

@interface ViewController ()

@property (nonatomic,strong)THorizontalTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTableView{
    _tableView = [[THorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300) style:UITableViewStylePlain];
    _tableView.center = self.view.center;
    [self.view addSubview:_tableView];
    
    _tableView.layer.borderWidth = 2;
    if (/* DISABLES CODE */ (0)) {//切换网络和本地图片类型
        _tableView.data = @[
                            @"http://e.hiphotos.baidu.com/image/pic/item/a8014c086e061d9526d0f2fd7ff40ad163d9ca65.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/b8389b504fc2d562179e1528e31190ef77c66c65.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/5fdf8db1cb134954db9e1444534e9258d1094a0a.jpg",
                            @"http://h.hiphotos.baidu.com/image/pic/item/1c950a7b02087bf48dc2f8ecf0d3572c11dfcf8d.jpg"];
    }else{
        _tableView.data = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    }
    
    
    
}

@end
