//
//  THorizontalTableView.m
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "THorizontalTableView.h"

#import "TAlbumImageView.h"
#import "UIImageView+WebCache.h"

@interface THorizontalTableView ()


@end

@implementation THorizontalTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.pagingEnabled = YES;
        //从新设置frame
        self.frame = frame;
        self.rowHeight = kScreenWidth;
    }
    return self;
}

- (void)setData:(NSArray *)data{
    if (_data != data) {
        _data = nil;
        _data = data;
    }
    
    _pageControl.numberOfPages = _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"horizontalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //图片
        TAlbumImageView *imgView = [[TAlbumImageView alloc] initWithFrame:CGRectZero];
        imgView.frame = CGRectMake(0, 0, self.rowHeight, self.height);
        imgView.tag = 500001;
        [cell.contentView addSubview:imgView];
    }
    //图片
    TAlbumImageView *imgView = (TAlbumImageView *)[cell.contentView viewWithTag:500001];
    
//////////

    id data = _data[indexPath.row];
    if ( [data respondsToSelector:@selector(containsString:)] && [data containsString:@"http"]) {
        imgView.isLocalImg = NO;
        [imgView sd_setImageWithURL:[NSURL URLWithString:_data[indexPath.row]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }else{
        imgView.isLocalImg = YES;
        
        if ([data isKindOfClass:[NSData class]]) {
            imgView.image = [[UIImage alloc] initWithData:data];
        }else{
            UIImage *image = [UIImage imageNamed:_data[indexPath.row]];
            imgView.image = image;
        }
        
    }
    
/////////
    
    imgView.selectedIndex = indexPath.row;
    imgView.imageModels = _data;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offSetX = scrollView.contentOffset.y;//注意旋转了90°
    NSInteger page = offSetX/kScreenWidth;
    NSLog(@"%ld",(long)page);
    _pageControl.currentPage = page;
    _numLabel.text = [NSString stringWithFormat:@"点击查看相册  %ld/%lu",page + 1,(unsigned long)_data.count];
    if ([_horizonDelegate respondsToSelector:@selector(pageChange:)]) {
        if (self.tag > 100) {
            [_horizonDelegate pageChange:page + self.tag];
        }else{
            [_horizonDelegate pageChange:page];
        }
    }
}




@end
