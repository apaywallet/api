# Apay支付接口 #

## 1.概览 ##
本文档中列出的所有 API 基础调用 URL 是 [https://api.apay.im](https://api.apay.im) （ 如 API：pay 实际请求 URL [https://api.apay.im/pay](https://api.apay.im/pay) ） 。Apay 支持 json格式请求。

## 2.RESTful API ##

Apay API 基于 RESTful API 风格，它具备完整的 HTTP 请求规范，多数的 Apay API 需采用 POST 方式发送请求，少量的服务类 API 使用 GET 方式获取数据。除 API 列举的请求方式外，其他方法都不被支持。

### 2.1.pay ###

#### 请求参数 ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| coinName | String | 币种 |
| orderAmount | Decimal | 数量 |
| merchantSign | String | 商家签名 |

#### 返回值 ####

## 3.H5-Bridge 调用 ##

pay,coinpay,otcpay分别对应支付，币支持和OTC支付。例:
``` 
	<script language="javascript" src="https://static.apay.im/dsbridge.js"></script>
	var params = {
		'merchantId':'123456',
		...
	}
	dsBridge.call("pay.payAsyn",params);
```
