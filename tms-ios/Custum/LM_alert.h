//
//  LM_alert.h
//  CMDriver
//
//  Created by 凯东源 on 17/2/6.
//  Copyright © 2017年 城马联盟. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  @brief 点击回调
 *
 *  @param index 点击的下标
 */
typedef void (^LMAlertViewClickedWithIndex)(NSInteger index);
/**
 *  @brief 点击确定按钮回调
 */
typedef void (^LMAlertViewOkClicked)();
/**
 *  @brief 点击取消按钮回调
 */
typedef void (^LMAlertViewCancelClicked)();

/**
 *  @brief 弹出框
 */
@interface LM_alert : NSObject

/**
 *  @brief 弹出提示框，点击返回点击下标
 *
 *  @param title             标题
 *  @param msg               提示信息
 *  @param cancelTitle       取消按钮文字
 *  @param okTitle           确定按钮文字
 *  @param otherTitleArray   其他按钮文字
 *  @param handle            点击回调
 */
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray clickHandle:(LMAlertViewClickedWithIndex) handle;
/**
 *  @brief 弹出提示框只有确定和取消按钮
 *
 *  @param title             标题
 *  @param msg               提示信息
 *  @param cancelTitle       取消按钮文字
 *  @param okTitle           确定按钮文字
 *  @param okHandle          点击确定回调
 *  @param cancelClickHandle 点击取消回调
 */
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle okClickHandle:(LMAlertViewOkClicked)okHandle cancelClickHandle:(LMAlertViewCancelClicked)cancelClickHandle;
/**
 *  @brief 弹出框，没有回调.
 *
 *  @param title             标题
 *  @param msg               提示信息
 *  @param cancelTitle       取消按钮文字
 *  @param okTitle           确定按钮文字
 *  @param otherTitleArray   其他按钮文字
 */
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray;

@end
