//
//  PluginTest.h
//  HBuilder-Hello
//
//  Created by Mac Pro on 14-9-3.
//  Copyright (c) 2014年 DCloud. All rights reserved.
//

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>

#import "Tools.h"
#import "AppDelegate.h"
#import "ServiceTools.h"
#import <MapKit/MapKit.h>



@interface PGPluginTest : PGPlugin


- (void)PluginTestFunction:(PGMethod*)command;
- (void)PluginTestFunctionArrayArgu:(PGMethod*)command;

- (NSData*)PluginTestFunctionSync:(PGMethod*)command;
- (NSData*)PluginTestFunctionSyncArrayArgu:(PGMethod*)command;
@end
