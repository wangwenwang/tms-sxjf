//
//  NSDictionary+toString.m
//  wms-ios
//
//  Created by wenwang wang on 2018/7/20.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import "NSDictionary+toString.h"

@implementation NSDictionary (toString)

- (NSString *)toString {
    
    NSString *jsonString = @"";
    if ([NSJSONSerialization isValidJSONObject:self]){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
    
//    NSString *jsonString = [[NSString alloc]init];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    if (! jsonData) {
//        NSLog(@"error: %@", error);
//    } else {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//
//    //    NSRange range = {0,jsonString.length};
//    //    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
//
//    NSRange range2 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
//
//    NSRange range3 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\\"withString:@""options:NSLiteralSearch range:range3];
//
//    NSRange range4 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\r"withString:@""options:NSLiteralSearch range:range4];
//
//    NSRange range5 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\t"withString:@""options:NSLiteralSearch range:range5];
//
//    NSRange range6 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\r\n"withString:@""options:NSLiteralSearch range:range6];
//
//    NSRange range7 = {0,mutStr.length};
//    [mutStr replaceOccurrencesOfString:@"\r\t"withString:@""options:NSLiteralSearch range:range7];
//
//    NSString *fff = [mutStr stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
//
//    fff = [fff stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
//
//    return @"fff";
}


- (NSString *)descriptionWithLocale:(id)locale {
    
    NSArray *allKeys = [self allKeys];
    
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\n "];
    
    int i = 0;
    for (NSString *key in allKeys) {
        
        id value= self[key];
        
        [str appendFormat:@"\t \"%@\" : ",key];
        
        // 字典和数组的value不加""
        if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            [str appendFormat:@"%@",value];
        } else {
            [str appendFormat:@"\"%@\"",value];
        }
        
        // 不是最后一个value加,
        if(i != allKeys.count - 1) {
            [str appendString:@","];
        }
        [str appendString:@"\n"];
        
        i++;
    }
    
    [str appendString:@"}"];
    
    return str;
}

@end
