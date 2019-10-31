# iOS APP Apay调用接口 #

## 1.概览 ##
本文档只描述大概的使用详情,具体接入详情请查看附带的demo.



### 1.1.拖入下图中的SDK ###
![](https://apw-static.oss-cn-beijing.aliyuncs.com/upload_file/OTHER/custom/1.jpg)
### 1.2.工程中添加framework ###
![](https://apw-static.oss-cn-beijing.aliyuncs.com/upload_file/OTHER/custom/2.jpg)
### 1.3.工程中添加URL Types ###
URLTypes的schemes格式为apayxxx,其中xxx为平台获取到的appid
![](https://apw-static.oss-cn-beijing.aliyuncs.com/upload_file/OTHER/custom/3.jpg)
### 1.4.工程中调用 ###
1. 首先导入#import "apay.framework/Headers/ApayApi.h"头文件
2. 生成所需要的参数,coinName只有USDT,merchantOrderCode为商家订单号,后台提供;orderAmount为数量,businessId为商户APPID;signSecret为商家加密串;payType为跳转页面,具体看注释;signSecret为签名密钥,注意发起调用之前设置appId,[ApayApi registerApp:@"123"],示例如下所示,
![](https://apw-static.oss-cn-beijing.aliyuncs.com/upload_file/OTHER/custom/4.jpg)
```
 PayReq *payreq = [[PayReq alloc]init];   
  payreq.coinName = @"USDT";  
    payreq.merchantOrderCode = @"201910171234";  
    payreq.orderAmount =self.textField.text;  
    payreq.businessId = merchantId;  
    if (payType == 0) {  
        payreq.payType = ApayTypeCustomSelect;
    }else if (payType == 1) {
        payreq.payType = ApayTypeTransfer;
    }else if (payType == 2) {
        payreq.payType = ApayTypeOTC;
    }
    payreq.signSecret = @"6FE144D58964EB0D535B521A651AE19E";
    [ApayApi registerApp:@"123"];
    [ApayApi sendReq:payreq];
```
### 1.5.工程中调用 ###

注意:具体回调是否成功以后台服务器返回为准

1. appDelegate.m中的 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options方法添加处理回调,
2. - (void)onResp:(ApayBaseResp*)resp为回调方法



