//
//  ApayApiObject.h
//  apay
//
//  Created by Apay on 2019/10/17.
//  Copyright © 2019 Apay. All rights reserved.
//

#import <Foundation/Foundation.h>


enum  ApayErrCode {
    ApaySuccess           = 0,    /**< 支付成功    */
    ApayErrCodeSentFail   = -1,   /**< 支付失败    */
};

typedef enum PayType {
    ApayTypeCustomSelect           = 0,    /**< 选择页面    */
    ApayTypeTransfer               = 1,    /**< 转账支付    */
    ApayTypeOTC                    = 2,    /**< OTC支付    */
} PayType;


#pragma mark - BaseReq
/*! @brief 该类为Apay终端SDK所有请求类的基类
 *
 */
@interface ApayBaseReq : NSObject

/** 请求类型 */
@property (nonatomic, assign) int type;
/** 由用户Apay号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验Apay用户是否换号登录*/
@property (nonatomic, copy) NSString *openID;

@end

#pragma mark - BaseResp
/*! @brief 该类为Apay终端SDK所有响应类的基类
 *
 */
@interface ApayBaseResp : NSObject
/** 错误码 */
@property (nonatomic, assign) int errCode;
/** 错误提示字符串 */
@property (nonatomic, copy) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) int type;

@end


/*! @brief 第三方向Apay终端发起支付的消息结构体
 *
 *  第三方向Apay终端发起支付的消息结构体，Apay终端处理后会向第三方返回处理结果
 * @see PayResp
 */
@interface PayReq : ApayBaseReq

/** 币种名称 */
@property (nonatomic, copy) NSString *coinName;
/** 预支付订单 */
@property (nonatomic, copy) NSString *merchantOrderCode;
/** 订单金额 */
@property (nonatomic, copy) NSString *orderAmount;
/** 商户id */
@property (nonatomic, copy) NSString* businessId;
/** 支付类型 */ 
@property (nonatomic, assign) PayType payType;
/** 签名密钥, */
@property (nonatomic,copy) NSString *signSecret;
@end

