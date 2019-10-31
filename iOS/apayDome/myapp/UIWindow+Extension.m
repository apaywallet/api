//
//  UIWindow+Extension.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "objc/runtime.h"

@implementation UIWindow (Extension)

+(void)showTips:(NSString *)text {
    UIView *tips = objc_getAssociatedObject(self, &tipsKey);
    if(tips) {
        return;
//        [self dismiss];
//        [NAPChooseCountryViewControllerSThread sleepForTimeInterval:0.5f];
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat maxWidth = 200;
    CGFloat maxHeight = window.frame.size.height - 200;
    CGFloat commonInset = 14;
    
    UIFont  *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height < maxHeight ? rect.size.height : maxHeight));
    
    CGRect textFrame = CGRectMake(window.frame.size.width/2 - (size.width + commonInset * 2)/2 , (window.frame.size.height - (size.height + commonInset * 2))/2 - 20, size.width  + commonInset * 2, size.height + commonInset * 2);
//    tips = [[UITextView alloc] initWithFrame:textFrame];
//    tips.text = text;
//    tips.font = font;
//    tips.textColor = [UIColor whiteColor];
//    tips.backgroundColor = [UIColor blackColor];
//    tips.layer.cornerRadius = 5;
//    tips.editable = NO;
//    tips.selectable = NO;
//    tips.scrollEnabled = NO;
//    tips.textContainer.lineFragmentPadding = 0;
//    tips.contentInset = UIEdgeInsetsMake(commonInset, commonInset, commonInset, commonInset);
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    bgView.layer.cornerRadius = 6;
    bgView.layer.masksToBounds = YES;
    bgView.frame = textFrame;
    
    UILabel *textTips = [[UILabel alloc]init];
    textTips.text = text;
    textTips.font = font;
    textTips.textColor = [UIColor whiteColor];
    [bgView addSubview:textTips];
    textTips.frame = CGRectMake(commonInset, commonInset, size.width, size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGuesture:)];
    [window addGestureRecognizer:tap];
    [window addSubview:bgView];
    
    objc_setAssociatedObject(self, &tapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tipsKey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.0f];
}

+(void)handlerGuesture:(UIGestureRecognizer *)sender {
    if(!sender || !sender.view)
        return;
    [self dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object: nil];
}

+(void)dismiss {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, &tapKey);
    [window removeGestureRecognizer:tap];
    
    UIView *tips = objc_getAssociatedObject(self, &tipsKey);
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        tips.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [tips removeFromSuperview];
        objc_setAssociatedObject(self, &tipsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

@end
