//
//  IB_Border.h
//  tms-ios
//
//  Created by wangww on 2020/3/16.
//  Copyright © 2020 wangziting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE  // 动态刷新

@interface IB_Border : UIView

// 注意: 加上IBInspectable就可以可视化显示相关的属性
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
///** 可视化设置边框颜色 */
//@property (nonatomic, strong)IBInspectable UIColor *borderColor;
///** 可视化设置圆角 */
//@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
