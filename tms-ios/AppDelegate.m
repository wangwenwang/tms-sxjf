//
//  AppDelegate.m
//  tms-ios
//
//  Created by wenwang wang on 2018/9/10.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "AppDelegate.h"
#import <WXApi.h>
#import <AFNetworking.h>
#import "NSString+toDict.h"
#import "NSDictionary+toString.h"
#import "ViewController.h"
#import "ServiceTools.h"
#import "Tools.h"
#import "LMProgressView.h"
#import <ZipArchive.h>
#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKGeneralDelegate.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <notify.h>
#import "ViewController.h"
#import "PDRCore.h"
#import "WebViewController.h"

@interface AppDelegate ()<WXApiDelegate, ServiceToolsDelegate, BMKGeneralDelegate>{
    BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, strong)LMProgressView *progressView;

@property (nonatomic, strong)UIView *downView;

@end

@implementation AppDelegate

static void updateEnabled(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.displayStatus = [NSString stringWithFormat:@"%lld", state];
    NSLog(@"屏幕状态：%llu",state);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    // 接收webview
//    [self addNotification];
//
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor greenColor];
    WebViewController *mainView = [[WebViewController alloc] init];
    _window.rootViewController = mainView;
//    [_window makeKeyAndVisible];
//
//    // 默认亮屏
    _displayStatus = @"1";
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, updateEnabled, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
//
//    // 注册微信凭证
//    [WXApi registerApp:WXAPPID];
//
//    // 百度地图
    _mapManager = [[BMKMapManager alloc] init];
//    // 创云司机宝   Mqx0nOGIXpLo9ipb7bPCupIPwXkLeU8q
    BOOL ret = [_mapManager start:@"1h8LhT31kmaeNZnDXXytPVjB11C1NNPt"  generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图加载失败！");
    }else {
        NSLog(@"百度地图加载成功！");
    }
//
//    // 检查HTML zip 是否有更新
//    [self checkZipVersion];
    
//    return YES;
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
    
    return [PDRCore initEngineWihtOptions:launchOptions withRunMode:PDRCoreRunModeWebviewClient];
}


- (void)checkZipVersion {
    
    NSString *currVersion = [Tools getZipVersion];
    if(currVersion == nil) {
        NSLog(@"初次检查zip版本，设置默认");
        [Tools setZipVersion:kUserDefaults_ZipVersion_local_defaultValue];
    }else{
        NSLog(@"本地zip版本：%@", currVersion);
    }
    
    ServiceTools *s = [[ServiceTools alloc] init];
    s.delegate = self;
    UIViewController *rootViewController = _window.rootViewController;
    if([rootViewController isKindOfClass:[ViewController class]]) {
        
        [s queryAppVersion];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:self];
}

// 授权回调的结果
- (void)onResp:(BaseResp *)resp {
    
    NSLog(@"resp:%d", resp.errCode);
    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *rep = (SendAuthResp *)resp;
        if(resp.errCode == -2) {
            
            NSLog(@"用户取消");
        }else if(resp.errCode == -4) {
            
            NSLog(@"用户拒绝授权");
        }else {
            
            NSString *code = rep.code;
            NSString *appid = WXAPPID;
            NSString *appsecret = WXAPPSECRED;
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appid, appsecret, code];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *result = [[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] toDict];
                NSString *access_token = result[@"access_token"];
                NSString *openid = result[@"openid"];
                [self wxLogin:access_token andOpenid:openid];
                NSLog(@"请求access_token成功");
                [self bindingWX:openid];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"请求access_token失败");
            }];
        }
    }
}


// 获取tms用户信息
- (void)bindingWX:(NSString *)openid {
    
    NSString *params = [NSString stringWithFormat:@"{\"wxOpenid\":\"%@\"}", openid];
    NSString *paramsEncoding = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@login.do?params=%@", [Tools getServerAddress], paramsEncoding];
    NSLog(@"请求tms用户信息参数：%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] toDict];
        
        int status = [result[@"status"] intValue];
        id data = result[@"data"];
        NSString *Msg = result[@"Msg"];
        
        if(status == 1) {
            
            NSString *params = [result toString];
            NSString *paramsEncoding = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [IOSToVue TellVueWXBind_YES_Ajax:_webView andParamsEncoding:paramsEncoding];
            NSLog(@"请求tms用户信息成功");
        } else if(status == 3){
            
            if([data isKindOfClass:[NSString class]]) {
                
                [IOSToVue TellVueWXBind_NO_Ajax:_webView andOpenid:openid];
                NSLog(@"此微信未注册");
            }
        }else {
            
            NSLog(@"%@", Msg);
        }
        NSLog(@"%@", result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求wms用户信息失败");
    }];
}


// 获取微信个人信息
- (void)wxLogin:(NSString *)access_token andOpenid:(NSString *)openid {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", access_token, openid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result =[[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] toDict];
        NSLog(@"请求个人信息成功");
        NSLog(@"%@", result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求个人信息失败");
    }];
}


#pragma mark - ServiceToolsDelegate

// 开始下载zip
- (void)downloadStart {
    
    if(!_downView) {
        _downView = [[UIView alloc] init];
    }
    [_downView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_downView setBackgroundColor:RGB(145, 201, 249)];
    [_window addSubview:_downView];
    
    _progressView = [[LMProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_window.frame), CGRectGetHeight(_window.frame))];
    [_downView addSubview:_progressView];
}

// 下载zip进度
- (void)downloadProgress:(double)progress {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _progressView.progress = progress;
    });
}

// 下载zip完成
- (void)downloadCompletion:(NSString *)version andFilePath:(NSString *)filePath {
    
    NSLog(@"解压中...");
    NSString *unzipPath = [Tools getUnzipPath];
    BOOL unzip_b = [SSZipArchive unzipFileAtPath:filePath toDestination:unzipPath];
    if(unzip_b) {
        
        NSLog(@"解压完成，开始刷新APP内容...");
    }else {
        
        NSLog(@"解压失败");
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"延迟0.5秒");
        usleep(500000);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *rootViewController = [Tools getRootViewController];
            if([rootViewController isKindOfClass:[ViewController class]]) {
                
                ViewController *vc = (ViewController *)rootViewController;
                [vc addWebView];
            } 
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _downView.alpha = 0.0f;
            }completion:^(BOOL finished){
                
                [_downView removeFromSuperview];
                if(unzip_b) {
                    
                    [Tools setZipVersion:version];
                }else {
                    
                    NSLog(@"zip解压失败，不更新zip版本号");
                }
            }];
            NSLog(@"刷新内容完成");
        });
    });
}

#pragma mark - BMKGeneralDelegate
// 百度地图获取网络连接状态
- (void)onGetNetworkState:(int)iError {
    if(iError == 0) {
        NSLog(@"联网成功");
    }else {
        NSLog(@"联网失败，错误代码：Error:%d", iError);
    }
}

// 百度地图key是否正确能够连接
- (void)onGetPermissionState:(int)iError {
    if (iError == 0) {
        NSLog(@"授权成功");
    }else{
        NSLog(@"授权失败，错误代码：Error:%d", iError);
    }
}


#pragma mark - 通知

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWebView:) name:kReceive_WebView_Notification object:nil];
}

- (void)receiveWebView:(NSNotification *)aNotification {
    
    _webView = aNotification.userInfo[@"webView"];
}

@end
