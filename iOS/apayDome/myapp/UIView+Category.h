//
//  UIView+Category.h
//  test
//
//  Created by 沈雁飞 on 16/2/5.
//  Copyright © 2016年 沈雁飞. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HintsHiddenHandle)(void);
@interface UIView (Category)
#pragma mark - size相关
@property(nonatomic,assign)CGFloat yf_width;
@property(nonatomic,assign)CGFloat yf_height;
@property(nonatomic,assign)CGFloat yf_x;
@property(nonatomic,assign)CGFloat yf_y;
@property(nonatomic,assign)CGSize yf_size;
@property(nonatomic,assign,readonly)CGFloat yf_top;
@property(nonatomic,assign,readonly)CGFloat yf_bottom;
@end
