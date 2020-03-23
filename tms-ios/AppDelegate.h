//
//  AppDelegate.h
//  tms-ios
//
//  Created by wenwang wang on 2018/9/10.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *cellphone;

@property (strong, nonatomic) NSString *displayStatus;

@property (strong, nonatomic) NSString *app_version;

// 最近一次位置
@property (assign, nonatomic) CLLocationCoordinate2D currLatlng;

@property (strong, nonatomic) UINavigationController *rootViewController;

@end

