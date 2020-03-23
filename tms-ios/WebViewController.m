//
//  NewViewController.m
//  HBuilder-Integrate
//
//  Created by EICAPITAN on 16/5/12.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "WebViewController.h"
#import "PDRToolSystem.h"
#import "PDRToolSystemEx.h"
#import "PDRCoreAppFrame.h"
#import "PDRCoreAppManager.h"
#import "PDRCoreAppWindow.h"
#import "PDRCoreAppInfo.h"

@interface WebViewController()
{
    PDRCoreAppFrame* appFrame;
}

@end

@implementation WebViewController

- (void)viewDidLoad
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    
    PDRCore*  pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil)
    {

        NSString* pFilePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath, @"Pandora/apps/H5A4057B2/www/index.html"];
        NSString* basePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath, @"Pandora/apps/"];
        [pCoreHandle start];

        appFrame = [[PDRCoreAppFrame alloc]initWithName:@"WebViewID1" loadURL:pFilePath baseURL:basePath frame:self.view.bounds];

        if (appFrame) {
            PDRCoreApp* activeApp= (PDRCoreApp*)pCoreHandle.appManager.activeApp;
            [activeApp.appWindow registerFrame:appFrame];

//            [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
            [self.view  addSubview:appFrame];
        }

    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)dealloc
{
    [[PDRCore Instance] setContainerView:nil];
}

@end
