
## 所有API基础调用URL是: https://pay.6du.io (如API: /pay 实际请求URL为https://pay.6du.io/pay)

##### Response Body 参数说明如下:
|参数名称|注释|数据类型|
|:---:|:---:|:---:|
|code|返回码(200为成功)|Integer|
|message|返回信息|String|
|data|业务数据|Object|
---
返回示例如下: ***注意:*** 若无任何需要返回的数据时，data为空对象({"code":200, "message":"请求成功 ","data":{})  
```
{"code":200, "message":"请求成功 ","data":{...}}
```

## 1. 创建支付订单 /pay/v3.0/createPrePaymentBill 请求方式：POST

#### 请求参数(Content-Type : application/json)
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| subject | String | 商品标题 |
| coinName | String | 币种简称 |
| currencyName | String | 法币名称(目前只支持"CNY") |
| orderPrice | String | 购买金额(若为按数量购买，此字段填0) |
| tradeType | Integer | 购买类型(1为按数量购买，2为按金额购买) |
| quantity | String | 购买数量(若为按金额购买，此字段填0) |
| paymentProductCode | String | 支付产品代码 |
| requestTimestamp | Long | 请求时间戳(13位) |
| merchantId | String | 商家应用id |
| merchantOrderCode | String | 商家订单号 |
| merchantSign | String| 商家端签名 | 

***注意***：商家签名merchantSign生成规则:body中参数(除merchantSign之外)根据key升序排序后，按"key=value"组合，一对"key-value"之间用","分隔,
组合得到签名前明文串，用申请商家时的商家私钥对此明文串进行RSA签名(签名算法为SHA256withRSA)，即可得到签名

例如：body参数为 address = 0x123456789，orderId = ap201906250958001，那么根据key升序排列所得到的字符串为："address=0x1236547,
orderId=ap201906250958001",用商家私钥对此字符串进行RSA签名(签名算法为SHA256withRSA)，即可得到签名

#### 返回值(Content-Type : application/json)

| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| billCode | String | 平台订单号 |
| merchantSign | String | 商家签名 |
| unitPrice | String | 单价 |
| totalPrice | String | 总价 |
| coinName | String | 币种名称 |
| orderAmount | String | 数量 |
| acceptanceName | String | 承兑商名称 |
| paymentMethodCode | String | 支付方式代码( 0001 支付宝, 0002 微信, 0003 银行卡) |
| acceptPageUrl | String | 承接页url |
| showFeeAmount | String | 显示的手续费数量 |
| afterDiscountFeeAmount | String | 打折后的手续费数量 |

***注意*** : 需要验证merchantSign参数，验签通过后方可信任。(验签方法同上)

## 2. 查询商家订单状态 /pay/v2.0/queryPayPreOrderStatus 请求方式：POST
      
#### 请求参数(Content-Type : application/json) 
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantId | String | 商户APPID |
| merchantOrderCode| String | 商家订单号 |
| merchantSign | String | 商家签名(签名生成规则同上) |
      
#### 返回值(Content-Type : application/json) #### 
      
***注意***：查询订单状态返回后，请对响应参数进行签名校验，校验通过后方可信任
      
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| orderAmount | String | 订单数量(以下面的coinName为单位计) |
| coinName | String | 订单币种 |
| billCode | String | 平台订单号 |
| orderStatus | Integer | 订单状态(0：预生成，1：支付完成，2：支付失败) |
| merchantSign | String | 用商家公钥RSA签名生成的商家签名 |

### 3. 实时推送商家回调: 使用方需提供商家回调接口，接收支付成功后的回调，支付平台向接收方发送 ***POST*** 请求。当支付成功时，实时回调商家来通知商家支付成功，(实时回调未成功，则支付平台会再次异步回调3次，3次未成功后，不再回调)请求参数如下:

#### 请求参数(Content-Type : application/json)  ####
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantOrderCode| String | 商家订单号 |
| orderAmount | String | 订单数量(以下面的coinName为单位计) |
| coinName | String | 币种名称 |
| billCode | String | 订单号(此订单号为本平台的订单号) |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值说明:成功接收到支付平台推送后，需给支付平台以Json方式返回如下参数,支付平台将code为200视为推送成功。
``` 
{"code":200}
```

### 4. 商户端主动取消订单: /pay/v3.0/merchantCancelTakeOrder  请求方式: POST

#### 请求参数(Content-Type : application/json) 
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantId | String | 商户APP_ID |
| merchantOrderCode| String | 商户订单号 |
| merchantSign | String | 商户签名(签名生成规则同上) |
      
#### 返回值(Content-Type : application/json) #### 
无  

 ***
 
### 5.查询匹配总价(用户卖币，输入数量后，得到预计总价): /pay/v3.0/queryMatchingTotalPrice 请求方式:POST

#### 请求参数(Content-Type : application/json)
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantId | String | 商户app_id |
| coinName | String | 币种简称 |
| currencyName | String | 法币名称(目前只支持"CNY") |
| matchAmount | String | 待匹配数量 |
| paymentProductCode | String | 支付产品代码 |
| requestTimestamp | Long | 请求时间戳 |
| merchantSign | String | 商户签名 |

 #### 返回值(Content-Type : application/json)
 
 | 参数 | 类型 | 描述 |
 | :---: | :---: | :---: |
 | unitPrice | String | 单价 |
 | totalPrice | String | 总价 |
 | methodCode | String | 支付方式代码(支付宝0001，银行卡0003) |

### 6.发起卖币: /pay/v3.0/initialToSellCoin 请求方式:POST  

#### 请求参数(Content-Type : application/json)
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantId | String | 商户app_id |
| merchantOrderCode | String | 商户订单号 |
| coinName | String | 币种简称 |
| currencyName | String | 法币名称(目前只支持"CNY") |
| sellAmount | String | 交易数量 |
| paymentProductCode | String | 支付产品代码 |
| requestTimestamp | Long | 请求时间戳 |
| mobile | String | 手机号 |
| reallyName | String | 真实姓名 |
| account | String | 账号 |
| bankBranch | String | 银行加分行名称(若为支付宝方式此字段传"0001")，例如填 招商银行宣武门支行 |
| merchantSign | String | 商户签名 |

#### 返回值(Content-Type : application/json)
无
 
#### 7.商户端用户确认收款并放币: /pay/v3.0/confirmedReceiptAndCoinRelease 请求方式:POST

#### 请求参数(Content-Type : application/json)
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantId | String | 商户app_id |
| merchantOrderCode | String | 商户订单号 |
| requestTimestamp | Long | 请求时间戳 |
| merchantSign | String | 商户签名 |

#### 返回值(Content-Type : application/json)
无

#### 8. 卖币订单状态推送: 使用方需提供接收推送接口，接收卖币订单状态更新的回调，支付平台 向 商户 发送 ***POST*** 请求。

当卖币订单状态更新时(订单交易成功，或交易失败)，通知商户卖币订单最新状态  

同步回调未成功，则支付平台会再次异步回调3次(5分钟1次)，3次未成功后，不再回调。请求参数如下:  

#### 请求参数(Content-Type : application/json)  ####
| 参数 | 类型 | 描述 |
| :---: | :---: | :---: |
| merchantOrderCode| String | 商户订单号 |
| billCode | String | 订单号(此订单号为本平台的订单号) |
| sellAmount | String | 卖币数量(以下面的coinName为单位计) |
| coinName | String | 币种名称 |
| unitPrice | String | 单价(以CNY计) |
| orderPrice | String | 订单金额(以CNY计) |
| orderCurrentStatus | String | 订单当前状态(1为成功，2为失败) |
| merchantSign | String | 商家签名(签名生成规则同上) |

#### 返回值说明:成功接收到支付平台卖币订单状态推送后，需给支付平台以Json方式返回如下参数,支付平台将code为200视为推送成功。
``` 
{"code":200}
```