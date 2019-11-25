# Android APP APAY 支付接口

## 1 介绍

本 `jar` 包用于商家在 `App` 应用中集成 `APAY` 支付功能。支持 `Androidx` 和 `Support` 版本。

## 2 Androidx 集成使用方式

### 2.1 将 `apayutils_androidx.jar` 添加到项目 `app->libs` 目录下，如果有调整 `jar` 包目录请放置到调整后的目录内。

```groovy
implementation files('libs/apayutils_androidx.jar')
```

因为本 `jar` 使用 `kotlin` 编写，需要添加 `core-ktx` 依赖

```groovy
implementation "androidx.core:core-ktx:1.1.0"
```

请在项目的 ` build.gradle ` 文件中添加

```groovy
repositories {
	google()
}
```

### 2.2 发起支付

`java` 发起方式

```java
APayUtils.Companion.getInstance().goAPayment(this,"type","coinName","orderAmount","appid","merchantOrderCode","sign");
```

`kotlin` 发起方式

```kotlin
APayUtils.instance.goAPayment(this@KotlinDemo,"type","coinName","orderAmount","appid","merchantOrderCode","sign")
```

请求参数

| 参数              | 类型     | 描述                                                         |
| ----------------- | -------- | ------------------------------------------------------------ |
| mActivity         | Activity | 当前 Activity 对象                                           |
| type              | String   | pay(支付方式选择)、coinpay(币支付)、otcpay(OTC支付) 三种支付方式 |
| coinName          | String   | 币种名称。例如：”BTC”                                        |
| orderAmount       | String   | 购买数量                                                     |
| appId             | String   | 商户 appId                                                   |
| merchantOrderCode | String   | 商家订单号                                                   |
| sign              | String   | 签名                                                         |

`appId`申请地址请前往 [商户后台](https://api.apay.im/) 申请

## 3 Support 集成使用方式

### 3.1 将 `apayutils_support.jar` 添加到项目 `app->libs` 目录下，如果有调整 `jar` 包目录请放置到调整后的目录内。

```groovy
implementation files('libs/apayutils_support.jar')
```

### 3.2 发起支付

```java
APayUtils.getInstance().goAPayment(this,"type","coinName","orderAmount","appid","merchantOrderCode","sign");
```

请求参数同上

## 4 支付回调

***注意***：最终订单状态以调用接口为准，前端回调只做参考。

#### [查看接口回调](https://github.com/apaywallet/api#22%E6%9F%A5%E8%AF%A2%E5%95%86%E5%AE%B6%E8%AE%A2%E5%8D%95%E7%8A%B6%E6%80%81-v10querymerchantorderstatus)

#### Android 端回调

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
