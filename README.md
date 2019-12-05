# 第三方支付接口 #

## 1.概览 ##

## 2.RESTful API ##

第三方支付 API 基于 RESTful API 风格，它具备完整的 HTTP 请求规范，多数的 API 需采用 POST 方式发送请求，少量的服务类 API 使用 GET 方式获取数据。除 API 列举的请求方式外，其他方法都不被支持。

### 2.1.pay发起支付 ### 请求方式：POST

#### 请求参数(Content-Type : application/json) ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| coinName | String | 币种简称 |
| orderAmount | Decimal | 数量 |
| merchantSign | String | 商家签名 |

#### 返回值(Content-Type : application/json) ####

| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| coinName | String | 币种简称 |
| orderAmount | Decimal | 数量 |
| merchantSign | String | 商家签名 |

***注意***：商家签名merchantSign生成规则:body中参数(除merchantSign之外)根据key升序排序后，按"key=value"组合，一对"key-value"之间用","分隔,
组合得到字符串，对得到的字符串进行HMAC 
SHA256，然后Base64,得到签名。HMAC SHA256的key为商家APP-SECRET。

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

### 2.2.查询商家订单状态 /pay/v1.0/queryMerchantOrderStatus 请求方式：POST

#### 请求参数(Content-Type : application/json)  ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值(Content-Type : application/json) #### 

***注意***：查询订单状态返回后，请对响应参数进行签名校验，校验通过后方可信任

| 参数 | 类型 | 描述 |
| - | - | - |
| orderAmount | BigDecimal | 订单数量(以下面的coinName为单位计) |
| coinName | String | 订单币种 |
| billCode | String | 平台订单号 |
| orderStatus | Integer | 订单状态(1为已创建，2为确认中，3为支付成功，4为失败) |
| merchantSign | String | 用商家APP-SECRET签名生成的商家签名 |

### 2.3.实时推送商家回调: 使用方需提供商家回调接口，接收支付成功后的回调，支付平台向接收方发送 ***POST*** 请求。当支付成功时，实时回调商家来通知商家支付成功，(实时回调未成功，则支付平台会再次异步回调3次，3次未成功后，不再回调)请求参数如下:

#### 请求参数(Content-Type : application/json)  ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantOrderCode| String | 商家订单号 |
| orderAmount | BigDecimal | 订单数量(以下面的coinName为单位计) |
| coinName | String | 币种名称 |
| billCode | String | 订单号(此订单号为本平台的订单号) |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值说明:成功接收到支付平台推送后，需给支付平台以Json方式返回如下参数,支付平台将code为200视为推送成功。
``` 
	{"code":200}
```

| 参数 | 类型 | 描述 |
| - | - | - |
| code | Integer | 返回码(200为成功，其他为失败) |

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

## 4.H5二维码 扫码支付 ##
待完善...
