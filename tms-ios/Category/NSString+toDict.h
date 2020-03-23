//
//  NSString+toDict.h
//  WXLogin
//
//  Created by wenwang wang on 2018/7/19.
//  Copyright © 2018年 wenwang wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (json)

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @return 返回字典
 */
- (NSDictionary *)toDict;

@end
