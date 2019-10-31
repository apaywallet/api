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

/*! @brief 发送一个sendApayReq后，收到Apay的回应
 *
 * 收到一个来自Apay的处理结果。调用一次sendApayReq后会收到onApayResp。
 */
- (void)onApayResp:(ApayBaseResp*_Nullable)resp;

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
 * 函数调用后，会切换到Apay的界面。第三方应用程序等待Apay返回onResp。Apay在异步处理完成后一定会调用onApayResp。
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)sendApayReq:(ApayBaseReq*_Nullable)req;

/*! @brief 检查Apay是否已被用户安装,前提是添加APAY的urlsechme到白名单
 *
 * @return Apay已安装返回YES，未安装返回NO。
 */
+ (BOOL)isAPAYAppInstalled;

/// 首先必须设置appid
+ (BOOL)registerApayApp:(NSString *_Nullable)appid;

/// 是否打印日志
+ (void)openLogs:(BOOL)isOpenLog;
@end

