# Android APP APAY 支付接口

## 1 介绍

本 `jar` 包用于商家在 `App` 应用中集成 `APAY` 支付功能。暂时只支持 `AndroidX` 版本。

## 2 如何使用

### 2.1 将 `jar` 包添加到项目 `app->libs` 目录下

```groovy
implementation files('libs/apayutils.jar')
```

因为本 `jar` 暂时使用 `kotlin` 编写，需要添加 `core-ktx` 依赖

```groovy
implementation "androidx.core:core-ktx:1.1.0"
```

### 2.2 发起支付

`java` 发起方式

```java
APayUtils.Companion.getInstance().goAPayment(this,"type","coinName","orderAmount","merchantId","merchantOrderCode","singnature");
```

`kotlin` 发起方式

```kotlin
APayUtils.instance.goAPayment(this@KotlinDemo,"type","coinName","orderAmount","merchantId","merchantOrderCode","singnature")
```

请求参数

| 参数              | 类型     | 描述                                                         |
| ----------------- | -------- | ------------------------------------------------------------ |
| mActivity         | Activity | 当前 Activity 对象                                           |
| type              | String   | pay(支付方式选择)、coinpay(币支付)、otcpay(OTC支付) 三种支付方式 |
| coinName          | String   | 币种名称。例如：”BTC”                                        |
| orderAmount       | String   | 购买数量                                                     |
| merchantId        | String   | 商户 appid                                                   |
| merchantOrderCode | String   | 商家订单号                                                   |
| singnature        | String   | 签名秘钥                                                     |

### 2.3 支付回调

```java
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != RESULT_OK) {
            return;
        }
        if (requestCode == APayUtils.PAY_REQUESTCODE) {
            int payStatus = data.getIntExtra("payStatus", 0);
            if (payStatus == APayUtils.PAY_SUCCESS) {
                ToastUtils.showShort("支付成功");
            } else if (payStatus == APayUtils.PAY_FAIL) {
                ToastUtils.showShort("支付还未成功,请前往APAY继续支付");
            } else {
                ToastUtils.showShort("支付异常");
            }
        }
    }
```

返回值

| 字段名                | 类型 | 描述                                            |
| --------------------- | ---- | ----------------------------------------------- |
| payStatus             | Int  | 用于在 onActivityResult 中获取支付状态的 key 值 |
| APayUtils.PAY_SUCCESS | Int  | 支付成功后返回的状态                            |
| APayUtils.PAY_FAIL    | Int  | 支付失败或取消后返回的状态                      |
