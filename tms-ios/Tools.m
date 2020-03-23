//
//  Tools.m
//  tms-ios
//
//  Created by wenwang wang on 2018/9/28.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "Tools.h"
#import <MBProgressHUD.h>
#import "LM_alert.h"
#import "AppDelegate.h"

@implementation Tools

+ (nullable NSString *)getZipVersion {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaults_ZipVersion_local_key];
}

+ (void)setZipVersion:(nullable NSString *)version {
    
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kUserDefaults_ZipVersion_local_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (nullable NSString *)getServerAddress {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaults_Server_Address_key];
}

+ (void)setServerAddress:(nullable NSString *)baseUrl {
    
    [[NSUserDefaults standardUserDefaults] setObject:baseUrl forKey:kUserDefaults_Server_Address_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)compareVersion:(nullable NSString *)server andLocati:(nullable NSString *)locati {
    NSArray *servers = [server componentsSeparatedByString:@"."];
    NSArray *locatis = [locati componentsSeparatedByString:@"."];
    @try {
        int s = [servers[0] intValue] * 100 + [servers[1] intValue] * 10 + [servers[2] intValue] * 1;
        int l = [locatis[0] intValue] * 100 + [locatis[1] intValue] * 10 + [locatis[2] intValue] * 1;
        if(s == l) return 0;
        else return (s > l) ? 1 : -1;
    } @catch (NSException *exception) {
        return -2;
    }
}

+ (nullable NSString *)getUnzipPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *unzipPath = [documentpath stringByAppendingPathComponent:@"/unzip"];
    return unzipPath;
}

+ (void)closeWebviewEdit:(nullable UIWebView *)_webView {
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

+ (void)openWebviewEdit:(nullable UIWebView *)_webView {
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='text';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='text';"];
}

+ (BOOL)isLocationServiceOpen {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

+ (void)showAlert:(nullable UIView *)view andTitle:(nullable NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.margin = 15.0f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showAlert:(nullable UIView *)view andTitle:(nullable NSString *)title andTime:(NSTimeInterval)time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.margin = 15.0f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:time];
}

+ (void)setLastVersion {
    
    NSString *app_version = [self getCFBundleShortVersionString];
    [[NSUserDefaults standardUserDefaults] setValue:app_version forKey:kUserDefaults_Last_Version_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (nullable NSString *)getLastVersion {
    
     return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaults_Last_Version_key];
}

+ (nullable NSString *)getCFBundleShortVersionString {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (void)skipLocationSettings {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *promptLocation = [NSString stringWithFormat:@"请打开系统设置中\"隐私->定位服务\",允许%@使用定位服务", AppDisplayName];
    [LM_alert showLMAlertViewWithTitle:@"打开定位开关" message:promptLocation cancleButtonTitle:nil okButtonTitle:@"立即设置" otherButtonTitleArray:nil clickHandle:^(NSInteger index) {
        if(SystemVersion > 8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            [self showAlert:app.window andTitle:@"不支持iOS及以下设备"];
        }
    }];
}

+ (nullable UIViewController *)getRootViewController {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = app.window.rootViewController;
    return rootViewController;
}

+ (nullable NSString *)getEnterTheHomePage {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaults_EnterTheHomePage];
}


+ (void)setEnterTheHomePage:(nullable NSString *)enter {
    
    [[NSUserDefaults standardUserDefaults] setObject:enter forKey:kUserDefaults_EnterTheHomePage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (nullable UIImage *)tg_makeImageWithView:(nullable UIView *)view withSize:(CGSize)size {
    // 下面方法，第一个参数表示区域大小。
    // 第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
    // 第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 *  生成条形码
 *
 *  @return 生成条形码的UIImage对象
 */
+ (nullable UIImage *)resizeCodeWithString:(nullable NSString *)text BCSize:(CGSize)size {
    CIImage *image = [self generateBarCodeImage:text];
    return [self resizeCodeImage:image withSize:size];
}

+ (nullable CIImage *)generateBarCodeImage:(nullable NSString *)source {
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 注意生成条形码的编码方式
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        // 设置生成的条形码的上，下，左，右的margins的值
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}

+ (nullable UIImage *)resizeCodeImage:(nullable CIImage *)image withSize:(CGSize)size {
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        UIImage *barImage = [UIImage imageWithCGImage:imageRefResized];

        //Core Foundation 框架下内存泄露问题。
        CGContextRelease(contentRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGImageRelease(imageRefResized);
        return barImage;
    }else{
        return nil;
    }
}

+ (nullable UIImage *)createQRWithString:(nullable NSString *)text QRSize:(CGSize)size {
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
     //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:[UIColor blackColor].CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:[UIColor whiteColor].CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (nullable id)jsonToObject:(nullable NSString *)json {
    //string转data
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //json解析
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}

+ (nullable NSString *)getDate {
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
     NSCalendarUnitMonth |  NSCalendarUnitDay |
     NSCalendarUnitHour |  NSCalendarUnitMinute |
     NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
     fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    NSLog(@"现在是%ld月 " , comp.month);
    NSLog(@"现在是%ld日" , comp.day);
    NSLog(@"现在是%ld时" , comp.hour);
    NSLog(@"现在是%ld分" , comp.minute);
    NSLog(@"现在是%ld秒" , comp.second);
    NSLog(@"现在是星期%ld" , comp.weekday);
    // 再次创建一个NSDateComponents对象
//    NSDateComponents* comp2 = [[NSDateComponents alloc]
//     init];
//    // 设置各时间字段的数值
//    comp2.year = 2013;
//    comp2.month = 4;
//    comp2.day = 5;
//    comp2.hour = 18;
//    comp2.minute = 34;
//    // 通过NSDateComponents所包含的时间字段的数值来恢复NSDate对象
//    NSDate *date = [gregorian dateFromComponents:comp2];
//    NSLog(@"获取的日期为：%@" , date);
    
    
//    NSString *year = @"";
//    NSString *month = @"";
//    NSString *day = @"";
//    NSString *hour = @"";
//    NSString *minute = @"";
//    if(comp.year < 10){
//        year
//    }
    NSString *s = [NSString stringWithFormat:@"%ld年%ld月 %ld日%ld时%ld分", (long)comp.year, (long)comp.month, (long)comp.day, (long)comp.hour, (long)comp.minute];
    return s;
}

@end
