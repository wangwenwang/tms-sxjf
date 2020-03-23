//
//  CheckPathService.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckPathServiceDelegate <NSObject>

@optional
- (void)success;

@optional
- (void)failure:(NSString *)msg;

@end

@interface CheckPathService : NSObject

@property (weak, nonatomic)id <CheckPathServiceDelegate> delegate;

/// 订单线路位置点集合
@property(strong, nonatomic) NSMutableArray *orderLocations;

/**
 * 获取订单线路位置点集合
 *
 * orderIdx: 订单的 idx
 *
 * httpresponseProtocol: 网络请求协议
 */
- (void)getOrderLocaltions:(NSString *)idx;

@end
