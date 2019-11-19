//
//  UIView+Category.m
//  test
//
//  Created by 沈雁飞 on 16/2/5.
//  Copyright © 2016年 沈雁飞. All rights reserved.
//

#import "UIView+Category.h"
#import <objc/runtime.h>

@implementation UIView (Category)
#pragma mark - size相关
-(void)setYf_size:(CGSize)yf_size
{
    CGRect frame = self.frame;
    frame.size = yf_size;
    self.frame = frame;
}
-(void)setYf_width:(CGFloat)yf_width
{
    CGRect frame = self.frame;
    frame.size.width = yf_width;
    self.frame = frame;
}
-(void)setYf_height:(CGFloat)yf_height
{
    CGRect frame = self.frame;
    frame.size.height = yf_height;
    self.frame = frame;
}
-(void)setYf_x:(CGFloat)yf_x
{
    CGRect frame = self.frame;
    frame.origin.x = yf_x;
    self.frame = frame;
}
-(void)setYf_y:(CGFloat)yf_y
{
    CGRect frame = self.frame;
    frame.origin.y = yf_y;
    self.frame = frame;
}

-(CGSize)yf_size
{
    return self.frame.size;
}
-(CGFloat)yf_width
{
    return self.frame.size.width;
}
-(CGFloat)yf_height
{
    return self.frame.size.height;
}
-(CGFloat)yf_x
{
    return self.frame.origin.x;
}
-(CGFloat)yf_y
{
    return self.frame.origin.y;
}
-(CGFloat)yf_bottom{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)yf_top{
    return CGRectGetMinY(self.frame);
}


@end
