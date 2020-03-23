//
//  NSString+toDict.m
//  WXLogin
//
//  Created by wenwang wang on 2018/7/19.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "NSString+toDict.h"

@implementation NSString (json)

- (NSDictionary *)toDict {
    
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
