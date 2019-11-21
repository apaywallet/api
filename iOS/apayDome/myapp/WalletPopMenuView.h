//
//  QQPopMenuView.h
//  ECLite
//
//  Created by ec on 16/6/16.
//  Copyright © 2016年 eclite. All rights reserved.
//

/**
 *  类似QQ消息页popMenu
 */

#import <UIKit/UIKit.h>

@interface WalletPopMenuView : UIView

@property (nonatomic, copy) void (^hideHandle)();

/**
 *  实例化方法
 *
 *  @param array  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param width  宽度
 *  @param point  三角的顶角坐标（基于window）
 *  @param action 点击回调
 */
- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                       action:(void(^)(NSInteger index))action;

/**
 *  类方法展示
 *
 *  @param array  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param width  宽度
 *  @param point  三角的顶角坐标（基于window）
 *  @param action 点击回调
 */
+ (void)showWithItems:(NSArray <NSDictionary *>*)array
                width:(CGFloat)width
     triangleLocation:(CGPoint)point
               action:(void(^)(NSInteger index))action;

- (void)show;
- (void)hide;

/**
 设置广告单管理的未读条数

 @param countString 未读条数
 */
- (void)setCountWithCountString:(NSString *)countString;
@end
