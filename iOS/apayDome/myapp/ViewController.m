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
#import "WalletPopMenuView.h"

// 判断字符串是否为空
#define BF_IS_STR_NIL(objStr)                                                 \
    (![objStr isKindOfClass:[NSString class]] || objStr == nil ||              \
     [objStr length] <= 0)
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *coinNameBtn;

@end
NSString *merchantId = @"26342f91-ce27-42c2-aac9-8177403dba92";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat labelWidth = self.coinNameBtn.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = self.coinNameBtn.imageView.frame.size.width;
    CGFloat space = 2.f; //定义两个元素交换后的间距
    self.coinNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    self.coinNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space, 0,  -labelWidth - space);
}
- (IBAction)gotopay:(id)sender {
    if (BF_IS_STR_NIL(self.textField.text)) {
        [UIWindow showTips:@"请输入数量"];
        return;
    }
   [self pushToPayType:0];
}
- (IBAction)changeCoinName:(id)sender {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
       CGPoint triangPoint = [self.view convertPoint:self.coinNameBtn.center toView:keyWindow];
    NSArray *dataArray = @[@{@"title":@"USDT",},
                           @{@"title":@"ETH",},@{@"title":@"BTC",},@{@"title":@"EOS",},@{@"title":@"APT",}];
    [WalletPopMenuView showWithItems:dataArray
                                          width:130
                               triangleLocation:triangPoint
                                         action:^(NSInteger index) {
        NSDictionary *dict = dataArray[index];
        [self.coinNameBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
                                         }];
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
    payreq.coinName = self.coinNameBtn.titleLabel.text;
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
      NSString *sign = [self hmacSHA256WithSecret:@"2433822CC6B6BAF52CEBAD5E20B15088" content:sortString];
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
