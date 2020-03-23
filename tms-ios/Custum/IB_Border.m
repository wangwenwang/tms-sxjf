//
//  IB_Border.m
//  tms-ios
//
//  Created by wangww on 2020/3/16.
//  Copyright © 2020 wangziting. All rights reserved.
//

#import "IB_Border.h"

@implementation IB_Border

#pragma mark - 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    
    self.layer.borderWidth = borderWidth;
}

//#pragma mark - 设置边框颜色
//- (void)setBorderColor:(UIColor *)borderColor {
//
//    self.layer.borderColor = borderColor.CGColor;
//}
//
//#pragma mark - 设置圆角
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//
//    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = cornerRadius > 0;
//}
@end
