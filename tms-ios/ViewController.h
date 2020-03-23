//
//  ViewController.h
//  tms-ios
//
//  Created by wenwang wang on 2018/9/10.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZipArchive.h>
#import <WXApi.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Tools.h"
#import <MapKit/MapKit.h>
#import "ServiceTools.h"
#import "AppDelegate.h"
#import "CheckOrderPathViewController.h"
#import "IOSToVue.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) UIWebView *webView;

- (void)addWebView;

@end

