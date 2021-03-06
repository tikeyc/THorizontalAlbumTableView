//
//  THelper.m
//  THomeIconAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "THelper.h"

@implementation THelper

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UIButton *)buttonsetIamgeWithFrame:(CGRect)frame
                                nfile:(NSString *)nfileName
                                sfile:(NSString *)sfileName
                                  tag:(NSInteger)buttonTag
                               action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:nfileName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:sfileName] forState:UIControlStateHighlighted];
    [button setTag:buttonTag];
    [button addTarget:nil action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (CGSize)getContentLableSize:(NSString *)contentString withLabelWith:(CGFloat)labelWith withFont:(UIFont *)font{
    CGSize size;
    size = [contentString  sizeWithFont:font
                      constrainedToSize:CGSizeMake(labelWith, 9999)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

#pragma mark 度转弧度
+ (float)huDuFromdu:(float)du
{
    return M_PI/(180/du);
}

#pragma mark 计算sin
+ (float)sin:(float)du
{
    return sinf(M_PI/(180/du));
}

#pragma mark 计算cos
+ (float)cos:(float)du
{
    return cosf(M_PI/(180/du));
}

@end
