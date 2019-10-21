# Apay支付接口 #

## 1.概览 ##
本文档中列出的所有 API 基础调用 URL 是 [https://api.apay.im](https://api.apay.im) （ 如 API：pay 实际请求 URL [https://api.apay.im/pay](https://api.apay.im/pay) ） 。Apay 支持 json格式请求。

## 2.RESTful API ##

Apay API 基于 RESTful API 风格，它具备完整的 HTTP 请求规范，多数的 Apay API 需采用 POST 方式发送请求，少量的服务类 API 使用 GET 方式获取数据。除 API 列举的请求方式外，其他方法都不被支持。

### 2.1.pay发起支付 ###

#### 请求参数 ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| coinName | String | 币种简称 |
| orderAmount | Decimal | 数量 |
| merchantSign | String | 商家签名 |

#### 返回值 ####

| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| coinName | String | 币种简称 |
| orderAmount | Decimal | 数量 |
| merchantSign | String | 商家签名 |

***注意***：商家签名merchantSign生成规则:body中参数(除merchantSign之外)根据key升序排序后，按"key=value"组合，一对"key-value"之间用","分隔,
组合得到字符串，对得到的字符串进行HMAC 
SHA256，然后Base64,得到签名。HMAC SHA256的key为Apay商家APP-SECRET。

Java生成签名方法如下：

```
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.HmacAlgorithms;
import org.apache.commons.codec.digest.HmacUtils;

 // bodyStr为按规则拼接好的明文字符串
String sign = Base64.encodeBase64String(new HmacUtils(HmacAlgorithms.HMAC_SHA_256, appSecret)
                .hmac(bodyStr);                
```

例如：body参数为 address = 0x123456789，orderId = ap201906250958001，那么根据key升序排列所得到的字符串为："address=0x1236547,orderId=ap201906250958001",对此字符串进行HMAC SHA256，然后Base64即可得到签名

### 2.2.查询商家订单状态 /v1.0/queryMerchantOrderStatus ###

#### 请求参数 ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| orderCode | String | 订单号(此订单号为Apay返回的订单号) |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值 ####

| 参数 | 类型 | 描述 |
| - | - | - |
| orderStatus | Integer | 订单状态(1为已创建，2为确认中，3为已完成，4为失败) |

## 3.H5-Bridge 调用 ##

pay,coinpay,otcpay分别对应支付，币支付和OTC支付。例:
``` 
	<script language="javascript" src="./script/apaybridge.js"></script>
	var params = {
		'merchantId':'123456',
		'merchantOrderCode':'20191021001',
		'coinName':'USDT',
		'orderAmount':'20.00',
		'merchantSign':'QCvDC19pUclUIBDwh5vJVZRhi3UvHooRN4hL8Zo8sXk='
	}
	apayBridge.call("pay.payAsyn",params);
```