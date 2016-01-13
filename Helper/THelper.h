//
//  THelper.h
//  THomeIconAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THelper : NSObject

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font;

+ (UIButton *)buttonsetIamgeWithFrame:(CGRect)frame
                                nfile:(NSString *)nfileName
                                sfile:(NSString *)sfileName
                                  tag:(NSInteger)buttonTag
                               action:(SEL)action;
+ (CGSize)getContentLableSize:(NSString *)contentString withLabelWith:(CGFloat)labelWith withFont:(UIFont *)font;

+ (float)huDuFromdu:(float)du;
+ (float)sin:(float)du;
+ (float)cos:(float)du;

@end
