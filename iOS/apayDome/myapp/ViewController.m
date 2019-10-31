//
//  ViewController.m
//  myapp
//
//  Created by Beepay001 on 2018/9/7.
//  Copyright © 2018年 beepay.pro. All rights reserved.
//

#import "ViewController.h"
#include <CommonCrypto/CommonHMAC.h>
#import "apay.framework/Headers/ApayApi.h"
#import "UIWindow+Extension.h"

// 判断字符串是否为空
#define BF_IS_STR_NIL(objStr)                                                 \
    (![objStr isKindOfClass:[NSString class]] || objStr == nil ||              \
     [objStr length] <= 0)
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
NSString *merchantId = @"27dc6eaf-5bf5-4eb9-80f1-a564e20e9d10";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)gotopay:(id)sender {
    if (BF_IS_STR_NIL(self.textField.text)) {
        [UIWindow showTips:@"请输入数量"];
        return;
    }
   [self pushToPayType:0];
}

- (IBAction)gotocoinpay:(id)sender {
    if (BF_IS_STR_NIL(self.textField.text)) {
        [UIWindow showTips:@"请输入数量"];
        return;
    }
    [self pushToPayType:1];

}

- (IBAction)gotootcpay:(id)sender {
    if (BF_IS_STR_NIL(self.textField.text)) {
        [UIWindow showTips:@"请输入数量"];
        return;
    }
    [self pushToPayType:2];
}

- (void)pushToPayType:(NSInteger)payType {
    
    PayReq *payreq = [[PayReq alloc]init];
    payreq.coinName = @"USDT";
    payreq.merchantOrderCode = @"201910171234";
    payreq.orderAmount =self.textField.text;
    payreq.businessId = merchantId;
    if (payType == 0) {
        payreq.payType = ThirdPayTypePay;
    }else if (payType == 1) {
        payreq.payType = ThirdPayTypeCoinPay;
    }else if (payType == 2) {
        payreq.payType = ThirdPayTypeOtcPay;
    }
    payreq.signSecret = @"6FE144D58964EB0D535B521A651AE19E";
    [ApayApi registerApayApp:@"123"];
    [ApayApi sendApayReq:payreq];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
