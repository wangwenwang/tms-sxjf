//
//  LocationModel.h
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 位置点信息
@interface LocationModel : NSObject

///
@property (copy, nonatomic) NSString *IDX;

/////坐标的维度
//@property (assign, nonatomic) NSNumber *CORDINATEX;
//
/////坐标经度
//@property (assign, nonatomic) NSNumber *CORDINATEY;

///坐标经度
@property (assign, nonatomic) double CORDINATEX;

///坐标纬度
@property (assign, nonatomic) double CORDINATEY;

///坐标地址
@property (copy, nonatomic) NSString *ADDRESS;

///坐标生成时间
@property (copy, nonatomic) NSString *INSERT_DATE;

- (void)setDict:(NSDictionary *)dict;

@end
