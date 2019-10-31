//
//  ApayApi.h
//  apay
//
//  Created by Apay on 2019/10/17.
//  Copyright © 2019 Apay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApayApiObject.h"


@protocol ApayApiDelegate <NSObject>
@optional

/*! @brief 发送一个sendReq后，收到Apay的回应
 *
 * 收到一个来自Apay的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(ApayBaseResp*)resp;

@end

@interface ApayApi : NSObject

/*! @brief 处理Apay通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url Apay启动第三方应用时传递过来的URL
 * @param delegate  ApayApiDelegate对象，用来接收Apay触发的消息。
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(nullable id<ApayApiDelegate>)delegate;


/*! @brief 发送请求到Apay，等待Apay返回onResp
 *
 * 函数调用后，会切换到Apay的界面。第三方应用程序等待Apay返回onResp。Apay在异步处理完成后一定会调用onResp。支持以下类型
 * SendAuthReq、SendMessageToWXReq、PayReq等。
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)sendReq:(ApayBaseReq*)req;

/*! @brief 检查Apay是否已被用户安装,前提是添加APAY的urlsechme到白名单
 *
 * @return Apay已安装返回YES，未安装返回NO。
 */
+ (BOOL)isAPAYAppInstalled;

/// 首先必须设置appid
+ (BOOL)registerApp:(NSString *)appid;

/// 是否打印日志
+ (void)openLogs:(BOOL)isOpenLog;
@end

