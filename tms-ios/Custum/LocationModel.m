//
//  LocationModel.m
//  YBDriver
//
//  Created by 凯东源 on 16/9/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _IDX = @"";
        _CORDINATEX = 0.0;
        _CORDINATEY = 0.0;
        _ADDRESS = @"";
        _INSERT_DATE = @"";
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _IDX = dict[@"IDX"];
    _ADDRESS = dict[@"ADDRESS"];
    _INSERT_DATE = dict[@"INSERT_DATE"];
}

@end
