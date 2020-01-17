
## 所有API基础调用URL是: https://pay.6du.io (如API: pay 实际请求URL为https://pay.6du.io/pay)

## 1. 创建支付订单 /pay/v2.0/createPrePaymentBill 请求方式：POST

#### 请求参数(Content-Type : application/json)
| 参数 | 类型 | 描述 |
| - | - | - |
| subject | String | 商品标题 |
| coinName | String | 币种简称 |
| currencyName | String | 法币名称(目前只支持"CNY") |
| orderPrice | String | 购买金额 |
| tradeType | Integer | 购买类型(1为按数量购买，2为按金额购买) |
| quantity | String | 购买数量 |
| paymentProductCode | String | 支付产品代码 |
| requestTimestamp | Long | 请求时间戳(13位) |
| merchantId | String | 商家应用id |
| merchantOrderCode | String | 商家订单号 |
| merchantSign | String| 商家端签名 | 

***注意***：商家签名merchantSign生成规则:body中参数(除merchantSign之外)根据key升序排序后，按"key=value"组合，一对"key-value"之间用","分隔,
组合得到签名前明文串，用申请商家时的商家私钥对此明文串进行RSA加密，即可得到签名

例如：body参数为 address = 0x123456789，orderId = ap201906250958001，那么根据key升序排列所得到的字符串为："address=0x1236547,
orderId=ap201906250958001",用商家私钥对此字符串进行RSA加密，即可得到签名

#### 返回值(Content-Type : application/json)

| 参数 | 类型 | 描述 |
| - | - | - |
| billCode | String | 平台订单号 |
| merchantSign | String | 商家签名 |

## 2. 查询商家订单状态 /pay/v2.0/queryPayPreOrderStatus 请求方式：POST
      
#### 请求参数(Content-Type : application/json) 
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| merchantSign | String | 商家签名(签名生成规则同上) |
      
#### 返回值(Content-Type : application/json) #### 
      
***注意***：查询订单状态返回后，请对响应参数进行签名校验，校验通过后方可信任
      
| 参数 | 类型 | 描述 |
| - | - | - |
| orderAmount | String | 订单数量(以下面的coinName为单位计) |
| coinName | String | 订单币种 |
| billCode | String | 平台订单号 |
| orderStatus | Integer | 订单状态(0：预生成，1：支付完成，2：支付失败) |
| merchantSign | String | 用商家公钥RSA签名生成的商家签名 |

### 3. 实时推送商家回调: 使用方需提供商家回调接口，接收支付成功后的回调，支付平台向接收方发送 ***POST*** 请求。当支付成功时，实时回调商家来通知商家支付成功，(实时回调未成功，则支付平台会再次异步回调3次，3次未成功后，不再回调)请求参数如下:

#### 请求参数(Content-Type : application/json)  ####
| 参数 | 类型 | 描述 |
| - | - | - |
| merchantOrderCode| String | 商家订单号 |
| orderAmount | String | 订单数量(以下面的coinName为单位计) |
| coinName | String | 币种名称 |
| billCode | String | 订单号(此订单号为本平台的订单号) |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值说明:成功接收到支付平台推送后，需给支付平台以Json方式返回如下参数,支付平台将code为200视为推送成功。
``` 
	{"code":200}
```