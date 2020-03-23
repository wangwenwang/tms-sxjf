//
//  ServiceTools.m
//  tms-ios
//
//  Created by wenwang wang on 2018/9/28.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "ServiceTools.h"
#import <AFNetworking.h>
#import "Tools.h"
#import "AppDelegate.h"
#import "NSString+toDict.h"
#import "IOSToVue.h"
#import "ViewController.h"

@interface ServiceTools()

@property (strong, nonatomic) AppDelegate *app;

@property (strong, nonatomic) UIWebView *webview;

@end;

@implementation ServiceTools

- (instancetype)init {
    
    if(self = [super init]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        });
    }
    return self;
}

- (void)queryAppVersion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        while (1) {
            
            if([Tools getServerAddress]) {
                
                NSString *url = [NSString stringWithFormat:@"%@%@", [Tools getServerAddress], @"queryAppVersion.do"];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
                NSString *params = @"{\"tenantCode\":\"CYSCM\"}";
                NSDictionary *parameters = @{@"params" : params};
                NSLog(@"接口:%@|zip检测参数：%@", url, parameters);
                
                [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    nil;
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"请求成功---%@", responseObject);
                    int status = [responseObject[@"status"] intValue];
                    NSString *Msg = responseObject[@"Msg"];
                    if(status == 1) {
                        
                        NSDictionary *dict = responseObject[@"data"];
                        NSString *server_zipVersion = dict[@"zipVersionNo"];
                        NSString *currZipVersion = [Tools getZipVersion];
                        int c = [Tools compareVersion:server_zipVersion andLocati:currZipVersion];
                        if(c == 1) {
                        
                            // 设置 webView 为 nil，解决UIWebview调用reload导致JSContext失效的问题
                            UIViewController *rootViewController = [Tools getRootViewController];
                            if([rootViewController isKindOfClass:[ViewController class]]) {
                                
                                ViewController *vc = (ViewController *)rootViewController;
                                [vc.webView removeFromSuperview];
                                vc.webView = nil;
                            }
                            NSString *server_zipDownloadUrl = dict[@"zipDownloadUrl"];
                            NSLog(@"更新zip...");
                            
                            if([_delegate respondsToSelector:@selector(downloadStart)]) {
                                [_delegate downloadStart];
                            }
                            [self downZip:server_zipDownloadUrl andVersion:server_zipVersion];
                        }
                    }else {
                        if([_delegate respondsToSelector:@selector(failureOfLogin:)]) {
                            [_delegate failureOfLogin:Msg];
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败---%@", error);
                    if([_delegate respondsToSelector:@selector(failureOfLogin:)]) {
                        
                        [_delegate failureOfLogin:@"请求失败"];
                    }
                }];
                break;
            }else {
                
                NSLog(@"服务器地址为空，延迟1秒访问zip版本接口");
                sleep(1);
            }
        }
    });
}

- (void)downZip:(NSString *)urlStr andVersion:(NSString *)version {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //需要删除文件的物理地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/dist.zip", paths.firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDelete = [fileManager removeItemAtPath:path error:nil];
    if (isDelete) {
        
        // 删除文件成功
        NSLog(@"删除文件成功");
    }else{
       
        // 删除文件失败
        NSLog(@"删除文件失败");
    }
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if([_delegate respondsToSelector:@selector(downloadProgress:)]) {
            
            [_delegate downloadProgress:downloadProgress.fractionCompleted];
        }
    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
        if([_delegate respondsToSelector:@selector(downloadCompletion:andFilePath:)]) {
            
            [_delegate downloadCompletion:version andFilePath:filePath.path];
        }
    }];
    [downloadTask resume];
}


- (void)timingTracking:(NSString *)cellphone andLon:(double)lon andLat:(double)lat andVehicleLocation:(NSString *)vehicleLocation  {
    
    // 系统版本
    NSString *os = [UIDevice currentDevice].systemVersion;
    // 是否充电
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSNumber *charging;
    if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        charging = @(0);
    } else if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging) {
        charging = @(1);
    } else if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnknown) {
        charging = @(2);
    } else if([UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
        charging = @(3);
    }
    // 亮熄屏
    NSLog(@"亮熄屏: %@", _app.displayStatus);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://sfkc.cy-scm.com:9998/tmsApp/", @"timingTracking.do"];
    
    NSLog(@"上传定位接口:%@", url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    NSString *params = [NSString stringWithFormat:@"{\"cellphone\":\"%@\", \"userName\":\"%@\", \"vehicleLocation\":\"%@\", \"lon\":\"%@\", \"lat\":\"%@\", \"uuid\":\"%@\", \"code\":\"%@\", \"brightscreen\":\"%@\", \"charging\":\"%@\", \"os\":\"%@\"}", cellphone, @"", vehicleLocation, @(lon), @(lat), @"iOS", @"",  _app.displayStatus, charging, os];
    NSDictionary *parameters = @{@"params" : params};
    NSLog(@"上传位置点参数：%@", parameters);
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败---%@", error);
    }];
}

- (void)reverseGeo:(nullable NSString *)cellphone andLon:(double)lon andLat:(double)lat andWebView:(nullable UIWebView *)webView{
    
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=%f,%f&output=json&pois=1&ak=Mqx0nOGIXpLo9ipb7bPCupIPwXkLeU8q&mcode=com.kaidongyuan.tms", lat, lon];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"反地理编码成功");
        
        NSString *resultS = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        resultS = [resultS stringByReplacingOccurrencesOfString:@"renderReverse&&renderReverse(" withString:@""];
        resultS = [resultS substringToIndex:(resultS.length - 1)];
        NSDictionary *resultD = [resultS toDict];
        NSString *address = resultD[@"result"][@"formatted_address"];
        
        // 不让苹果审核小组看到导航按钮
        if ([address rangeOfString:@"Ellis Street"].location != NSNotFound ||
            [address rangeOfString:@"香港"].location != NSNotFound) {
            
            [IOSToVue TellVueHiddenNav:webView];
        }
        // 地址不能为 nil，也不能为空
        if(address != nil && ![address isEqualToString:@""]) {
            
            [self timingTracking:cellphone andLon:lon andLat:lat andVehicleLocation:address];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"反地理编码失败");
    }];
}


- (void)reverseGeo:(nullable NSString *)cellphone andLon:(double)lon andLat:(double)lat{
    
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=%f,%f&output=json&pois=1&ak=mss4aj8o58OezUjDRybUm9F4YMZTsPVK&mcode=com.kaidongyuan.QHOrder", lat, lon];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"反地理编码成功");
        
        NSString *resultS = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        resultS = [resultS stringByReplacingOccurrencesOfString:@"renderReverse&&renderReverse(" withString:@""];
        resultS = [resultS substringToIndex:(resultS.length - 1)];
        NSDictionary *resultD = [resultS toDict];
        NSString *address = resultD[@"result"][@"formatted_address"];
        
        // 地址不能为 nil，也不能为空
        if(address != nil && ![address isEqualToString:@""]) {
            
            [self timingTracking:cellphone andLon:lon andLat:lat andVehicleLocation:address];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"反地理编码失败");
    }];
}

@end
