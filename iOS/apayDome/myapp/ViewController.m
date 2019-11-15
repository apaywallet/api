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
NSString *merchantId = @"5e63d2fc-3e1c-43fa-a6b3-2e36f5572c96";
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      if (!BF_IS_STR_NIL(payreq.coinName)) {
          dict[@"coinName"] = payreq.coinName;
      }
      if (!BF_IS_STR_NIL(payreq.merchantOrderCode)) {
          dict[@"merchantOrderCode"] = payreq.merchantOrderCode;
      }
      if (!BF_IS_STR_NIL(payreq.orderAmount)) {
          dict[@"orderAmount"] = payreq.orderAmount;
      }
      if (!BF_IS_STR_NIL(payreq.businessId)) {
          dict[@"merchantId"] = payreq.businessId;
      }
    NSString *sortString = [self sortString:dict.copy];
      NSString *sign = [self hmacSHA256WithSecret:@"56B3F3EF4A54C0A5D1C14212AD35B703" content:sortString];
    payreq.signSecretResult = sign;
    [ApayApi registerApayApp:merchantId];
    [ApayApi sendApayReq:payreq];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSString *)sortString:(NSDictionary *)dict {
    
    if(!dict){
        return @"";
    }
    
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *string = [NSMutableString string];
    for (id keyObj in arr) {
        /////   如果参数中包含@[]则不参与签名
        if ([dict[keyObj] isKindOfClass:NSArray.class] || [dict[keyObj] isKindOfClass:NSMutableArray.class]) {
            continue;
        }
        [string appendFormat:@"%@=%@",keyObj,dict[keyObj]];
        [string appendString:@","];
    }
    NSString *subString = [string substringToIndex:string.length - 1];
    return subString;
}

/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param secret       秘钥
 *  @param content 要加密的文本
 *
 *  @return 加密后的字符串
 */
- (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content
{
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];// 有可能有中文 所以用NSUTF8StringEncoding -> NSASCIIStringEncoding
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    return [HMACData base64EncodedStringWithOptions:0];
}

@end
