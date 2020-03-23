//
//  Tools.h
//  tms-ios
//
//  Created by wenwang wang on 2018/9/28.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Foundation/Foundation.h>

@interface Tools : NSObject

/// 获取zip版本号
+ (nullable NSString *)getZipVersion;


/// 设置zip版本号
+ (void)setZipVersion:(nullable NSString *)version;


/// 获取服务器地址
+ (nullable NSString *)getServerAddress;


/// 设置服务器地址
+ (void)setServerAddress:(nullable NSString *)baseUrl;


/// 版本号比较，1为服务器>本地，0为服务器=本地，-1为服务器<本地，-2为版本号不合法
+ (int)compareVersion:(nullable NSString *)server andLocati:(nullable NSString *)locati;


/// 获取解压zip路径
+ (nullable NSString *)getUnzipPath;


/// 关闭Webview编辑功能
+ (void)closeWebviewEdit:(nullable UIWebView *)_webView;


/// 打开Webview编辑功能
+ (void)openWebviewEdit:(nullable UIWebView *)_webView;


/// 判断是否允许定位
+ (BOOL)isLocationServiceOpen;


/// 判断网络状态
+ (BOOL)isConnectionAvailable;


/// 提示  参数:View    NSString
+ (void)showAlert:(nullable UIView *)view andTitle:(nullable NSString *)title;


/**
 提示带时间参数
 @param view  父窗口
 @param title 标题
 @param time  停留时间
 */
+ (void)showAlert:(nullable UIView *)view andTitle:(nullable NSString *)title andTime:(NSTimeInterval)time;


/// 设置上一次启动的版本号
+ (void)setLastVersion;


/// 获取上一次启动的版本号
+ (nullable NSString *)getLastVersion;


/// 获取当前版本号
+ (nullable NSString *)getCFBundleShortVersionString;


/// 检测位置权限
+ (void)skipLocationSettings;


/// 获取根控制器
+ (nullable UIViewController *)getRootViewController;


/// 获取是否进入过主页（判断检查定位权限延迟，第一次进入延迟时长至10秒，否则延迟3秒）
+ (nullable NSString *)getEnterTheHomePage;


/// 设置是否进入过主页（判断检查定位权限延迟，第一次进入延迟时长至10秒，否则延迟3秒）
+ (void)setEnterTheHomePage:(nullable NSString *)enter;


/// view 转 image
+ (nullable UIImage *)tg_makeImageWithView:(nullable UIView *)view withSize:(CGSize)size;


/// 生成条码
+ (nullable UIImage *)resizeCodeWithString:(nullable NSString *)text BCSize:(CGSize)size;


/// 生成二维码
+ (nullable UIImage *)createQRWithString:(nullable NSString *)text QRSize:(CGSize)size;


/// json转对象
+ (nullable id)jsonToObject:(nullable NSString *)json;


/// 获取当前时间  2020年2月 16日9时2分
+ (nullable NSString *)getDate;

@end
