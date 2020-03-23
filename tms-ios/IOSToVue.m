//
//  IOSToVue.m
//  tms-ios
//
//  Created by wenwang wang on 2018/11/9.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "IOSToVue.h"

@implementation IOSToVue

+ (void)TellVueMsg:(nullable UIWebView *)webView andJsStr:(nullable NSString *)jsStr {
    
    NSLog(@"%@",jsStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    });
}

+ (void)TellVueHiddenNav:(nullable UIWebView *)webView {
    
    NSString *jsStr = [NSString stringWithFormat:@"HiddenNav('')"];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueDevice:(nullable UIWebView *)webView andDevice:(nullable NSString *)dev {
    
    NSString *jsStr = [NSString stringWithFormat:@"Device_Ajax('%@')",dev];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueWXBind_YES_Ajax:(nullable UIWebView *)webView andParamsEncoding:(nullable NSString *)paramsEncoding {
    
    NSString *jsStr = [NSString stringWithFormat:@"WXBind_YES_Ajax('%@')",paramsEncoding];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueWXBind_NO_Ajax:(nullable UIWebView *)webView andOpenid:(nullable NSString *)openid {
    
    NSString *jsStr = [NSString stringWithFormat:@"WXBind_NO_Ajax('%@')",openid];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueWXInstall_Check_Ajax:(nullable UIWebView *)webView andIsInstall:(nullable NSString *)isInstall {
    
    NSString *jsStr = [NSString stringWithFormat:@"WXInstall_Check_Ajax('%@')",isInstall];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueVersionShow:(nullable UIWebView *)webView andVersion:(nullable NSString *)version {
    
    NSString *jsStr = [NSString stringWithFormat:@"VersionShow('%@')",version];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

+ (void)TellVueCurrAddress:(nullable UIWebView *)webView andAddress:(nullable NSString *)address {
    
    NSString *jsStr = [NSString stringWithFormat:@"CurrAddress('%@')",address];
    [IOSToVue TellVueMsg:webView andJsStr:jsStr];
}

@end
